import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../constants/app_keys.dart';
import '../utils/logger.dart';
import '../utils/session_manager.dart';
import 'storage_service.dart';

class ApiService {
  static final Dio dio =
      Dio(
          BaseOptions(
            // baseUrl: ApiConstants.baseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/json",
            },
          ),
        )
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) async {
              final startTime = DateTime.now();
              options.extra['startTime'] = startTime;
              // Load token from SharedPreferences
              final prefs = await SharedPreferencesService.getInstance();
              final token = prefs.getString(AppKeys.accessToken);

              // Add Bearer token if available
              if (token != null && token.isNotEmpty) {
                options.headers['Authorization'] = 'Bearer $token';
                appLog("🔐 Bearer Token attached");
              }

              dynamic dataToLog = options.data;
              if (options.data is FormData) {
                final formData = options.data as FormData;
                final fieldsMap = Map.fromEntries(formData.fields);
                final filesMap = Map.fromEntries(
                  formData.files.map((f) => MapEntry(f.key, f.value.filename ?? 'File')),
                );
                dataToLog = {
                  if (fieldsMap.isNotEmpty) 'fields': fieldsMap,
                  if (filesMap.isNotEmpty) 'files': filesMap,
                };
              }

              appLog("📤 REQUEST → ${options.method} ${options.uri}");
              appLog("🔸 Headers: ${options.headers}");
              appLog("🔸 Data: $dataToLog");
              appLog("⏱️ Started at: $startTime");

              return handler.next(options);
            },

            onResponse: (response, handler) {
              final startTime =
                  response.requestOptions.extra['startTime'] as DateTime?;
              final duration = startTime != null
                  ? DateTime.now().difference(startTime)
                  : null;
              appLog(
                "✅ RESPONSE ← ${response.statusCode} ${response.requestOptions.uri}",
              );
              appLog("📦 Response Data: ${response.data}");
              if (duration != null) {
                appLog(
                  "⏳ API Duration: ${duration.inMilliseconds} ms (${duration.inSeconds}s)",
                );
              }
              return handler.next(response);
            },

            onError: (DioException e, handler) async {
              final startTime =
                  e.requestOptions.extra['startTime'] as DateTime?;
              final duration = startTime != null
                  ? DateTime.now().difference(startTime)
                  : null;

              appLog(
                "❌ ERROR ← ${e.response?.statusCode} ${e.requestOptions.uri}",
              );
              if (duration != null) {
                appLog(
                  "⏱️ API failed after: ${duration.inMilliseconds} ms (${duration.inSeconds}s)",
                );
              }
              if (e.response?.statusCode == 401) {
                if (e.requestOptions.path.contains('/customer/auth/refresh-token')) {
                  appLog("🚨 Refresh token endpoint returned 401 - forcing logout");
                  await SessionManager.forceLogout();
                  return handler.next(e);
                }

                final prefs = await SharedPreferencesService.getInstance();
                final storedRefreshToken = prefs.getString(AppKeys.refreshToken);

                if (storedRefreshToken != null && storedRefreshToken.isNotEmpty) {
                  appLog("🔄 401 Unauthorized received. Attempting token refresh...");
                  try {
                    final refreshDio = Dio(
                      BaseOptions(
                        connectTimeout: const Duration(seconds: 15),
                        receiveTimeout: const Duration(seconds: 15),
                        headers: {
                          "Accept": "application/json",
                          "Content-Type": "application/json",
                        },
                      ),
                    );

                    final refreshResponse = await refreshDio.post(
                      ApiConstants.refreshToken,
                      data: {"token": storedRefreshToken},
                    );

                    if (refreshResponse.statusCode == 200 &&
                        refreshResponse.data != null &&
                        refreshResponse.data['success'] == true) {
                      final newAccessToken = refreshResponse.data['data']?['accessToken'];
                      if (newAccessToken != null && newAccessToken is String && newAccessToken.isNotEmpty) {
                        appLog("✅ Access token refreshed successfully! Retrying request...");
                        await prefs.setString(AppKeys.accessToken, newAccessToken);

                        final retryOptions = e.requestOptions;
                        retryOptions.headers['Authorization'] = 'Bearer $newAccessToken';
                        final response = await dio.fetch(retryOptions);
                        return handler.resolve(response);
                      }
                    }
                  } catch (refreshErr) {
                    appLog("❌ Refresh token call failed: $refreshErr");
                  }
                }

                appLog("🚨 401 Unauthorized & refresh token unavailable/expired - forcing logout");
                await SessionManager.forceLogout();
                return handler.next(e);
              }

              if (e.type == DioExceptionType.connectionTimeout ||
                  e.type == DioExceptionType.receiveTimeout) {
                appLog(
                  "⚠️ Timeout: The API took too long to respond (>${e.requestOptions.receiveTimeout}).",
                );

                // 🟢 Retry logic starts here
                try {
                  appLog("🔁 Retrying request once due to timeout...");
                  final retryOptions = e.requestOptions;
                  // Optional: Increase timeout for retry
                  retryOptions.connectTimeout = const Duration(seconds: 30);
                  retryOptions.receiveTimeout = const Duration(seconds: 30);

                  final response = await dio.fetch(retryOptions);
                  appLog(
                    "✅ Retry succeeded with status ${response.statusCode}",
                  );
                  return handler.resolve(response);
                } catch (retryError) {
                  appLog("❌ Retry failed too: $retryError");
                  if (retryError is DioException) {
                    appLog("🧯 Retry error message: ${retryError.message}");
                  }
                }
                // 🟢 Retry logic ends here
              } else if (e.type == DioExceptionType.cancel) {
                appLog("🚫 Request was cancelled by user or Dio.");
              }

              appLog("🧯 Message: ${e.message}");
              appLog("📦 Error Data: ${e.response?.data}");
              return handler.next(e);
            },
          ),
        );
}
