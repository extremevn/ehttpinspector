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

import 'dart:async';
import 'dart:io';

import 'package:e_http_inspector/src/vn/com/extremevn/common/constant.dart';
import 'package:e_http_inspector/src/vn/com/extremevn/common/date_time_util.dart';
import 'package:e_http_inspector/src/vn/com/extremevn/common/hive_util.dart';
import 'package:e_http_inspector/src/vn/com/extremevn/data/entity/http_call_entity.dart';
import 'package:e_http_inspector/src/vn/com/extremevn/data/entity/map_entry_entity.dart';
import 'package:e_http_inspector/src/vn/com/extremevn/ui/detail/http_detail_event.dart';
import 'package:e_http_inspector/src/vn/com/extremevn/ui/detail/http_detail_state.dart';
import 'package:eventstateprocessor/eventstateprocessor.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class HttpDetailEventStateProcessor
    extends EventToStateProcessor<HttpDetailEvent, HttpDetailState> {
  HttpDetailEventStateProcessor()
      : super(HttpDetailState(
            isInit: true,
            isLoading: false,
            response: [],
            currentIndex: 0,
            request: [],
            overview: [],
            query: empty,
            isSearching: false)) {
    on<HttpDetailLoadEvent>(onHttpDetailLoadEvent);
    on<HttpDetailOnSearchQueryChangeEvent>(
        onHttpDetailOnSearchQueryChangeEvent);
    on<HttpDetailSearchEvent>(onHttpDetailSearchEvent);
    on<HttpDetailCopyClickedEvent>(onHttpDetailCopyClickedEvent);
    on<HttpDetailTabChangeEvent>(onHttpDetailTabChangeEvent);
  }

  FutureOr<void> onHttpDetailLoadEvent(
      HttpDetailLoadEvent event, Emitter<HttpDetailState> emitter) async {
    emitter.call(state.copy(isInit: false, isLoading: true));
    bool hasData = false;
    if (event.httpCallEntity == null && event.id == null) return;
    late HttpCallEntity httpCallEntity;
    if (event.httpCallEntity != null) {
      hasData = true;
      httpCallEntity = event.httpCallEntity!;
    } else {
      for (var element in HiveUtil.dataBox.values) {
        var httpCall = element as HttpCallEntity;
        if (httpCall.requestTimeMillisecond == event.id) {
          hasData = true;
          httpCallEntity = httpCall;
          break;
        }
      }
    }
    if (!hasData) return;
    List<MapEntryEntity> overview = [];
    bool isJsonBody = true;
    var totalHttpTime = httpCallEntity.responseTimeMillisecond -
        httpCallEntity.requestTimeMillisecond;
    overview.add(MapEntryEntity(
        entryKey: Keys.url, entryValue: httpCallEntity.host ?? empty));
    overview.add(MapEntryEntity(
        entryKey: Keys.method, entryValue: httpCallEntity.method ?? empty));
    overview.add(MapEntryEntity(
        entryKey: Keys.responseCode,
        entryValue: httpCallEntity.responseCode.toString()));
    overview.add(MapEntryEntity(
        entryKey: Keys.requestAt,
        entryValue: httpCallEntity.requestTime ?? empty));
    overview.add(MapEntryEntity(
        entryKey: Keys.responseAt,
        entryValue: httpCallEntity.responseTime ?? empty));
    overview.add(MapEntryEntity(
        entryKey: Keys.requestedTime,
        entryValue: "${totalHttpTime.toString()}ms"));

    List<MapEntryEntity> responseResultList = [];
    if (httpCallEntity.responseHeader != null) {
      responseResultList.addAll(httpCallEntity.responseHeader!);
      for (var element in httpCallEntity.responseHeader!) {
        if (element.entryKey == contentType &&
            !element.entryValue.contains(contentTypeJson)) {
          isJsonBody = false;
        }
      }
    }

    if (httpCallEntity.response != null) {
      responseResultList.add(MapEntryEntity(
          entryKey: bodyTitle,
          entryValue: isJsonBody ? httpCallEntity.response! : contentBinary));
    }

    List<MapEntryEntity> requestResultList = [];
    if (httpCallEntity.requestHeader != null &&
        httpCallEntity.requestHeader!.isNotEmpty) {
      requestResultList.addAll(httpCallEntity.requestHeader!);
    }
    if (httpCallEntity.requestFormData != null &&
        httpCallEntity.requestFormData!.isNotEmpty) {
      requestResultList.addAll(httpCallEntity.requestFormData!);
    }
    if (httpCallEntity.requestBody != null &&
        httpCallEntity.requestBody!.isNotEmpty) {
      requestResultList.add(MapEntryEntity(
          entryKey: bodyTitle, entryValue: httpCallEntity.requestBody!));
    }

    emitter.call(state.copy(
        isInit: false,
        overview: overview,
        response: responseResultList,
        request: requestResultList));
  }

  FutureOr<void> onHttpDetailOnSearchQueryChangeEvent(
      HttpDetailOnSearchQueryChangeEvent event,
      Emitter<HttpDetailState> emitter) async {
    emitter.call(state.copy(query: event.value));
  }

  FutureOr<void> onHttpDetailSearchEvent(
      HttpDetailSearchEvent event, Emitter<HttpDetailState> emitter) async {
    emitter.call(state.copy(isSearching: !state.isSearching, query: empty));
  }

  FutureOr<void> onHttpDetailTabChangeEvent(
      HttpDetailTabChangeEvent event, Emitter<HttpDetailState> emitter) async {
    emitter
        .call(state.copy(isInit: false, currentIndex: event.currentTabIndex));
  }

  FutureOr<void> onHttpDetailCopyClickedEvent(HttpDetailCopyClickedEvent event,
      Emitter<HttpDetailState> emitter) async {
    List<String> clipBoardData = [];
    if (state.currentIndex == 0) {
      for (var element in state.overview) {
        clipBoardData.add('${element.entryKey}: ${element.entryValue}');
      }
    } else if (state.currentIndex == 1) {
      for (var element in state.request) {
        clipBoardData.add('${element.entryKey}: ${element.entryValue}');
      }
    } else {
      for (var element in state.response) {
        clipBoardData.add('${element.entryKey}: ${element.entryValue}');
      }
    }
    var clipBoard = clipBoardData.join("\n");
    Clipboard.setData(ClipboardData(text: clipBoard));
    _write(clipBoard);
  }

  _write(String text) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File(
        '${directory.path}/${DateTimeUtil.getCurrentTime(format: DateTimeUtil.dateTimeFormatHhMmSs)}.txt');
    await file.writeAsString(text);
  }
}
