// android/app/src/main/java/com/example/whatsapp_ai_assistant/services/WhatsAppNotificationListenerService.kt
package com.example.whatsapp_ai_assistant.services

import android.app.Notification
import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.view.FlutterCallbackInformation
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.view.FlutterMain
import android.content.Context
import android.content.pm.PackageManager
import android.provider.Settings
import android.text.TextUtils
import android.content.ComponentName

class WhatsAppNotificationListenerService : NotificationListenerService() {

    private val TAG = "WhatsAppNtfListener"
    private var eventChannel: EventChannel? = null
    private var methodChannel: MethodChannel? = null
    private var flutterEngine: FlutterEngine? = null

    // This callback handle needs to match the one sent from Dart
    // For simplicity in this example, we assume it's set up in MainApplication.kt
    // In a real app, you might want to retrieve this from shared preferences
    // if the Dart side saves it there.
    companion object {
        private const val NOTIFICATION_CHANNEL = "com.example.whatsapp_ai_assistant/notifications"
        private const val WHATSAPP_PACKAGE = "com.whatsapp"
        var backgroundFlutterEngine: FlutterEngine? = null
        var sIsRunning = false // To check if service is alive
    }

    override fun onCreate() {
        super.onCreate()
        Log.d(TAG, "WhatsAppNotificationListenerService onCreate")
        sIsRunning = true

        // Initialize Flutter engine if not already initialized
        if (backgroundFlutterEngine == null) {
            val flutterLoader = FlutterMain()
            flutterLoader.startInitialization(applicationContext)
            flutterLoader.ensureInitializationComplete(applicationContext, null)

            val callbackHandle = applicationContext.getSharedPreferences("FlutterApp", Context.MODE_PRIVATE)
                .getLong("flutter_callback_handle", -1)

            if (callbackHandle != -1L) {
                val callbackInfo = FlutterCallbackInformation.lookupCallbackInformation(callbackHandle)
                if (callbackInfo != null) {
                    backgroundFlutterEngine = FlutterEngine(applicationContext)
                    backgroundFlutterEngine?.dartExecutor?.executeDartCallback(
                        DartExecutor.DartCallback(
                            applicationContext.assets,
                            flutterLoader.findAppBundlePath(),
                            callbackInfo
                        )
                    )
                    FlutterEngineCache.getInstance().put("notification_engine", backgroundFlutterEngine)
                    Log.d(TAG, "Background FlutterEngine initialized for notifications.")
                } else {
                    Log.e(TAG, "Failed to lookup callback information for handle: $callbackHandle")
                }
            } else {
                Log.e(TAG, "Flutter callback handle not found. Background tasks won't run.")
            }
        }

        flutterEngine = backgroundFlutterEngine
        if (flutterEngine != null) {
            methodChannel = MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, NOTIFICATION_CHANNEL)
            eventChannel = EventChannel(flutterEngine!!.dartExecutor.binaryMessenger, NOTIFICATION_CHANNEL)

            eventChannel?.setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    Log.d(TAG, "EventChannel onListen for notifications.")
                    // This service pushes events, so we just need the sink.
                }

