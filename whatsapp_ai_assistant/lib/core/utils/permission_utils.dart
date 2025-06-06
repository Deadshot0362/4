import 'package:app_settings/app_settings.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:logger/logger.dart'; // Import the logger package

final Logger _logger = Logger(); // Initialize the logger

class PermissionUtils {
  PermissionUtils._(); // Private constructor

  static Future<bool> checkAndRequestPermission(Permission permission) async {
    _logger.d('Checking permission: ${permission.toString()}');
    final status = await permission.status;

    if (status.isGranted) {
      _logger.i('${permission.toString()} permission already granted.');
      return true;
    } else if (status.isDenied) {
      _logger.w('${permission.toString()} permission denied. Requesting again.');
      final result = await permission.request();
      if (result.isGranted) {
        _logger.i('${permission.toString()} permission granted after request.');
        return true;
      } else if (result.isPermanentlyDenied) {
        _logger.e('${permission.toString()} permission permanently denied. Opening app settings.');
        await AppSettings.openAppSettings(type: AppSettingsType.permission); // Corrected usage
        return false;
      } else {
        _logger.e('${permission.toString()} permission denied by user.');
        return false;
      }
    } else if (status.isPermanentlyDenied) {
      _logger.e('${permission.toString()} permission permanently denied. Opening app settings.');
      await AppSettings.openAppSettings(type: AppSettingsType.permission); // Corrected usage
      return false;
    } else if (status.isRestricted) {
      _logger.e('${permission.toString()} permission restricted.');
      return false;
    }

    return false; // Fallback
  }

  // Example: Check and request notification listener permission (if applicable)
  // This is a custom permission and might require different handling
  static Future<bool> checkAndRequestNotificationListenerPermission() async {
    // This part is highly dependent on how your notification listener works.
    // Usually, this involves platform channels to check if the service is enabled.
    _logger.d('Checking notification listener permission.');
    // Placeholder: You'd call a method channel here
    // bool isEnabled = await PlatformChannels.checkNotificationListenerStatus();
    // if (!isEnabled) {
    //   await AppSettings.openNotificationSettings();
    // }
    // return isEnabled;
    return true; // Placeholder for now
  }
}