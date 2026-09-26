import '../constants/app_routes.dart';
import '../router/app_router.dart';
import '../services/storage_service.dart';
import '../utils/logger.dart';

class SessionManager {
  static bool _isLoggingOut = false;

  static Future<void> forceLogout() async {
    if (_isLoggingOut) return;

    _isLoggingOut = true;

    appLog("🚪 Force logout triggered");

    try {
      final prefs = await SharedPreferencesService.getInstance();
      await prefs.clear();
    } catch (e) {
      appLog("Error clearing prefs on force logout: $e");
    } finally {
      _isLoggingOut = false;
    }

    AppRouter.router.go(AppRoutes.login);
  }
}
