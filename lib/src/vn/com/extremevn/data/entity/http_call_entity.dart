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

import 'package:e_http_inspector/src/vn/com/extremevn/common/hive_util.dart';
import 'package:e_http_inspector/src/vn/com/extremevn/data/entity/map_entry_entity.dart';
import 'package:hive/hive.dart';

part 'http_call_entity.g.dart';

@HiveType(typeId: HiveUtil.httpCallEntityTypeId)
class HttpCallEntity extends HiveObject {
  /// Request url
  @HiveField(0)
  String? url;

  /// Request host
  @HiveField(1)
  String? host;

  /// Request schema
  @HiveField(2)
  String? schema;

  /// Request method, like: GET, POST...
  @HiveField(3)
  String? method;

  /// List of request header
  @HiveField(4)
  List<MapEntryEntity>? requestHeader;

  /// Request body
  @HiveField(5)
  String? requestBody;

  /// Request form-data
  @HiveField(6)
  List<MapEntryEntity>? requestFormData;

  /// Response code
  @HiveField(7)
  int? responseCode;

  /// Response body
  @HiveField(8)
  String? response;

  /// List of response headers
  @HiveField(9)
  List<MapEntryEntity>? responseHeader;

  /// Request time, format: hh:mm:ss a
  @HiveField(10)
  String? requestTime;

  /// Response time, format: hh:mm:ss a
  @HiveField(11)
  String? responseTime;

  /// Request time in milli second
  @HiveField(12)
  int requestTimeMillisecond = 0;

  /// Response time in milli second
  @HiveField(13)
  int responseTimeMillisecond = 0;

  HttpCallEntity();
}
