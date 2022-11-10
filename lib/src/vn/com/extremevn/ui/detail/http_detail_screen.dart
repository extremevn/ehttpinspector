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

import 'package:e_http_inspector/src/vn/com/extremevn/common/constant.dart';
import 'package:e_http_inspector/src/vn/com/extremevn/data/entity/http_call_entity.dart';
import 'package:e_http_inspector/src/vn/com/extremevn/ui/detail/http_detail_event.dart';
import 'package:e_http_inspector/src/vn/com/extremevn/ui/detail/http_detail_item.dart';
import 'package:e_http_inspector/src/vn/com/extremevn/ui/detail/http_detail_processor.dart';
import 'package:e_http_inspector/src/vn/com/extremevn/ui/detail/http_detail_state.dart';
import 'package:eventstateprocessor/eventstateprocessor.dart';
import 'package:flutter/material.dart';

//ignore: must_be_immutable
class HttpDetailScreen extends CoreScreen<HttpDetailEvent, HttpDetailState> {
  final HttpCallEntity? item;
  final int? id;
  TabController? _tabController;
  static const totalTab = 3;

  final FocusNode _detailSearchFocusNode = FocusNode();
  final _detailSearchController = TextEditingController();

  final List<Tab> tabs = <Tab>[
    const Tab(
        child: Text(AppLocalizationKeys.detailScreenOverview,
            style: TextStyle(fontSize: AppDimenKeys.commonLargeFontSize))),
    const Tab(
        child: Text(AppLocalizationKeys.detailScreenRequest,
            style: TextStyle(fontSize: AppDimenKeys.commonLargeFontSize))),
    const Tab(
        child: Text(AppLocalizationKeys.detailScreenResponse,
            style: TextStyle(fontSize: AppDimenKeys.commonLargeFontSize))),
  ];

  HttpDetailScreen({Key? key, this.item, this.id}) : super(key: key);

  @override
  void onScreenInit() {
    super.onScreenInit();
    _tabController = TabController(vsync: tickerProvider, length: tabs.length);
  }

  @override
  void onScreenDisposed() {
    _tabController?.dispose();
    _tabController = null;
  }

  @override
  Widget buildScreenUi(BuildContext context) {
    if (state.isInit) {
      processor.raiseEvent(HttpDetailLoadEvent(httpCallEntity: item, id: id));
      _tabController?.addListener(() {
        if (_tabController != null && _tabController!.indexIsChanging) {
          processor.raiseEvent(
              HttpDetailTabChangeEvent(currentTabIndex: _tabController!.index));
        }
      });
    }
    return DefaultTabController(
      length: totalTab,
      child: Scaffold(
          appBar: _createAppBar(state),
          body: Container(
              padding: const EdgeInsets.all(AppDimenKeys.commonContentPadding),
              child: _createTabBarView(state))),
    );
  }

  AppBar _createAppBar(HttpDetailState state) {
    return AppBar(
      backgroundColor: ColorKeys.colorBlue,
      title: state.isSearching
          ? TextField(
              controller: _detailSearchController,
              focusNode: _detailSearchFocusNode,
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
              maxLength: 50,
              style: const TextStyle(color: Colors.white),
              onChanged: (value) {
                processor.raiseEvent(
                    HttpDetailOnSearchQueryChangeEvent(value: value));
              },
            )
          : const Text(AppLocalizationKeys.detailScreenDetails),
      actions: <Widget>[
        IconButton(
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
            _detailSearchController.clear();
            processor.raiseEvent(HttpDetailSearchEvent());
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.copy,
            color: Colors.white,
          ),
          onPressed: () {
            processor.raiseEvent(HttpDetailCopyClickedEvent());
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(AppLocalizationKeys.detailScreenCopied),
            ));
          },
        )
      ],
      bottom: TabBar(
        tabs: tabs,
        controller: _tabController,
      ),
    );
  }

  TabBarView _createTabBarView(HttpDetailState state) {
    return TabBarView(
      controller: _tabController,
      children: [
        ListView.builder(
            shrinkWrap: true,
            itemCount: state.overview.length,
            itemBuilder: (BuildContext context, int index) =>
                HttpDetailItemWidget(
                    item: state.overview[index], query: state.query)),
        ListView.builder(
            shrinkWrap: true,
            itemCount: state.request.length,
            itemBuilder: (BuildContext context, int index) =>
                HttpDetailItemWidget(
                    item: state.request[index], query: state.query)),
        ListView.builder(
            shrinkWrap: true,
            itemCount: state.response.length,
            itemBuilder: (BuildContext context, int index) =>
                HttpDetailItemWidget(
                    item: state.response[index], query: state.query)),
      ],
    );
  }

  @override
  HttpDetailEventStateProcessor createEventProcessor(BuildContext context) {
    return HttpDetailEventStateProcessor();
  }
}
