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

import 'dart:collection';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:e_http_inspector/src/vn/com/extremevn/common/constant.dart';
import 'package:e_http_inspector/src/vn/com/extremevn/common/date_time_util.dart';
import 'package:e_http_inspector/src/vn/com/extremevn/common/hive_util.dart';
import 'package:e_http_inspector/src/vn/com/extremevn/common/notification_util.dart';
import 'package:e_http_inspector/src/vn/com/extremevn/data/entity/http_call_entity.dart';
import 'package:e_http_inspector/src/vn/com/extremevn/data/entity/map_entry_entity.dart';

///  A Custom Http InterceptorsWrapper to inspect requests, responses
///  and save it to app local storage.
class HttpInterceptor extends InterceptorsWrapper {
  Queue<HttpCallEntity> httpCallQueue = Queue<HttpCallEntity>();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    var httpCall = HttpCallEntity();

    List<MapEntryEntity> requestFormData = [];
    String requestBody = empty;

    // Get request body raw data or form-data.
    if (options.method != 'GET') {
      final dynamic data = options.data;
      if (data != null) {
        if (data is Map) {
          data.forEach((key, value) {
            requestFormData
                .add(MapEntryEntity(entryKey: key, entryValue: value));
          });
        } else if (data is FormData) {
          final formDataMap = <String, dynamic>{}
            ..addEntries(data.fields)
            ..addEntries(data.files);
          formDataMap.forEach((key, value) {
            requestFormData
                .add(MapEntryEntity(entryKey: key, entryValue: value));
          });
        } else {
          try {
            requestBody =
                const JsonEncoder.withIndent('  ').convert(jsonDecode(data));
          } catch (e) {
            requestBody = data;
          }
        }
      }
    }

    // Save request data like: schema, url, time... to HttpCallEntity object
    httpCall.url = options.uri.path;
    httpCall.method = options.method;
    httpCall.host = options.uri.host;
    httpCall.schema = options.uri.scheme;
    httpCall.requestHeader = _getRequestHeaders(options);
    httpCall.requestBody = requestBody;
    httpCall.requestFormData = requestFormData;
    httpCall.requestTimeMillisecond = DateTimeUtil.getCurrentMillisecondTime();
    httpCall.requestTime = DateTimeUtil.getCurrentTime();

    // Add HttpCallEntity object to queue to retrieve from onResponse or onError.
    httpCallQueue.add(httpCall);
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    super.onResponse(response, handler);
    List<MapEntryEntity> responseHeader = [];
    String responseJsonFormatted = empty;

    // Get response headers
    response.headers.forEach((name, values) {
      responseHeader
          .add(MapEntryEntity(entryKey: name, entryValue: values.toString()));
    });

    // Format response json data to show on screen
    try {
      final object = jsonDecode(jsonEncode(response.data));
      responseJsonFormatted =
          const JsonEncoder.withIndent('  ').convert(object);
    } catch (e) {
      responseJsonFormatted = response.data.toString();
    }

    // Get and remove HttpCallEntity object from queue which is saved on onRequest
    var httpCall = httpCallQueue.firstWhere(
        (element) => element.url == response.requestOptions.uri.path);
    httpCallQueue.remove(httpCall);

    // Save response data like: code, header, time... to HttpCallEntity object
    httpCall.response = responseJsonFormatted;
    httpCall.responseCode = response.statusCode;
    httpCall.responseHeader = responseHeader;
    httpCall.responseTimeMillisecond = DateTimeUtil.getCurrentMillisecondTime();
    httpCall.responseTime = DateTimeUtil.getCurrentTime();

    // Save HttpCallEntity success object to local
    HiveUtil.dataBox.add(httpCall);

    // Show notification to app
    NotificationUtil.showNotification(
        title: httpCall.url, body: httpCall.method ?? empty);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    super.onError(err, handler);
    List<MapEntryEntity> responseHeader = [];

    // Get response headers
    err.requestOptions.headers.forEach((name, values) {
      responseHeader
          .add(MapEntryEntity(entryKey: name, entryValue: values.toString()));
    });

    // Open hive box to save httpCallEntity to local

    // Get and remove HttpCallEntity object from queue which is saved on onRequest
    var httpCall = httpCallQueue
        .firstWhere((element) => element.url == err.requestOptions.uri.path);
    httpCallQueue.remove(httpCall);

    // Get response code, response error message or body depend on DioErrorType
    httpCall.responseCode = err.response?.statusCode ?? 0;
    if (err.type == DioErrorType.response && httpCall.responseCode != 404) {
      var data = err.response?.data;
      if (data == null) {
        httpCall.response = err.message.toString();
      } else {
        httpCall.response = data.toString();
      }
    } else {
      httpCall.response = err.message.toString();
    }
    httpCall.responseHeader = responseHeader;
    httpCall.responseTime = DateTimeUtil.getCurrentTime();
    httpCall.responseTimeMillisecond = DateTimeUtil.getCurrentMillisecondTime();

    // Save HttpCallEntity error object to local
    await HiveUtil.dataBox.add(httpCall);

    // Show notification to app
    NotificationUtil.showNotification(
        title: httpCall.url, body: httpCall.method ?? empty);
  }

  /// Get request headers from RequestOptions
  /// return list of [MapEntryEntity]
  List<MapEntryEntity> _getRequestHeaders(RequestOptions options) {
    List<MapEntryEntity> requestHeaders = [];
    options.headers.forEach((name, values) {
      requestHeaders
          .add(MapEntryEntity(entryKey: name, entryValue: values.toString()));
    });
    requestHeaders.add(MapEntryEntity(
        entryKey: 'responseType', entryValue: options.responseType.name));
    requestHeaders.add(MapEntryEntity(
        entryKey: 'followRedirects',
        entryValue: options.followRedirects.toString()));
    requestHeaders.add(MapEntryEntity(
        entryKey: 'connectTimeout',
        entryValue: options.connectTimeout.toString()));
    requestHeaders.add(MapEntryEntity(
        entryKey: 'receiveTimeout',
        entryValue: options.receiveTimeout.toString()));
    return requestHeaders;
  }
}
