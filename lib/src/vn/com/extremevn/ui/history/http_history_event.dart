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

import 'package:eventstateprocessor/eventstateprocessor.dart';

abstract class HttpHistoryEvent extends UiEvent {
  const HttpHistoryEvent();
}

class HttpHistoryLoadEvent extends HttpHistoryEvent {
  @override
  String toString() => "HttpHistoryLoadEvent";
}

class HttpHistoryDeleteAllEvent extends HttpHistoryEvent {
  @override
  String toString() => "HttpHistoryDeleteAllEvent";
}

class HttpHistoryOnSearchQueryChangedEvent extends HttpHistoryEvent {
  String query;

  HttpHistoryOnSearchQueryChangedEvent({required this.query});

  @override
  String toString() => "HttpHistoryOnSearchQueryChangedEvent, query: $query";
}

class HttpHistorySearchEvent extends HttpHistoryEvent {
  @override
  String toString() => "HttpHistorySearchEvent";
}

class HttpHistoryChoicesChangeEvent extends HttpHistoryEvent {
  List<String> choices;

  @override
  String toString() => "HttpHistoryChoicesChangeEvent";

  HttpHistoryChoicesChangeEvent({required this.choices});
}
