// android/app/src/main/java/com/example/whatsapp_ai_assistant/MainActivity.kt
package com.example.whatsapp_ai_assistant

import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.util.FlutterPluginBinding
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import io.flutter.view.FlutterCallbackInformation
import io.flutter.view.FlutterMain
import com.example.whatsapp_ai_assistant.services.WhatsAppAccessibilityService
import com.example.whatsapp_ai_assistant.services.WhatsAppNotificationListenerService
import io.flutter.embedding.engine.FlutterEngineCache

class MainActivity: FlutterActivity() {

    private val TAG = "MainActivity"
    private val ACCESSIBILITY_CHANNEL = "com.example.whatsapp_ai_assistant/accessibility"
    private val NOTIFICATION_CHANNEL = "com.example.whatsapp_ai_assistant/notifications"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Store the callback handle for background services
        val callbackHandle = FlutterMain.findAppBundlePath(applicationContext)?.let { appBundlePath ->
            FlutterCallbackInformation.lookupCallbackInformation(
                applicationContext.packageManager.getPackageInfo(applicationContext.packageName, 0).packageName,
                appBundlePath
            )?.callbackHandle
        }
        if (callbackHandle != null) {
            applicationContext.getSharedPreferences("FlutterApp", Context.MODE_PRIVATE)
                .edit()
                .putLong("flutter_callback_handle", callbackHandle)
                .apply()
            Log.d(TAG, "Flutter callback handle stored: $callbackHandle")
        } else {
            Log.e(TAG, "Could not find Flutter callback information.")
        }

        // MethodChannel for Accessibility Service checks
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, ACCESSIBILITY_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "isAccessibilityServiceEnabled" -> {
                    result.success(isAccessibilityServiceEnabled(applicationContext, WhatsAppAccessibilityService::class.java))
                }
                "openAccessibilitySettings" -> {
                    try {
                        startActivity(Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS))
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("ERROR", "Could not open Accessibility Settings", e.message)
                    }
                }
                "isNotificationServiceEnabled" -> {
                    result.success(isNotificationServiceEnabled(applicationContext))
                }
                "openNotificationSettings" -> {
                    try {
                        // This intent takes user to Notification Access settings
                        val intent = Intent("android.settings.ACTION_NOTIFICATION_LISTENER_SETTINGS")
                        startActivity(intent)
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("ERROR", "Could not open Notification Listener Settings", e.message)
                    }
                }
                // Add any other methods for UI-related interactions with native services
                else -> result.notImplemented()
            }
        }

        // The background services themselves will set up their own MethodChannels and EventChannels
        // with the background FlutterEngine instance (WhatsAppNotificationListenerService, WhatsAppAccessibilityService).
        // The main Activity's FlutterEngine is separate.
    }

    /**
     * Checks if the accessibility service is enabled for this application.
     */
    private fun isAccessibilityServiceEnabled(context: Context, service: Class<out AccessibilityService>): Boolean {
        val cn = ComponentName(context, service)
        val flat = Settings.Secure.getString(context.contentResolver, Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES)
        return flat != null && flat.contains(cn.flattenToString())
    }

    /**
     * Checks if the notification listener service is enabled for this application.
     */
    private fun isNotificationServiceEnabled(context: Context): Boolean {
        val packageName = context.packageName
        val flat = Settings.Secure.getString(context.contentResolver,
            "enabled_notification_listeners")
        return !TextUtils.isEmpty(flat) && flat.contains(packageName)
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        super.cleanUpFlutterEngine(flutterEngine)
        // Optionally destroy the background engines if they are not needed when main UI is closed
        // FlutterEngineCache.getInstance().remove("notification_engine")
        // FlutterEngineCache.getInstance().remove("accessibility_engine")
    }
}