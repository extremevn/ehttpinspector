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

import 'dart:io';

import 'package:e_http_inspector/src/vn/com/extremevn/common/constant.dart';
import 'package:e_http_inspector/src/vn/com/extremevn/common/date_time_util.dart';
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
            isSearching: false));

  @override
  Stream<HttpDetailState> processEvent(HttpDetailEvent event) async* {
    var currentState = state;
    if (event is HttpDetailLoadEvent) {
      List<MapEntryEntity> overview = [];
      bool isJsonBody = true;
      var totalHttpTime = event.httpCallEntity.responseTimeMillisecond -
          event.httpCallEntity.requestTimeMillisecond;
      overview.add(MapEntryEntity(
          entryKey: Keys.url, entryValue: event.httpCallEntity.host ?? empty));
      overview.add(MapEntryEntity(
          entryKey: Keys.method,
          entryValue: event.httpCallEntity.method ?? empty));
      overview.add(MapEntryEntity(
          entryKey: Keys.responseCode,
          entryValue: event.httpCallEntity.responseCode.toString()));
      overview.add(MapEntryEntity(
          entryKey: Keys.requestAt,
          entryValue: event.httpCallEntity.requestTime ?? empty));
      overview.add(MapEntryEntity(
          entryKey: Keys.responseAt,
          entryValue: event.httpCallEntity.responseTime ?? empty));
      overview.add(MapEntryEntity(
          entryKey: Keys.requestedTime,
          entryValue: "${totalHttpTime.toString()}ms"));

      List<MapEntryEntity> responseResultList = [];
      if (event.httpCallEntity.responseHeader != null) {
        responseResultList.addAll(event.httpCallEntity.responseHeader!);
        for (var element in event.httpCallEntity.responseHeader!) {
          if (element.entryKey == contentType &&
              !element.entryValue.contains(contentTypeJson)) {
            isJsonBody = false;
          }
        }
      }

      if (event.httpCallEntity.response != null) {
        responseResultList.add(MapEntryEntity(
            entryKey: bodyTitle,
            entryValue:
                isJsonBody ? event.httpCallEntity.response! : contentBinary));
      }

      List<MapEntryEntity> requestResultList = [];
      if (event.httpCallEntity.requestHeader != null &&
          event.httpCallEntity.requestHeader!.isNotEmpty) {
        requestResultList.addAll(event.httpCallEntity.requestHeader!);
      }
      if (event.httpCallEntity.requestFormData != null &&
          event.httpCallEntity.requestFormData!.isNotEmpty) {
        requestResultList.addAll(event.httpCallEntity.requestFormData!);
      }
      if (event.httpCallEntity.requestBody != null &&
          event.httpCallEntity.requestBody!.isNotEmpty) {
        requestResultList.add(MapEntryEntity(
            entryKey: bodyTitle,
            entryValue: event.httpCallEntity.requestBody!));
      }

      yield currentState.copy(
          isInit: false,
          overview: overview,
          response: responseResultList,
          request: requestResultList);
    } else if (event is HttpDetailOnSearchQueryChangeEvent) {
      yield currentState.copy(query: event.value);
    } else if (event is HttpDetailSearchEvent) {
      yield currentState.copy(
          isSearching: !currentState.isSearching, query: empty);
    } else if (event is HttpDetailTabChangeEvent) {
      yield currentState.copy(
          isInit: false, currentIndex: event.currentTabIndex);
    } else if (event is HttpDetailCopyClickedEvent) {
      List<String> clipBoardData = [];
      if (currentState.currentIndex == 0) {
        for (var element in currentState.overview) {
          clipBoardData.add('${element.entryKey}: ${element.entryValue}');
        }
      } else if (currentState.currentIndex == 1) {
        for (var element in currentState.request) {
          clipBoardData.add('${element.entryKey}: ${element.entryValue}');
        }
      } else {
        for (var element in currentState.response) {
          clipBoardData.add('${element.entryKey}: ${element.entryValue}');
        }
      }
      var clipBoard = clipBoardData.join("\n");
      Clipboard.setData(ClipboardData(text: clipBoard));
      _write(clipBoard);
    }
  }

  _write(String text) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File(
        '${directory.path}/${DateTimeUtil.getCurrentTime(format: DateTimeUtil.dateTimeFormatHhMmSs)}.txt');
    await file.writeAsString(text);
  }
}
