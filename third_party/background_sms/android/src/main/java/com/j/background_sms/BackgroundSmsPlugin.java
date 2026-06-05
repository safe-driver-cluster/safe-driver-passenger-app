package com.j.background_sms;

import android.app.Activity;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.telephony.SmsManager;
import android.telephony.SubscriptionManager;

import androidx.annotation.NonNull;

import java.util.ArrayList;
import java.util.UUID;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicInteger;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** BackgroundSmsPlugin */
public class BackgroundSmsPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native
  /// Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine
  /// and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private Context applicationContext;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    applicationContext = flutterPluginBinding.getApplicationContext();
    channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "background_sms");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("sendSms")) {
      String num = call.argument("phone");
      String msg = call.argument("msg");
      Integer simSlot = call.argument("simSlot");
      sendSMS(num, msg, simSlot, result);
    } else if (call.method.equals("isSupportMultiSim")) {
      isSupportCustomSim(result);
    } else {
      result.notImplemented();
    }
  }

  private void isSupportCustomSim(Result result) {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
      result.success(true);
    } else {
      result.success(false);
    }
  }

  private void sendSMS(String num, String msg, Integer simSlot, Result result) {
    try {
      SmsManager smsManager;
      if (simSlot == null) {
        smsManager = getDefaultSmsManager();
      } else {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
          smsManager = SmsManager.getSmsManagerForSubscriptionId(simSlot);
        } else {
          smsManager = SmsManager.getDefault();
        }
      }
      ArrayList<String> parts = smsManager.divideMessage(msg);
      if (parts == null || parts.isEmpty()) {
        result.error("Failed", "Sms message is empty", "");
        return;
      }

      String actionId = UUID.randomUUID().toString();
      String sentAction = "com.j.background_sms.SMS_SENT_" + actionId;
      String deliveredAction = "com.j.background_sms.SMS_DELIVERED_" + actionId;
      AtomicInteger pendingParts = new AtomicInteger(parts.size());
      AtomicInteger pendingDeliveries = new AtomicInteger(parts.size());
      AtomicBoolean hasFailure = new AtomicBoolean(false);
      AtomicBoolean hasDeliveryFailure = new AtomicBoolean(false);
      AtomicBoolean sentComplete = new AtomicBoolean(false);
      AtomicBoolean completed = new AtomicBoolean(false);
      Handler handler = new Handler(Looper.getMainLooper());

      BroadcastReceiver sentReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
          int code = getResultCode();
          if (code != Activity.RESULT_OK) {
            hasFailure.set(true);
          }

          if (pendingParts.decrementAndGet() == 0) {
            sentComplete.set(true);
            if (hasFailure.get() && completed.compareAndSet(false, true)) {
              unregisterReceiverSafe(this);
              result.success("Failed");
            }
          }
        }
      };

      BroadcastReceiver deliveredReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
          int code = getResultCode();
          if (code != Activity.RESULT_OK) {
            hasDeliveryFailure.set(true);
          }

          if (pendingDeliveries.decrementAndGet() == 0 && completed.compareAndSet(false, true)) {
            unregisterReceiverSafe(sentReceiver);
            unregisterReceiverSafe(this);
            result.success(hasDeliveryFailure.get() ? "Sent" : "Delivered");
          }
        }
      };

      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
        applicationContext.registerReceiver(sentReceiver, new IntentFilter(sentAction), Context.RECEIVER_NOT_EXPORTED);
        applicationContext.registerReceiver(deliveredReceiver, new IntentFilter(deliveredAction), Context.RECEIVER_NOT_EXPORTED);
      } else {
        applicationContext.registerReceiver(sentReceiver, new IntentFilter(sentAction));
        applicationContext.registerReceiver(deliveredReceiver, new IntentFilter(deliveredAction));
      }

      handler.postDelayed(() -> {
        if (completed.compareAndSet(false, true)) {
          unregisterReceiverSafe(sentReceiver);
          unregisterReceiverSafe(deliveredReceiver);
          result.success(sentComplete.get() && !hasFailure.get() ? "Sent" : "Failed");
        }
      }, 30000);

      ArrayList<PendingIntent> sentIntents = new ArrayList<>();
      ArrayList<PendingIntent> deliveredIntents = new ArrayList<>();
      int flags = PendingIntent.FLAG_UPDATE_CURRENT;
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
        flags |= PendingIntent.FLAG_IMMUTABLE;
      }
      for (int i = 0; i < parts.size(); i++) {
        Intent sentIntent = new Intent(sentAction);
        sentIntent.setPackage(applicationContext.getPackageName());
        sentIntents.add(PendingIntent.getBroadcast(applicationContext, i, sentIntent, flags));

        Intent deliveredIntent = new Intent(deliveredAction);
        deliveredIntent.setPackage(applicationContext.getPackageName());
        deliveredIntents.add(PendingIntent.getBroadcast(applicationContext, i, deliveredIntent, flags));
      }

      try {
        if (parts.size() == 1) {
          smsManager.sendTextMessage(num, null, parts.get(0), sentIntents.get(0), deliveredIntents.get(0));
        } else {
          smsManager.sendMultipartTextMessage(num, null, parts, sentIntents, deliveredIntents);
        }
      } catch (Exception sendException) {
        if (completed.compareAndSet(false, true)) {
          unregisterReceiverSafe(sentReceiver);
          unregisterReceiverSafe(deliveredReceiver);
          result.error("Failed", "Sms Not Sent", "");
        }
      }
    } catch (Exception ex) {
      ex.printStackTrace();
      result.error("Failed", "Sms Not Sent", "");
    }
  }

  private SmsManager getDefaultSmsManager() {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP_MR1) {
      int subscriptionId = SubscriptionManager.getDefaultSmsSubscriptionId();
      if (subscriptionId != SubscriptionManager.INVALID_SUBSCRIPTION_ID) {
        return SmsManager.getSmsManagerForSubscriptionId(subscriptionId);
      }
    }
    return SmsManager.getDefault();
  }

  private void unregisterReceiverSafe(BroadcastReceiver receiver) {
    try {
      applicationContext.unregisterReceiver(receiver);
    } catch (IllegalArgumentException ignored) {
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
    applicationContext = null;
  }
}
