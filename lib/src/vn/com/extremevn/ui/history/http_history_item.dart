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
import 'package:flutter/material.dart';

class HttpHistoryItemWidget extends StatelessWidget {
  const HttpHistoryItemWidget({Key? key, required this.item}) : super(key: key);

  final HttpCallEntity item;

  @override
  Widget build(BuildContext context) {
    var totalHttpTime =
        item.responseTimeMillisecond - item.requestTimeMillisecond;
    Color color = _getItemPrimaryColor();
    return Container(
      padding: const EdgeInsets.only(
          top: AppDimenKeys.historyScreenItemPaddingTop,
          left: AppDimenKeys.historyScreenItemPaddingLeft,
          right: AppDimenKeys.historyScreenItemPaddingRight),
      child: Column(
        children: <Widget>[
          Row(
            children: [
              Expanded(
                  flex: AppDimenKeys.historyScreenItemLeftFlex,
                  child: Container(
                    padding: const EdgeInsets.only(
                        right: AppDimenKeys
                            .historyScreenItemResponseCodePaddingRight),
                    child: Text(item.responseCode.toString(),
                        style: TextStyle(color: color)),
                  )),
              Expanded(
                flex: AppDimenKeys.historyScreenItemRightFlex,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${item.method} ${item.url}",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: AppDimenKeys.commonMediumFontSize,
                          color: color),
                    ),
                    Row(
                      children: [
                        item.schema == httpsSchema
                            ? const Padding(
                                padding: EdgeInsets.only(
                                    right: AppDimenKeys
                                        .historyScreenItemPaddingRight),
                                child: Icon(
                                  Icons.https,
                                  size: AppDimenKeys.historyScreenItemIconSize,
                                  color: Colors.purple,
                                ),
                              )
                            : const Padding(
                                padding: EdgeInsets.only(
                                    right: AppDimenKeys
                                        .historyScreenItemPaddingRight),
                                child: Icon(
                                  Icons.https,
                                  size: AppDimenKeys.historyScreenItemIconSize,
                                  color: Colors.grey,
                                ),
                              ),
                        Text(
                          item.host ?? empty,
                          style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: AppDimenKeys.commonMediumFontSize),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item.requestTime ?? empty,
                            style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: AppDimenKeys.commonMediumFontSize),
                          ),
                          Text(
                            "${totalHttpTime.toString()}ms",
                            style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: AppDimenKeys.commonMediumFontSize),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.only(
                top: AppDimenKeys.historyScreenItemDividerMarginTop),
            width: double.infinity,
            height: AppDimenKeys.commonDividerHeight,
            color: Colors.black26,
          )
        ],
      ),
    );
  }

  Color _getItemPrimaryColor() {
    if (item.responseCode == null ||
        (item.responseCode! >= 400 && item.responseCode! <= 500) ||
        item.responseCode == 0) {
      return Colors.red;
    } else if (item.responseCode! >= 200 && item.responseCode! < 300) {
      return Colors.blue;
    } else if (item.responseCode! >= 300 && item.responseCode! < 400) {
      return Colors.green;
    } else {
      return Colors.blueGrey;
    }
  }
}
