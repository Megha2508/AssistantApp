package com.example.yourassistant

import android.accessibilityservice.AccessibilityService
import android.accessibilityservice.AccessibilityServiceInfo
import android.annotation.TargetApi
import android.content.Context
import android.content.Intent
import android.os.Build
import android.provider.Settings
import android.provider.Settings.SettingNotFoundException
import android.text.TextUtils.SimpleStringSplitter
import android.util.Log
import android.view.accessibility.AccessibilityEvent
import android.view.accessibility.AccessibilityNodeInfo


@TargetApi(Build.VERSION_CODES.ECLAIR)
class WhatsappAccessibilityService : AccessibilityService() {
    @TargetApi(Build.VERSION_CODES.JELLY_BEAN_MR2)
    override fun onAccessibilityEvent(event: AccessibilityEvent) {
        Log.e("service", event.source.toString())
        if (rootInActiveWindow == null) {
            return
        }
        if (!isAccessibilityOn(applicationContext, WhatsappAccessibilityService::class.java)) {
            val intent = Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS)
            startActivity(intent)
        }
        val rootInActiveWindow = rootInActiveWindow

        // Whatsapp Message EditText id
        val messageNodeList = rootInActiveWindow.findAccessibilityNodeInfosByViewId("com.whatsapp:id/entry")
        if (messageNodeList == null || messageNodeList.isEmpty()) {
            return
        }
        Log.e("service", messageNodeList.toString())

        // check if the whatsapp message EditText field is filled with text and ending with your suffix (explanation above)
        val messageField = messageNodeList[0]
        if (messageField.text == null || messageField.text.isEmpty() || !messageField.text.toString().endsWith(applicationContext.getString(" ".toInt()))) {
            return
        }

        // Whatsapp send button id
        val sendMessageNodeInfoList = rootInActiveWindow.findAccessibilityNodeInfosByViewId("com.whatsapp:id/send")
        if (sendMessageNodeInfoList == null || sendMessageNodeInfoList.isEmpty()) {
            return
        }
        val sendMessageButton = sendMessageNodeInfoList[0]
        if (!sendMessageButton.isVisibleToUser) {
            return
        }

        // Now fire a click on the send button
        sendMessageButton.performAction(AccessibilityNodeInfo.ACTION_CLICK)

        // Now go back to your app by clicking on the Android back button twice:
        // First one to leave the conversation screen
        // Second one to leave whatsapp
        try {
            Thread.sleep(100) // hack for certain devices in which the immediate back click is too fast to handle
            performGlobalAction(GLOBAL_ACTION_BACK)
            Thread.sleep(100) // same hack as above
        } catch (ignored: InterruptedException) {
        }
        performGlobalAction(GLOBAL_ACTION_BACK)
    }

    override fun onInterrupt() {
        println("interrupt check")
    }

    @TargetApi(Build.VERSION_CODES.JELLY_BEAN)
    public override fun onServiceConnected() {
        val info = serviceInfo
        Log.e("service", serviceInfo.toString())
        info.eventTypes = AccessibilityEvent.TYPE_VIEW_CLICKED or AccessibilityEvent.TYPE_VIEW_FOCUSED
        info.packageNames = arrayOf("com.whatsapp", "com.whatsapp.w4b")
        info.feedbackType = AccessibilityServiceInfo.FEEDBACK_SPOKEN
        info.notificationTimeout = 100
        this.serviceInfo = info
        println("service check")
    }

    private fun isAccessibilityOn(context: Context, clazz: Class<out AccessibilityService?>): Boolean {
        println("accessOn check")
        var accessibilityEnabled = 0
        val service = context.packageName + "/" + clazz.canonicalName
        try {
            accessibilityEnabled = Settings.Secure.getInt(context.applicationContext.contentResolver, Settings.Secure.ACCESSIBILITY_ENABLED)
        } catch (ignored: SettingNotFoundException) {
        }
        val colonSplitter = SimpleStringSplitter(':')
        if (accessibilityEnabled == 1) {
            val settingValue = Settings.Secure.getString(context.applicationContext.contentResolver, Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES)
            if (settingValue != null) {
                colonSplitter.setString(settingValue)
                while (colonSplitter.hasNext()) {
                    val accessibilityService = colonSplitter.next()
                    if (accessibilityService.equals(service, ignoreCase = true)) {
                        return true
                    }
                }
            }
        }
        return false
    }
}