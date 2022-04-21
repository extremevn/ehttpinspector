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

import 'package:e_http_inspector/src/vn/com/extremevn/data/entity/http_call_entity.dart';
import 'package:eventstateprocessor/eventstateprocessor.dart';

class HttpHistoryState extends DataState {
  final bool isInit;
  final bool isLoading;
  final List<HttpCallEntity> httpCalls;
  final List<HttpCallEntity> httpCallSearchResult;
  final List<String> chips;
  final List<String> choices;
  final bool isSearching;
  final String query;

  HttpHistoryState({
    required this.isInit,
    required this.isLoading,
    required this.isSearching,
    required this.query,
    required this.httpCalls,
    required this.httpCallSearchResult,
    required this.chips,
    required this.choices,
  });

  HttpHistoryState copy({
    bool? isInit,
    bool? isLoading,
    bool? isSearching,
    String? query,
    List<String>? chips,
    List<String>? choices,
    List<HttpCallEntity>? httpCalls,
    List<HttpCallEntity>? httpCallSearchResult,
  }) {
    return HttpHistoryState(
      isInit: isInit ?? this.isInit,
      isLoading: isLoading ?? this.isLoading,
      isSearching: isSearching ?? this.isSearching,
      query: query ?? this.query,
      chips: chips ?? this.chips,
      choices: choices ?? this.choices,
      httpCalls: httpCalls ?? this.httpCalls,
      httpCallSearchResult: httpCallSearchResult ?? this.httpCallSearchResult,
    );
  }

  @override
  String toString() =>
      'HttpHistoryState {isInit: $isInit, isLoading: $isLoading, httpCalls: $httpCalls, isSearching: $isSearching}';
}