                override fun onCancel(arguments: Any?) {
                    Log.d(TAG, "EventChannel onCancel for notifications.")
                }
            })

            methodChannel?.setMethodCallHandler { call, result ->
                when (call.method) {
                    "startNotificationListener" -> {
                        Log.d(TAG, "MethodChannel: startNotificationListener called (no-op here, service is always listening if enabled)")
                        result.success(true)
                    }
                    "stopNotificationListener" -> {
                        Log.d(TAG, "MethodChannel: stopNotificationListener called (no-op here, service is always listening if enabled)")
                        result.success(true)
                    }
                    // Additional methods if needed for Flutter to query service state
                    else -> result.notImplemented()
                }
            }
        } else {
            Log.e(TAG, "FlutterEngine is null. Cannot set up channels.")
        }
    }

    override fun onNotificationPosted(sbn: StatusBarNotification?) {
        super.onNotificationPosted(sbn)
        if (sbn == null || sbn.packageName != WHATSAPP_PACKAGE) {
            return
        }

        val notification = sbn.notification
        val extras = notification.extras

        val title = extras.getString(Notification.EXTRA_TITLE)
        val text = extras.getCharSequence(Notification.EXTRA_TEXT)?.toString()
        val bigText = extras.getCharSequence(Notification.EXTRA_BIG_TEXT)?.toString()
        val conversationTitle = extras.getString("android.conversationTitle") // For groups

        // Extract chatIdentifier and chatName
        // This is heuristic and might need adjustments based on WhatsApp versions
        val chatName = conversationTitle ?: title
        val chatIdentifier = sbn.packageName + "_" + (chatName ?: "unknown") // Simple identifier

        Log.d(TAG, "WhatsApp Notification: Title: $title, Text: $text, BigText: $bigText, ConversationTitle: $conversationTitle")

        if (text != null && text.isNotBlank() && chatName != null && chatIdentifier != null) {
            val messageMap = mapOf(
                "chatIdentifier" to chatIdentifier,
                "chatName" to chatName,
                "sender" to title, // Title usually contains sender name
                "content" to text,
                "timestamp" to sbn.postTime
            )
            flutterEngine?.dartExecutor?.binaryMessenger?.let {
                // Ensure the binary messenger is available and active
                val eventSink = object : EventChannel.EventSink {
                    override fun success(event: Any?) {
                        Log.d(TAG, "Event sent successfully: $event")
                    }

                    override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                        Log.e(TAG, "Error sending event: $errorCode, $errorMessage")
                    }

                    override fun endOfStream() {
                        Log.d(TAG, "End of stream requested.")
                    }
                }
                eventChannel?.setStreamHandler(object : EventChannel.StreamHandler {
                    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                        // This onListen will be called when Flutter sets up the stream
                        // but for background isolate, we need to push directly.
                        // The primary way to push is via a direct EventSink if the Flutter side is listening.
                        // For persistent background, direct binary messenger method is better.
                    }
                    override fun onCancel(arguments: Any?) {}
                })
                // Direct send through MethodChannel as a workaround or set up a dedicated background EventChannel
                // For a true background isolate, Flutter's Workmanager or similar approach is more robust
                // For simplicity, we directly send via method channel as a 'one-off' message.
                // A better approach would be to ensure the EventChannel is truly alive for background isolates.
                methodChannel?.invokeMethod("onIncomingWhatsAppMessage", messageMap)
                Log.d(TAG, "Sent message data to Flutter via MethodChannel: $messageMap")
            } ?: Log.e(TAG, "FlutterEngine binary messenger is null. Cannot send message.")
        }
    }

    override fun onNotificationRemoved(sbn: StatusBarNotification?) {
        super.onNotificationRemoved(sbn)
        Log.d(TAG, "Notification removed: ${sbn?.packageName}")
    }

    override fun onListenerConnected() {
        super.onListenerConnected()
        Log.d(TAG, "Notification Listener connected.")
    }

    override fun onListenerDisconnected() {
        super.onListenerDisconnected()
        Log.w(TAG, "Notification Listener disconnected. Attempting to re-bind...")
        // Attempt to re-bind:
        try {
            // This is a common trick, but might not work reliably depending on Android version
            // For a robust solution, you might need to launch a foreground service to keep it alive
            requestRebind(ComponentName(this, WhatsAppNotificationListenerService::class.java))
        } catch (e: Exception) {
            Log.e(TAG, "Failed to request rebind for Notification Listener: ${e.message}")
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        sIsRunning = false
        Log.d(TAG, "WhatsAppNotificationListenerService onDestroy")
        // No need to shut down FlutterEngine here if it's shared across services
        // If this is the only service using it, then do:
        // flutterEngine?.destroy()
        // FlutterEngineCache.getInstance().remove("notification_engine")
    }

    /**
     * Checks if the notification listener service is enabled for this application.
     */
    fun isNotificationServiceEnabled(context: Context): Boolean {
        val packageName = context.packageName
        val flat = Settings.Secure.getString(context.contentResolver,
            "enabled_notification_listeners")
        return !TextUtils.isEmpty(flat) && flat.contains(packageName)
    }
}