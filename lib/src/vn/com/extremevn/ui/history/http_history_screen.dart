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

import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';
import 'package:e_http_inspector/src/vn/com/extremevn/common/constant.dart';
import 'package:e_http_inspector/src/vn/com/extremevn/ui/detail/http_detail_screen.dart';
import 'package:e_http_inspector/src/vn/com/extremevn/ui/history/http_history_event.dart';
import 'package:e_http_inspector/src/vn/com/extremevn/ui/history/http_history_item.dart';
import 'package:e_http_inspector/src/vn/com/extremevn/ui/history/http_history_processor.dart';
import 'package:e_http_inspector/src/vn/com/extremevn/ui/history/http_history_state.dart';
import 'package:eventstateprocessor/eventstateprocessor.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

//ignore: must_be_immutable
class HttpHistoryScreen extends CoreScreen<HttpHistoryEvent, HttpHistoryState> {
  final FocusNode _historySearchFocusNode = FocusNode();
  final _historySearchController = TextEditingController();
  final RefreshController _refreshSuccessHttpCallController =
      RefreshController(initialRefresh: false);
  static const totalTab = 2;

  HttpHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget buildScreenUi(BuildContext context) {
    if (state.isInit) {
      processor.raiseEvent(HttpHistoryLoadEvent());
    }
    return _historyScreen(state);
  }

  Widget _historyScreen(HttpHistoryState state) {
    return Scaffold(
      appBar: _createAppBar(state),
      body: _createBody(state),
    );
  }

  AppBar _createAppBar(HttpHistoryState state) {
    return AppBar(
      backgroundColor: ColorKeys.colorBlue,
      bottom: state.httpCalls.isNotEmpty
          ? PreferredSize(
              preferredSize: const Size.fromHeight(
                  AppDimenKeys.historyScreenChipsChoicesHeight),
              child: ChipsChoice<String>.multiple(
                value: state.choices,
                placeholder: "",
                onChanged: (val) {
                  processor
                      .raiseEvent(HttpHistoryChoicesChangeEvent(choices: val));
                },
                choiceItems: C2Choice.listFrom<String, String>(
                  source: state.chips,
                  value: (i, v) => v,
                  label: (i, v) => v,
                ),
                choiceActiveStyle: const C2ChoiceStyle(
                  color: Color.fromARGB(255, 54, 57, 244),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                choiceStyle: const C2ChoiceStyle(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
              ),
            )
          : PreferredSize(
              preferredSize: const Size.fromHeight(0),
              child: Container(),
            ),
      title: state.isSearching
          ? TextField(
              controller: _historySearchController,
              focusNode: _historySearchFocusNode,
              maxLength: 50,
              decoration: const InputDecoration(
                  hintText: AppLocalizationKeys.commonSearch,
                  border: InputBorder.none,
                  counterText: empty,
                  hintStyle: TextStyle(
                      color: Colors.white,
                      fontSize: AppDimenKeys.commonExtraLargeFontSize),
                  contentPadding:
                      EdgeInsets.all(AppDimenKeys.commonContentPadding)),
              cursorColor: Colors.amber,
              style: const TextStyle(color: Colors.white),
              onChanged: (value) {
                processor.raiseEvent(
                    HttpHistoryOnSearchQueryChangedEvent(query: value));
              },
            )
          : const Text(AppLocalizationKeys.historyScreenHttp),
      actions: <Widget>[
        Visibility(
            visible: state.httpCalls.isNotEmpty,
            child: IconButton(
              icon: state.isSearching
                  ? const Icon(
                      Icons.close,
                      color: Colors.white,
                    )
                  : const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
              onPressed: () {
                _historySearchController.clear();
                processor.raiseEvent(HttpHistorySearchEvent());
              },
            )),
        Visibility(
            visible: state.httpCalls.isNotEmpty,
            child: IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: const Text(
                          AppLocalizationKeys.historyScreenDeleteConfirm),
                      actions: [
                        TextButton(
                          child: const Text(
                              AppLocalizationKeys.historyScreenCancel),
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                        ),
                        TextButton(
                          child:
                              const Text(AppLocalizationKeys.historyScreenOk),
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop();
                            processor.raiseEvent(HttpHistoryDeleteAllEvent());
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ))
      ],
    );
  }

  Widget _createBody(HttpHistoryState state) {
    return SmartRefresher(
      enablePullDown: !state.isSearching,
      header: const ClassicHeader(),
      controller: _refreshSuccessHttpCallController,
      onRefresh: () {
        processor.raiseEvent(HttpHistoryLoadEvent());
      },
      child: ListView.builder(
          itemCount:
              state.httpCallSearchResult.isNotEmpty || state.query.isNotEmpty
                  ? state.httpCallSearchResult.length
                  : state.httpCalls.length,
          itemBuilder: (BuildContext context, int index) => InkWell(
                onTap: () {
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                        builder: (context) => HttpDetailScreen(
                            item: state.httpCallSearchResult.isNotEmpty ||
                                    state.query.isNotEmpty
                                ? state.httpCallSearchResult[index]
                                : state.httpCalls[index])),
                  );
                },
                child: HttpHistoryItemWidget(
                    item: state.httpCallSearchResult.isNotEmpty ||
                            state.query.isNotEmpty
                        ? state.httpCallSearchResult[index]
                        : state.httpCalls[index]),
              )),
    );
  }

  @override
  HttpHistoryEventStateProcessor createEventProcessor(BuildContext context) {
    return HttpHistoryEventStateProcessor();
  }
}
