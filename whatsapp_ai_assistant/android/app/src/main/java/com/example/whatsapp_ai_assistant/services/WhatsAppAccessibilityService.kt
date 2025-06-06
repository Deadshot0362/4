// android/app/src/main/java/com/example/whatsapp_ai_assistant/services/WhatsAppAccessibilityService.kt
package com.example.whatsapp_ai_assistant.services

import android.accessibilityservice.AccessibilityService
import android.accessibilityservice.AccessibilityServiceInfo
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.view.accessibility.AccessibilityEvent
import android.view.accessibility.AccessibilityNodeInfo
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.plugin.common.MethodChannel
import io.flutter.view.FlutterCallbackInformation
import io.flutter.view.FlutterMain
import android.provider.Settings
import android.text.TextUtils
import android.view.accessibility.AccessibilityNodeInfo.AccessibilityAction

class WhatsAppAccessibilityService : AccessibilityService() {

    private val TAG = "WhatsAppAccessibility"
    private lateinit var methodChannel: MethodChannel

    companion object {
        private const val ACCESSIBILITY_CHANNEL = "com.example.whatsapp_ai_assistant/accessibility"
        private const val WHATSAPP_PACKAGE = "com.whatsapp"
        var backgroundFlutterEngine: FlutterEngine? = null
        var sIsRunning = false // To check if service is alive
    }

