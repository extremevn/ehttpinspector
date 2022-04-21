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

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:e_http_inspector/src/vn/com/extremevn/ui/history/http_history_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NotificationUtil {
  static late String _channelKey;
  static int _notificationId = 0;

  /// Show awesome notification.
  /// [title] Title of notification
  /// [body] Body of notification
  static showNotification({String? title, String? body}) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: _notificationId++,
        channelKey: _channelKey,
        title: title,
        body: body,
        category: NotificationCategory.Event,
      ),
    );
  }

  /// Initialize awesome notification package
  /// [navigatorKey] Key to show notification.
  /// [channelKey] notification channel key
  /// [channelName] notification channel name
  /// [channelDes] notification channel description
  /// [channelGroupKey] notification channel group key
  /// [context] App context
  static initAwesomeNotification(
    GlobalKey<NavigatorState> navigatorKey,
    String channelKey,
    String channelName,
    String channelDes, {
    String? channelGroupKey,
  }) async {
    _channelKey = channelKey;
    AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
            channelGroupKey: channelGroupKey,
            channelKey: channelKey,
            channelName: channelName,
            channelDescription: channelDes,
            importance: NotificationImportance.Low,
          ),
        ],
        debug: kDebugMode);

    await requestBasicPermissionToSendNotifications();

    AwesomeNotifications().actionStream.listen((action) {
      if (action.channelKey == channelKey) {
        navigatorKey.currentState!
            .push(MaterialPageRoute(builder: (_) => HttpHistoryScreen()));
      }
    });
  }

  /// Request basic permission if need, include following permissions.
  /// [NotificationPermission.Alert],
  /// [NotificationPermission.Sound],
  /// [NotificationPermission.Badge],
  /// [NotificationPermission.Vibration],
  /// [NotificationPermission.Light],
  static Future<void> requestBasicPermissionToSendNotifications() async {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) async {
      if (!isAllowed) {
        await AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }
}
