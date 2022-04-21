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

import 'package:e_http_inspector_example/common/ui/generated/app_dimen_keys.g.dart';
import 'package:e_http_inspector_example/request_item.dart';
import 'package:esizer/esizer.dart';
import 'package:flutter/material.dart';

class HttpRequestItemWidget extends StatelessWidget {
  const HttpRequestItemWidget({Key? key, required this.item}) : super(key: key);

  final RequestItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(AppDimenKeys.mainScreenItemPadding.r),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.only(
                      right: AppDimenKeys.mainScreenItemPadding.r),
                  child: Text(
                    item.method,
                    style: TextStyle(
                        fontSize: AppDimenKeys.commonMediumFontSize.sp,
                        fontWeight: FontWeight.w500),
                  )),
              Expanded(
                  child: Text(item.url,
                      style: TextStyle(
                        fontSize: AppDimenKeys.commonMediumFontSize.sp,
                      ))),
            ],
          ),
        ),
        Container(
          color: Colors.teal.shade100,
          height: 1.0,
          width: double.infinity,
        )
      ],
    );
  }
}
