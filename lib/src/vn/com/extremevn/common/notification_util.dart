/// MIT License
/// Copyright (c) [2022] Extreme Viet Nam
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in all
/// copies or substantial portions of the Software.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.
import 'dart:convert';

import 'package:e_http_inspector/e_http_inspector.dart';
import 'package:e_http_inspector/src/vn/com/extremevn/ui/detail/http_detail_screen.dart';
import 'package:e_http_inspector/src/vn/com/extremevn/ui/history/http_history_screen.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationUtil {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static AndroidNotificationChannel? channel;

  static bool _isHandledNotificationAppLaunch = false;
  static String _channelId = "http_intercept_channel";
  static String _channelName = "HttpInterceptChannel";
  static String _channelDescription = "Http Intercept Channel";
  static String _channelGroupId = "HttpInterceptGroupId";
  static String _channelGroupName = "HttpInterceptChannelGroup";
  static String _channelGroupDescription = "HttpInterceptChannelGroup";

  /// Factory for create an instance of [NotificationUtil].
  factory NotificationUtil() => _instance;

  NotificationUtil._();

  static final NotificationUtil _instance = NotificationUtil._();

  static Future<bool> init(
      String channelId, String channelName, String channelDes,
      {String? channelGroupKey,
      String? channelGroupName,
      String? channelGroupDescription,
      bool autoRequestPermission = false}) async {
    _channelId = channelId;
    _channelName = channelName;
    _channelDescription = channelDes;
    _channelGroupId = channelGroupKey ?? _channelGroupId;
    _channelGroupName = channelGroupName ?? _channelGroupName;
    _channelGroupDescription =
        channelGroupDescription ?? _channelGroupDescription;
    autoRequestPermission = autoRequestPermission;
    final bool hasPermission;
    if (autoRequestPermission) {
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        hasPermission = await requestIosNotificationPermission() ?? false;
      } else {
        hasPermission = await requestAndroidNotificationPermission() ?? false;
      }
    } else {
      hasPermission = false;
    }
    await initNotificationPlugin();
    processNotificationAppLaunch();
    return hasPermission;
  }

  showNotification({required int id, String? title, String? body}) {
    final notificationId = UniqueKey().hashCode;
    String encodePayload = json.encode({"id": id});
    flutterLocalNotificationsPlugin.show(
        notificationId,
        title,
        body,
        NotificationDetails(
            android: AndroidNotificationDetails(
          channel!.id,
          channel!.name,
          channelDescription: channel!.description,
        )),
        payload: encodePayload);
  }

  static Future<bool?>? requestAndroidNotificationPermission() {
    return flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
  }

  static Future<bool?>? requestIosNotificationPermission() {
    return flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  static Future<void> initNotificationPlugin() async {
    AndroidNotificationChannelGroup androidNotificationChannelGroup =
        AndroidNotificationChannelGroup(_channelGroupId, _channelGroupName,
            description: _channelGroupDescription);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannelGroup(androidNotificationChannelGroup);
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
            requestSoundPermission: true,
            requestBadgePermission: true,
            requestAlertPermission: true);
    const initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onSelectNotification,
        onDidReceiveBackgroundNotificationResponse: onSelectNotification);
    channel ??= AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      groupId: _channelGroupId,
      importance: Importance.high,
    );
    if (channel != null) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel!);
    }
  }

  static void processNotificationAppLaunch() {
    if (_isHandledNotificationAppLaunch) return;
    _isHandledNotificationAppLaunch = true;
    flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails()
        .then((value) {
      if (value != null &&
          value.notificationResponse != null &&
          value.didNotificationLaunchApp == true) {
        onSelectNotification(value.notificationResponse!);
      }
    });
  }
}

onSelectNotification(NotificationResponse? notificationResponse) {
  if (notificationResponse == null || notificationResponse.payload == null) {
    return;
  }
  final payloadMap = json.decode(notificationResponse.payload!);
  EHttpInspector.navigatorKey.currentState
      ?.push(MaterialPageRoute(builder: (_) => HttpHistoryScreen()));
  if (payloadMap != null && payloadMap["id"] != null) {
    EHttpInspector.navigatorKey.currentState?.push(MaterialPageRoute(
      builder: (_) => HttpDetailScreen(id: payloadMap["id"]!),
    ));
  }
}