    override fun onCreate() {
        super.onCreate()
        Log.d(TAG, "WhatsAppAccessibilityService onCreate")
        sIsRunning = true

        // Initialize Flutter engine if not already initialized (similar to NotificationListener)
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
                    FlutterEngineCache.getInstance().put("accessibility_engine", backgroundFlutterEngine)
                    Log.d(TAG, "Background FlutterEngine initialized for accessibility.")
                } else {
                    Log.e(TAG, "Failed to lookup callback information for handle: $callbackHandle")
                }
            } else {
                Log.e(TAG, "Flutter callback handle not found. Background tasks won't run.")
            }
        }

        backgroundFlutterEngine?.let {
            methodChannel = MethodChannel(it.dartExecutor.binaryMessenger, ACCESSIBILITY_CHANNEL)
            methodChannel.setMethodCallHandler { call, result ->
                when (call.method) {
                    "sendMessage" -> {
                        val chatName = call.argument<String>("chatName")
                        val message = call.argument<String>("message")
                        if (chatName != null && message != null) {
                            val success = sendMessageInWhatsApp(chatName, message)
                            result.success(success)
                        } else {
                            result.error("INVALID_ARGUMENTS", "Missing chatName or message", null)
                        }
                    }
                    "openWhatsAppChat" -> {
                        val chatName = call.argument<String>("chatName")
                        if (chatName != null) {
                            val success = openWhatsAppChat(chatName)
                            result.success(success)
                        } else {
                            result.error("INVALID_ARGUMENTS", "Missing chatName", null)
                        }
                    }
                    "isAccessibilityServiceEnabled" -> {
                        result.success(isAccessibilityServiceEnabled(applicationContext, this@WhatsAppAccessibilityService::class.java))
                    }
                    "openWhatsApp" -> {
                        val success = openWhatsApp()
                        result.success(success)
                    }
                    else -> result.notImplemented()
                }
            }
        } ?: Log.e(TAG, "FlutterEngine is null. Cannot set up accessibility method channel.")
    }

    override fun onServiceConnected() {
        super.onServiceConnected()
        Log.d(TAG, "Accessibility Service Connected.")
        val info = serviceInfo
        info.packageNames = arrayOf(WHATSAPP_PACKAGE)
        info.eventTypes = AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED or
                AccessibilityEvent.TYPE_VIEW_CLICKED or
                AccessibilityEvent.TYPE_VIEW_FOCUSED or
                AccessibilityEvent.TYPE_VIEW_TEXT_CHANGED or
                AccessibilityEvent.TYPE_WINDOW_CONTENT_CHANGED
        info.feedbackType = AccessibilityServiceInfo.FEEDBACK_GENERIC
        info.flags = AccessibilityServiceInfo.FLAG_INCLUDE_NOT_IMPORTANT_VIEWS or
                AccessibilityServiceInfo.FLAG_RETRIEVE_INTERACTIVE_WINDOWS or
                AccessibilityServiceInfo.FLAG_REPORT_VIEW_IDS or
                AccessibilityServiceInfo.FLAG_REQUEST_ENHANCED_WEB_ACCESSIBILITY or
                AccessibilityServiceInfo.FLAG_REQUEST_ACCESSIBILITY_BUTTON
        info.notificationTimeout = 100
        this.serviceInfo = info
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event == null || event.packageName != WHATSAPP_PACKAGE) {
            return
        }
        Log.d(TAG, "Accessibility Event: Type=${AccessibilityEvent.eventTypeToString(event.eventType)}, Package=${event.packageName}, Class=${event.className}")

        // You can add more logic here to monitor UI changes or specific elements
        // For auto-reply, we primarily rely on Flutter to trigger actions after notification
        // rather than reacting directly to all UI events.
    }

    private fun openWhatsApp(): Boolean {
        Log.d(TAG, "Attempting to open WhatsApp...")
        val launchIntent = packageManager.getLaunchIntentForPackage(WHATSAPP_PACKAGE)
        return if (launchIntent != null) {
            launchIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            startActivity(launchIntent)
            true
        } else {
            Log.e(TAG, "WhatsApp not found or cannot be launched.")
            false
        }
    }

    private fun openWhatsAppChat(chatName: String): Boolean {
        Log.d(TAG, "Attempting to open WhatsApp chat: $chatName")
        if (!openWhatsApp()) {
            Log.e(TAG, "Failed to open WhatsApp itself.")
            return false
        }
        // Give WhatsApp some time to load
        Thread.sleep(2000)

        // Find the chat in the chat list
        val rootNode = rootInActiveWindow ?: return false
        val chatNode = findNodeByText(rootNode, chatName)

        if (chatNode != null) {
            Log.d(TAG, "Found chat node for: $chatName. Clicking it.")
            performClick(chatNode)
            return true
        }
        Log.e(TAG, "Could not find chat: $chatName in WhatsApp chat list.")
        return false
    }

    private fun sendMessageInWhatsApp(chatName: String, message: String): Boolean {
        Log.d(TAG, "Attempting to send message '$message' to '$chatName' in WhatsApp.")

        if (!openWhatsAppChat(chatName)) {
            Log.e(TAG, "Could not open chat $chatName for sending message.")
            return false
        }
        // Give chat time to load
        Thread.sleep(2000)

        val rootNode = rootInActiveWindow ?: return false
        Log.d(TAG, "Root node after opening chat: ${rootNode.packageName}")

        // This is highly fragile and depends on WhatsApp's internal UI structure.
        // It relies on resource IDs which can change.
        // Look for input field (typically with ID `com.whatsapp:id/entry`)
        // and send button (typically with ID `com.whatsapp:id/send`)

        // Attempt 1: Find by resource ID for text input
        val textInputNode = findNodeById(rootNode, "com.whatsapp:id/entry")
        if (textInputNode == null) {
            Log.e(TAG, "Could not find WhatsApp text input field by ID.")
            // Attempt 2: Find by class name and description
            val textInputNodes = rootNode.findAccessibilityNodeInfosByViewId("com.whatsapp:id/entry")
            if (textInputNodes.isNotEmpty()) {
                Log.d(TAG, "Found text input by ID: ${textInputNodes.firstOrNull()}")
                textInputNodes.firstOrNull()?.let {
                    Log.d(TAG, "Found text input field: $it")
                }
            } else {
                Log.e(TAG, "Could not find WhatsApp text input field by ID or description.")
                return false
            }
        }


        // Set text
        textInputNode?.apply {
            performAction(AccessibilityNodeInfo.ACTION_FOCUS)
            val arguments = Bundle().apply {
                putCharSequence(AccessibilityNodeInfo.ACTION_SET_TEXT_ARGUMENT, message)
            }
            performAction(AccessibilityNodeInfo.ACTION_SET_TEXT, arguments)
            Log.d(TAG, "Text input field populated.")
            Thread.sleep(500) // Give time for text to appear
        } ?: return false

        // Find and click send button
        val sendButtonNode = findNodeById(rootNode, "com.whatsapp:id/send") // Common ID for send button
        if (sendButtonNode != null) {
            Log.d(TAG, "Found WhatsApp send button. Clicking it.")
            performClick(sendButtonNode)
            Log.d(TAG, "Message sent successfully.")
            return true
        } else {
            Log.e(TAG, "Could not find WhatsApp send button by ID.")
            return false
        }
    }

    private fun findNodeByText(rootNode: AccessibilityNodeInfo, text: String): AccessibilityNodeInfo? {
        val nodes = rootNode.findAccessibilityNodeInfosByText(text)
        return nodes.firstOrNull()
    }

    private fun findNodeById(rootNode: AccessibilityNodeInfo, viewId: String): AccessibilityNodeInfo? {
        // AccessibilityNodeInfo.findAccessibilityNodeInfosByViewId requires API 18.
        // Our minSdk is 21, so this is fine.
        return rootNode.findAccessibilityNodeInfosByViewId(viewId).firstOrNull()
    }

    private fun performClick(node: AccessibilityNodeInfo): Boolean {
        if (node.isClickable) {
            node.performAction(AccessibilityNodeInfo.ACTION_CLICK)
            return true
        } else {
            // Traverse up the hierarchy to find a clickable parent
            var current: AccessibilityNodeInfo? = node
            while (current != null) {
                if (current.isClickable) {
                    current.performAction(AccessibilityNodeInfo.ACTION_CLICK)
                    Log.d(TAG, "Clicked clickable parent: ${current.className}")
                    return true
                }
                current = current.parent
            }
        }
        return false
    }

    override fun onInterrupt() {
        Log.w(TAG, "Accessibility Service interrupted.")
    }

    override fun onDestroy() {
        super.onDestroy()
        sIsRunning = false
        Log.d(TAG, "WhatsAppAccessibilityService onDestroy")
        // No need to shut down FlutterEngine here if it's shared across services
    }

    /**
     * Checks if the accessibility service is enabled for this application.
     */
    fun isAccessibilityServiceEnabled(context: Context, service: Class<out AccessibilityService>): Boolean {
        val cn = ComponentName(context, service)
        val flat = Settings.Secure.getString(context.contentResolver, Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES)
        return flat != null && flat.contains(cn.flattenToString())
    }
}