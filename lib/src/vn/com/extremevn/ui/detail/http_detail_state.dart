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

import 'package:e_http_inspector/src/vn/com/extremevn/data/entity/map_entry_entity.dart';
import 'package:eventstateprocessor/eventstateprocessor.dart';

class HttpDetailState extends DataState {
  final bool isInit;
  final bool isLoading;
  final bool isSearching;
  final int currentIndex;
  final List<MapEntryEntity> response;
  final List<MapEntryEntity> request;
  final List<MapEntryEntity> overview;
  final String query;

  HttpDetailState({
    required this.isInit,
    required this.isLoading,
    required this.response,
    required this.request,
    required this.query,
    required this.isSearching,
    required this.currentIndex,
    required this.overview,
  });

  HttpDetailState copy(
      {bool? isInit,
      bool? isLoading,
      bool? isSearching,
      int? currentIndex,
      String? query,
      List<MapEntryEntity>? response,
      List<MapEntryEntity>? request,
      List<MapEntryEntity>? overview}) {
    return HttpDetailState(
      isInit: isInit ?? this.isInit,
      isLoading: isLoading ?? this.isLoading,
      isSearching: isSearching ?? this.isSearching,
      response: response ?? this.response,
      request: request ?? this.request,
      query: query ?? this.query,
      currentIndex: currentIndex ?? this.currentIndex,
      overview: overview ?? this.overview,
    );
  }

  @override
  String toString() =>
      'HttpDetailState {isInit: $isInit, isLoading: $isLoading, response $response, request $request, query $query, isSearching $isSearching, currentIndex $currentIndex }';
}
