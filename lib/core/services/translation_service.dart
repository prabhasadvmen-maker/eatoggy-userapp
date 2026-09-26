// import 'dart:convert';
// import 'package:dio/dio.dart';
// import '../constants/api_constants.dart';
// import '../services/api_service.dart';
// import '../services/storage_service.dart';
// import '../../data/models/requests/translation_request.dart';
// import '../../data/models/responses/translation_response.dart';
// import '../../data/models/requests/translate_batch_request.dart';
// import '../../data/models/responses/translate_batch_response.dart';

// class TranslationService {
//   static final TranslationService _instance = TranslationService._internal();
//   factory TranslationService() => _instance;
//   TranslationService._internal();

//   static TranslationService get instance => _instance;

//   // In-memory cache: "sourceLang:targetLang:text" -> translatedText
//   final Map<String, String> _cache = {};

//   String _currentLanguage = 'en-IN';
//   String get currentLanguage => _currentLanguage;

//   Future<void> init({String defaultLanguage = 'en-IN'}) async {
//     _currentLanguage = defaultLanguage;
//     final prefs = await SharedPreferencesService.getInstance();
//     final savedLang = prefs.getString('selectedLanguageCode');
//     if (savedLang != null && savedLang.isNotEmpty) {
//       _currentLanguage = savedLang;
//     }
//   }

//   /// Translates a single text string using Norozz Backend API.
//   Future<String> translate({
//     required String text,
//     required String sourceLanguage,
//     required String targetLanguage,
//   }) async {
//     final trimmedText = text.trim();
//     if (trimmedText.isEmpty) return text;

//     if (sourceLanguage.trim().toLowerCase() == targetLanguage.trim().toLowerCase()) {
//       return text;
//     }

//     final cacheKey = '${sourceLanguage.trim()}:${targetLanguage.trim()}:$trimmedText';
//     if (_cache.containsKey(cacheKey)) {
//       return _cache[cacheKey]!;
//     }

//     try {
//       final requestBody = TranslationRequest(
//         text: trimmedText,
//         sourceLanguage: sourceLanguage.trim(),
//         targetLanguage: targetLanguage.trim(),
//       );

//       final response = await ApiService.dio.post(
//         ApiConstants.translate,
//         data: requestBody.toJson(),
//       );

//       if (response.data is Map<String, dynamic>) {
//         final translationResp = TranslationResponse.fromJson(response.data as Map<String, dynamic>);
        
//         if (translationResp.success == true &&
//             translationResp.translatedText != null &&
//             translationResp.translatedText!.trim().isNotEmpty) {
//           final result = translationResp.translatedText!.trim();
//           _cache[cacheKey] = result;
//           await savePersistentTranslations(targetLanguage, {trimmedText: result});
//           return result;
//         }
//       }
//     } catch (_) {}
//     return text;
//   }

//   /// Batch translates a list of texts using POST /api/translation/translate-batch
//   Future<Map<String, String>> translateBatch({
//     required List<String> texts,
//     String sourceLanguage = 'en-IN',
//     required String targetLanguage,
//   }) async {
//     if (texts.isEmpty) return {};

//     if (sourceLanguage.trim().toLowerCase() == targetLanguage.trim().toLowerCase()) {
//       return {for (var t in texts) t: t};
//     }

//     final Map<String, String> resultMap = {};
//     final List<String> missingTexts = [];

//     // Load disk cache into memory if available
//     final diskCache = await loadPersistentTranslations(targetLanguage);
//     resultMap.addAll(diskCache);

//     for (final t in texts) {
//       final cacheKey = '${sourceLanguage.trim()}:${targetLanguage.trim()}:$t';
//       if (_cache.containsKey(cacheKey)) {
//         resultMap[t] = _cache[cacheKey]!;
//       } else if (resultMap.containsKey(t)) {
//         _cache[cacheKey] = resultMap[t]!;
//       } else {
//         missingTexts.add(t);
//       }
//     }

//     if (missingTexts.isEmpty) {
//       return resultMap;
//     }

//     const int chunkSize = 15;
//     final List<List<String>> chunks = [];
//     for (var i = 0; i < missingTexts.length; i += chunkSize) {
//       chunks.add(
//         missingTexts.sublist(
//           i,
//           i + chunkSize > missingTexts.length ? missingTexts.length : i + chunkSize,
//         ),
//       );
//     }

//     final Map<String, String> newlyTranslated = {};

//     await Future.wait(
//       chunks.map((chunk) async {
//         try {
//           final req = TranslateBatchRequest(
//             texts: chunk,
//             sourceLanguage: sourceLanguage.trim(),
//             targetLanguage: targetLanguage.trim(),
//           );

//           final response = await ApiService.dio.post(
//             ApiConstants.translateBatch,
//             data: req.toJson(),
//           );

//           if (response.data is Map) {
//             final resp = TranslateBatchResponse.fromJson(
//               Map<String, dynamic>.from(response.data as Map),
//             );

//             if (resp.translations.isNotEmpty) {
//               resp.translations.forEach((src, translated) {
//                 final cacheKey = '${sourceLanguage.trim()}:${targetLanguage.trim()}:$src';
//                 _cache[cacheKey] = translated;
//                 resultMap[src] = translated;
//                 newlyTranslated[src] = translated;
//               });
//             }
//           }
//         } catch (_) {
//           for (final t in chunk) {
//             if (!resultMap.containsKey(t)) {
//               resultMap[t] = t;
//             }
//           }
//         }
//       }),
//     );

//     if (newlyTranslated.isNotEmpty) {
//       await savePersistentTranslations(targetLanguage, newlyTranslated);
//     }

//     return resultMap;
//   }

//   /// Save persistent translations for offline / app restarts
//   Future<void> savePersistentTranslations(String langCode, Map<String, String> newTranslations) async {
//     try {
//       final prefs = await SharedPreferencesService.getInstance();
//       final storageKey = 'translations_cache_${langCode.toLowerCase()}';
//       final existingJsonString = prefs.getString(storageKey);
//       Map<String, dynamic> existingMap = {};
//       if (existingJsonString != null && existingJsonString.isNotEmpty) {
//         existingMap = jsonDecode(existingJsonString) as Map<String, dynamic>;
//       }
//       existingMap.addAll(newTranslations);
//       await prefs.setString(storageKey, jsonEncode(existingMap));
//     } catch (_) {}
//   }

//   /// Load persistent translations from disk
//   Future<Map<String, String>> loadPersistentTranslations(String langCode) async {
//     try {
//       final prefs = await SharedPreferencesService.getInstance();
//       final storageKey = 'translations_cache_${langCode.toLowerCase()}';
//       final jsonString = prefs.getString(storageKey);
//       if (jsonString != null && jsonString.isNotEmpty) {
//         final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
//         final Map<String, String> result = {};
//         decoded.forEach((key, value) {
//           result[key] = value.toString();
//           _cache['en-IN:$langCode:$key'] = value.toString();
//         });
//         return result;
//       }
//     } catch (_) {}
//     return {};
//   }

//   String getTranslation(String text, {String? lang}) {
//     final language = lang ?? _currentLanguage;
//     if (language == 'en-IN' || language == 'en') return text;
//     final cacheKey = 'en-IN:$language:$text';
//     return _cache[cacheKey] ?? text;
//   }

//   void clearCache() {
//     _cache.clear();
//   }
// }
