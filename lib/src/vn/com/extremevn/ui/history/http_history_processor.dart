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

import 'package:e_http_inspector/src/vn/com/extremevn/common/constant.dart';
import 'package:e_http_inspector/src/vn/com/extremevn/common/hive_util.dart';
import 'package:e_http_inspector/src/vn/com/extremevn/data/entity/http_call_entity.dart';
import 'package:e_http_inspector/src/vn/com/extremevn/ui/history/http_history_state.dart';
import 'package:eventstateprocessor/eventstateprocessor.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import 'http_history_event.dart';

class HttpHistoryEventStateProcessor
    extends EventToStateProcessor<HttpHistoryEvent, HttpHistoryState> {
  VoidCallback? listener;

  HttpHistoryEventStateProcessor()
      : super(
          HttpHistoryState(
              isInit: true,
              isLoading: false,
              isSearching: false,
              query: empty,
              chips: [],
              choices: [],
              httpCalls: [],
              httpCallSearchResult: []),
        ) {
    _initHiveListener();
    on<HttpHistoryLoadEvent>(onHttpHistoryLoadEvent);
    on<HttpHistoryDeleteAllEvent>(onHttpHistoryDeleteAllEvent);
    on<HttpHistoryOnSearchQueryChangedEvent>(
        onHttpHistoryOnSearchQueryChangedEvent);
    on<HttpHistorySearchEvent>(onHttpHistorySearchEvent);
    on<HttpHistoryChoicesChangeEvent>(onHttpHistoryChoicesChangeEvent);
  }

  FutureOr<void> onHttpHistoryLoadEvent(
      HttpHistoryLoadEvent event, Emitter<HttpHistoryState> emitter) async {
    emitter.call(state.copy(isLoading: true));
    List<HttpCallEntity> httpCalls = [];
    List<String> chips = [];
    for (var element in HiveUtil.dataBox.values) {
      var httpCall = element as HttpCallEntity;
      httpCalls.add(httpCall);
    }
    _sortHttpCallEntityList(httpCalls);
    chips = _getHttpResponseCodeChips(httpCalls);
    emitter.call(state.copy(
        httpCalls: httpCalls, chips: chips, isInit: false, isLoading: false));
  }

  FutureOr<void> onHttpHistoryDeleteAllEvent(HttpHistoryDeleteAllEvent event,
      Emitter<HttpHistoryState> emitter) async {
    await HiveUtil.dataBox.clear();
    emitter.call(state.copy(
        httpCalls: [],
        isLoading: false,
        isSearching: false,
        httpCallSearchResult: []));
  }

  FutureOr<void> onHttpHistoryOnSearchQueryChangedEvent(
      HttpHistoryOnSearchQueryChangedEvent event,
      Emitter<HttpHistoryState> emitter) async {
    if (event.query.isEmpty && state.choices.isEmpty) {
      emitter.call(state.copy(httpCallSearchResult: [], query: event.query));
    } else {
      List<HttpCallEntity> httpCallSearchResult = _filterHttpCallEntityList(
          state.choices, event.query, state.httpCalls);
      emitter.call(state.copy(
          httpCallSearchResult: httpCallSearchResult, query: event.query));
    }
  }

  FutureOr<void> onHttpHistorySearchEvent(
      HttpHistorySearchEvent event, Emitter<HttpHistoryState> emitter) async {
    if (state.choices.isEmpty) {
      emitter.call(state.copy(
          httpCallSearchResult: [],
          query: empty,
          isSearching: !state.isSearching));
    } else {
      emitter.call(state.copy(
          httpCallSearchResult:
              _filterHttpCallEntityList(state.choices, "", state.httpCalls),
          query: empty,
          isSearching: !state.isSearching));
    }
  }

  FutureOr<void> onHttpHistoryChoicesChangeEvent(
      HttpHistoryChoicesChangeEvent event,
      Emitter<HttpHistoryState> emitter) async {
    List<HttpCallEntity> httpCallSearchResult =
        _filterHttpCallEntityList(event.choices, state.query, state.httpCalls);
    emitter.call(state.copy(
        choices: event.choices, httpCallSearchResult: httpCallSearchResult));
  }

  @override
  Future<void> close() async {
    _disposeHiveListener();
    super.close();
  }

  void _initHiveListener() async {
    listener = () {
      raiseEvent(HttpHistoryLoadEvent());
    };
    final box = await HiveUtil.openHiveBox(httpCallEntityBox);
    box.listenable().addListener(listener!);
  }

  void _disposeHiveListener() async {
    if (listener != null) {
      final box = await HiveUtil.openHiveBox(httpCallEntityBox);
      box.listenable().removeListener(listener!);
      listener = null;
    }
  }

  void _sortHttpCallEntityList(List<HttpCallEntity> httpCallEntityList) {
    httpCallEntityList.sort(
        (a, b) => b.requestTimeMillisecond.compareTo(a.requestTimeMillisecond));
  }

  List<String> _getHttpResponseCodeChips(
      List<HttpCallEntity> httpCallEntityList) {
    List<String> chips = [];
    for (var httpCallEntity in httpCallEntityList) {
      var resCode = httpCallEntity.responseCode.toString();
      if (!chips.any((element) => resCode == element)) {
        chips.add(resCode);
      }
    }
    return chips;
  }

  List<HttpCallEntity> _filterHttpCallEntityList(
      List<String> choices, String query, List<HttpCallEntity> httpCalls) {
    List<HttpCallEntity> httpCallSearchResult = [];
    List<HttpCallEntity> queryHttpCallSearchResult = [];
    if (query.isNotEmpty) {
      for (var httpCall in httpCalls) {
        bool urlContainQuery =
            httpCall.url?.toLowerCase().contains(query.toLowerCase()) ?? false;
        if (urlContainQuery) {
          queryHttpCallSearchResult.add(httpCall);
        }
      }
    } else {
      queryHttpCallSearchResult = httpCalls;
    }
    if (choices.isNotEmpty) {
      for (var httpCall in queryHttpCallSearchResult) {
        var responseCode = httpCall.responseCode.toString();
        if (choices.any((element) => responseCode == element)) {
          httpCallSearchResult.add(httpCall);
        }
      }
    } else {
      httpCallSearchResult = queryHttpCallSearchResult;
    }
    _sortHttpCallEntityList(httpCallSearchResult);
    return httpCallSearchResult;
  }
}
