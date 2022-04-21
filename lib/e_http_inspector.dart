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

library e_http_inspector;

import 'package:dio/dio.dart';
import 'package:e_http_inspector/src/vn/com/extremevn/common/hive_util.dart';
import 'package:e_http_inspector/src/vn/com/extremevn/common/notification_util.dart';
import 'package:e_http_inspector/src/vn/com/extremevn/http_interceptor.dart';
import 'package:e_http_inspector/src/vn/com/extremevn/ui/history/http_history_screen.dart';
import 'package:flutter/material.dart';

///  An Http Interceptor work with dio package which persists and displays Http activity
///  in your application for later inspection.
class EHttpInspector {
  static final EHttpInspector _instance = EHttpInspector();

  factory EHttpInspector() => _instance;

  static Dio? _dio;
  static HttpInterceptor? _interceptor;
  static late GlobalKey<NavigatorState> _navigatorKey;

  /// Initialize package:
  /// - with [dio]  instance for inspector
  /// - with notification config: [navigatorKey], [channelKey], [channelName], [channelDes], [channelGroupKey] params
  /// for showing notification purpose.
  /// [channelKey] notification channel key
  /// [channelName] notification channel name
  /// [channelDes] notification channel description
  /// [channelGroupKey] notification channel group key
  /// [navigatorKey] App global navigator key
  static init(
    Dio dio,
    GlobalKey<NavigatorState> navigatorKey,
    String channelKey,
    String channelName,
    String channelDes, {
    String? channelGroupKey,
  }) async {
    _dio = dio;
    _navigatorKey = navigatorKey;
    await initInterceptor(dio);
    await initNotification(navigatorKey, channelKey, channelName, channelDes,
        channelGroupKey: channelGroupKey);
  }

  /// Initialize package's inspector for [dio]
  static initInterceptor(Dio dio) async {
    _dio = dio;
    if (_interceptor == null) {
      _interceptor = HttpInterceptor();
      dio.interceptors.add(_interceptor!);
    }
    await HiveUtil.initHive();
  }

  /// Initialize package's notification config: [navigatorKey], [channelKey], [channelName], [channelDes], [channelGroupKey] params
  /// for showing notification purpose.
  /// - [channelKey] notification channel key
  /// - [channelName] notification channel name
  /// - [channelDes] notification channel description
  /// - [channelGroupKey] notification channel group key
  /// - [navigatorKey] App global navigator key
  static initNotification(
    GlobalKey<NavigatorState> navigatorKey,
    String channelKey,
    String channelName,
    String channelDes, {
    String? channelGroupKey,
  }) async {
    WidgetsFlutterBinding.ensureInitialized();
    _navigatorKey = navigatorKey;
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      await NotificationUtil.initAwesomeNotification(
          navigatorKey, channelKey, channelName, channelDes,
          channelGroupKey: channelGroupKey);
    });
  }

  /// Dispose inspect http call and close data stream
  static dispose() async {
    if (_interceptor == null) {
      _dio?.interceptors.remove(_interceptor);
      _interceptor = null;
    }
    _dio = null;
    HiveUtil.closeHive();
  }

  /// Open http history screen
  static openHttpHistoryScreen() {
    _navigatorKey.currentState
        ?.push(MaterialPageRoute(builder: (_) => HttpHistoryScreen()));
  }
}
