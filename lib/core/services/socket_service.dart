// import 'dart:async';
// import 'dart:convert';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import '../constants/api_constants.dart';
// import '../constants/app_keys.dart';
// import '../services/storage_service.dart';
// import '../utils/logger.dart';

// class SocketService {
//   static final SocketService _instance = SocketService._internal();
//   factory SocketService() => _instance;
//   SocketService._internal();

//   IO.Socket? _socket;
//   bool _isConnected = false;

//   final _partnerAssignedController = StreamController<Map<String, dynamic>>.broadcast();
//   final _newChatNotificationController = StreamController<Map<String, dynamic>>.broadcast();
//   final _partnerLocationController = StreamController<Map<String, dynamic>>.broadcast();

//   Stream<Map<String, dynamic>> get partnerAssignedStream => _partnerAssignedController.stream;
//   Stream<Map<String, dynamic>> get newChatNotificationStream => _newChatNotificationController.stream;
//   Stream<Map<String, dynamic>> get partnerLocationStream => _partnerLocationController.stream;

//   IO.Socket? get socket => _socket;
//   bool get isConnected => _isConnected;

//   Future<void> connect() async {
//     if (_socket != null && _socket!.connected) return;

//     String socketUrl = ApiConstants.serverUrl;

//     try {
//       final prefs = await SharedPreferencesService.getInstance();
//       final token = prefs.getString(AppKeys.accessToken);

//       appLog("🔌 Initializing socket connection to: $socketUrl");

//       final optionBuilder = IO.OptionBuilder()
//         .setTransports(['websocket', 'polling'])        //.setTransports(['websocket', 'polling'])
//         .enableAutoConnect()
//         .enableReconnection()
//         .setReconnectionAttempts(10)
//         .setReconnectionDelay(1000);

//       if (token != null && token.isNotEmpty) {
//         optionBuilder.setExtraHeaders({'Authorization': 'Bearer $token'});
//         optionBuilder.setQuery({'token': token});
//       }

//       _socket = IO.io(socketUrl, optionBuilder.build());

//       _socket!.onConnect((_) async {
//         _isConnected = true;
//         appLog("⚡ Socket Connected: ${_socket!.id}");
//         _registerGlobalListeners();

//         // Automatically emit join_user if user data is stored
//         try {
//           final prefs = await SharedPreferencesService.getInstance();
//           final userStr = prefs.getString(AppKeys.user);
//           if (userStr != null && userStr.isNotEmpty) {
//             final userData = jsonDecode(userStr);
//             final userId = userData['_id'] ?? userData['id'];
//             if (userId != null && userId.toString().isNotEmpty) {
//               joinUser(userId.toString());
//             }
//           }
//         } catch (e) {
//           appLog("Error auto-joining user room: $e");
//         }
//       });

//       _socket!.onDisconnect((_) {
//         _isConnected = false;
//         appLog("🔌 Socket Disconnected");
//       });

//       _socket!.onConnectError((err) {
//         appLog("❌ Socket Connection Error: $err");
//       });

//     } catch (e) {
//       appLog("❌ Socket Initialization Error: $e");
//     }
//   }

//   void joinUser(String userId) {
//     if (_socket != null && _isConnected) {
//       appLog("🟢 Emitting join_user: $userId");
//       _socket!.emit('join_user', {'userId': userId});
//     }
//   }

//   void _registerGlobalListeners() {
//     _socket!.off('partner_assigned');
//     _socket!.on('partner_assigned', (data) {
//       appLog("📢 Socket partner_assigned event received: $data");
//       if (data is Map) {
//         _partnerAssignedController.add(Map<String, dynamic>.from(data));
//       }
//     });

//     _socket!.off('new_chat_notification');
//     _socket!.on('new_chat_notification', (data) {
//       appLog("📢 Socket new_chat_notification event received: $data");
//       if (data is Map) {
//         _newChatNotificationController.add(Map<String, dynamic>.from(data));
//       }
//     });

//     _socket!.off('partner_location_update');
//     _socket!.on('partner_location_update', (data) {
//       appLog("📢 Socket partner_location_update received: $data");
//       if (data is Map) {
//         _partnerLocationController.add(Map<String, dynamic>.from(data));
//       }
//     });

//     _socket!.off('location_update');
//     _socket!.on('location_update', (data) {
//       appLog("📢 Socket location_update received: $data");
//       if (data is Map) {
//         _partnerLocationController.add(Map<String, dynamic>.from(data));
//       }
//     });
//   }

//   void disconnect() {
//     if (_socket != null) {
//       _socket!.disconnect();
//       _socket = null;
//       _isConnected = false;
//       appLog("🔌 Socket explicitly disconnected");
//     }
//   }

//   void dispose() {
//     disconnect();
//     _partnerAssignedController.close();
//     _newChatNotificationController.close();
//   }
// }
