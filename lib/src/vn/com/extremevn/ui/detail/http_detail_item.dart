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
import 'package:e_http_inspector/src/vn/com/extremevn/data/entity/map_entry_entity.dart';
import 'package:flutter/material.dart';

class HttpDetailItemWidget extends StatelessWidget {
  const HttpDetailItemWidget(
      {Key? key, required this.item, required this.query})
      : super(key: key);

  final MapEntryEntity item;
  final String query;

  @override
  Widget build(BuildContext context) {
    return item.entryKey == bodyTitle
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HttpHighLightItemWidget(
                text: '${item.entryKey}:',
                query: query,
              ),
              HttpHighLightItemWidget(
                text: item.entryValue,
                query: query,
              )
            ],
          )
        : Container(
            decoration: BoxDecoration(
                color: ColorKeys.colorItemDetail,
                border:
                    Border(bottom: BorderSide(color: Colors.teal.shade100))),
            child: Row(
              children: [
                Expanded(
                    flex: AppDimenKeys.detailScreenOverviewKeysFlex.toInt(),
                    child: HttpHighLightItemWidget(
                      text: item.entryKey,
                      query: query,
                    )),
                Expanded(
                  flex: AppDimenKeys.detailScreenOverviewValuesFlex.toInt(),
                  child: HttpHighLightItemWidget(
                    text: item.entryValue,
                    query: query,
                  ),
                )
              ],
            ),
            padding: const EdgeInsets.all(AppDimenKeys.detailScreenItemPadding),
          );
  }
}

class HttpHighLightItemWidget extends StatelessWidget {
  const HttpHighLightItemWidget(
      {Key? key, required this.text, required this.query})
      : super(key: key);

  final String text;
  final String query;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _highLightText(text, query),
    );
  }

  List<TextSpan> highlightOccurrences(String source, String query) {
    if (query.isEmpty || !source.toLowerCase().contains(query.toLowerCase())) {
      return [TextSpan(text: source)];
    }
    final matches = query.toLowerCase().allMatches(source.toLowerCase());

    int lastMatchEnd = 0;

    final List<TextSpan> children = [];
    for (var i = 0; i < matches.length; i++) {
      final match = matches.elementAt(i);

      if (match.start != lastMatchEnd) {
        children.add(TextSpan(
          text: source.substring(lastMatchEnd, match.start),
        ));
      }

      children.add(TextSpan(
        text: source.substring(match.start, match.end),
        style:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber),
      ));

      if (i == matches.length - 1 && match.end != source.length) {
        children.add(TextSpan(
          text: source.substring(match.end, source.length),
        ));
      }

      lastMatchEnd = match.end;
    }
    return children;
  }

  Widget _highLightText(String text, String query) {
    return RichText(
      text: TextSpan(
        children: highlightOccurrences(text, query),
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}
