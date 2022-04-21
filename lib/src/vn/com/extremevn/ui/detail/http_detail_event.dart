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

abstract class HttpDetailEvent extends UiEvent {}

class HttpDetailLoadEvent extends HttpDetailEvent {
  HttpCallEntity httpCallEntity;

  HttpDetailLoadEvent({required this.httpCallEntity});

  @override
  String toString() => "HttpDetailLoadEvent, httpCallEntity: $httpCallEntity";
}

class HttpDetailOnSearchQueryChangeEvent extends HttpDetailEvent {
  String value;

  HttpDetailOnSearchQueryChangeEvent({required this.value});

  @override
  String toString() => "HttpDetailOnSearchQueryChangeEvent, value: $value";
}

class HttpDetailSearchEvent extends HttpDetailEvent {
  @override
  String toString() => "HttpDetailClickSearchEvent";
}

class HttpDetailTabChangeEvent extends HttpDetailEvent {
  int currentTabIndex;

  HttpDetailTabChangeEvent({required this.currentTabIndex});

  @override
  String toString() => "HttpDetailLoadEvent, currentTabIndex: $currentTabIndex";
}

class HttpDetailCopyClickedEvent extends HttpDetailEvent {
  @override
  String toString() => "HttpDetailCopyClickedEvent";
}
