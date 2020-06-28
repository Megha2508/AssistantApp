package io.flutter.plugins;

import android.accessibilityservice.AccessibilityService;
import android.accessibilityservice.AccessibilityServiceInfo;
import android.annotation.TargetApi;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.provider.Settings;
import android.text.TextUtils;
import android.util.Log;
import android.view.accessibility.AccessibilityEvent;
import android.view.accessibility.AccessibilityNodeInfo;

import java.util.List;

@TargetApi(Build.VERSION_CODES.ECLAIR)
public class WhatsappAccessibilityService extends AccessibilityService {
    @TargetApi(Build.VERSION_CODES.JELLY_BEAN_MR2)
    @Override
    public void onAccessibilityEvent(AccessibilityEvent event) {
        Log.e("service", String.valueOf(event.getSource()));
        if (getRootInActiveWindow() == null) {
            return;
        }

        if (!isAccessibilityOn(getApplicationContext(), WhatsappAccessibilityService.class)) {
            Intent intent = new Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS);
            startActivity(intent);
        }

        AccessibilityNodeInfo rootInActiveWindow = getRootInActiveWindow();

        // Whatsapp Message EditText id
        List<AccessibilityNodeInfo> messageNodeList = rootInActiveWindow.findAccessibilityNodeInfosByViewId("com.whatsapp:id/entry");
        if (messageNodeList == null || messageNodeList.isEmpty()) {
            return;
        }
        Log.e("service", String.valueOf(messageNodeList));

        // check if the whatsapp message EditText field is filled with text and ending with your suffix (explanation above)
        AccessibilityNodeInfo messageField = messageNodeList.get(0);
        if (messageField.getText() == null || messageField.getText().length() == 0
                || !messageField.getText().toString().endsWith(getApplicationContext().getString(Integer.parseInt(" ")))) {
            return;
        }

        // Whatsapp send button id
        List<AccessibilityNodeInfo> sendMessageNodeInfoList = rootInActiveWindow.findAccessibilityNodeInfosByViewId("com.whatsapp:id/send");
        if (sendMessageNodeInfoList == null || sendMessageNodeInfoList.isEmpty()) {
            return;
        }

        AccessibilityNodeInfo sendMessageButton = sendMessageNodeInfoList.get(0);
        if (!sendMessageButton.isVisibleToUser()) {
            return;
        }

        // Now fire a click on the send button
        sendMessageButton.performAction(AccessibilityNodeInfo.ACTION_CLICK);

        // Now go back to your app by clicking on the Android back button twice:
        // First one to leave the conversation screen
        // Second one to leave whatsapp
        try {
            Thread.sleep(100); // hack for certain devices in which the immediate back click is too fast to handle
            performGlobalAction(GLOBAL_ACTION_BACK);
            Thread.sleep(100);  // same hack as above
        } catch (InterruptedException ignored) {}
        performGlobalAction(GLOBAL_ACTION_BACK);


    }

    @Override
    public void onInterrupt() {
        System.out.println("interrupt check");
    }

    @TargetApi(Build.VERSION_CODES.JELLY_BEAN)
    @Override
    public void onServiceConnected() {
        AccessibilityServiceInfo info = getServiceInfo();
        Log.e("service", String.valueOf(getServiceInfo()));
        info.eventTypes = AccessibilityEvent.TYPE_VIEW_CLICKED | AccessibilityEvent.TYPE_VIEW_FOCUSED;
        info.packageNames = new String[]{"com.whatsapp","com.whatsapp.w4b"};
        info.feedbackType = AccessibilityServiceInfo.FEEDBACK_SPOKEN;
        info.notificationTimeout = 100;
        this.setServiceInfo(info);
        System.out.println("service check");
    }

    public boolean isAccessibilityOn (Context context, Class<? extends AccessibilityService> clazz) {
        System.out.println("accessOn check");
        int accessibilityEnabled = 0;
        final String service = context.getPackageName() + "/" + clazz.getCanonicalName();
        try {
            accessibilityEnabled = Settings.Secure.getInt(context.getApplicationContext().getContentResolver(), Settings.Secure.ACCESSIBILITY_ENABLED);
        } catch (Settings.SettingNotFoundException ignored) {  }

        TextUtils.SimpleStringSplitter colonSplitter = new TextUtils.SimpleStringSplitter(':');

        if (accessibilityEnabled == 1) {
            String settingValue = Settings.Secure.getString(context.getApplicationContext().getContentResolver(), Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES);
            if (settingValue != null) {
                colonSplitter.setString(settingValue);
                while (colonSplitter.hasNext()) {
                    String accessibilityService = colonSplitter.next();

                    if (accessibilityService.equalsIgnoreCase(service)) {
                        return true;
                    }
                }
            }
        }
        return false;
    }
}
