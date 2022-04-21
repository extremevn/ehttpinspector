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

import 'dart:ui';

/// Http call entity box name.
const String httpCallEntityBox = "httpCallEntity";
const String bodyTitle = "Body";
const String httpsSchema = "https";
const String contentType = "content-type";
const String contentTypeJson = "application/json";
const String contentBinary = "binary content";

const String empty = "";

class Keys {
  static const String url = "URL";
  static const String method = "Method";
  static const String responseCode = "Response Code";
  static const String requestAt = "Request at";
  static const String responseAt = "Response at";
  static const String requestedTime = "Requested time";
}

class ColorKeys {
  static const Color colorBlue = Color(0xff005598);
  static const Color colorItemDetail = Color(0xfffaf9f7);
}

abstract class AppDimenKeys {
  static const commonMediumFontSize = 14.0;
  static const commonLargeFontSize = 16.0;
  static const commonExtraLargeFontSize = 18.0;
  static const commonJumboFontSize = 20.0;
  static const commonDividerHeight = 1.0;
  static const commonContentPadding = 5.0;
  static const historyScreenChipsChoicesHeight = 50.0;
  static const historyScreenItemIconSize = 14.0;
  static const historyScreenItemPaddingTop = 10.0;
  static const historyScreenItemPaddingRight = 5.0;
  static const historyScreenItemPaddingLeft = 5.0;
  static const historyScreenItemLeftFlex = 1;
  static const historyScreenItemRightFlex = 6;
  static const historyScreenItemResponseCodePaddingRight = 20.0;
  static const historyScreenItemDividerMarginTop = 10.0;
  static const historyScreenPaddingBottom = 18.0;
  static const detailScreenOverviewKeysFlex = 1.0;
  static const detailScreenOverviewValuesFlex = 2.0;
  static const detailScreenPaddingBottom = 16.0;
  static const detailScreenItemPadding = 10.0;
}

abstract class AppLocalizationKeys {
  static const commonSearch = 'Search...';
  static const commonItemMillisecond = '{time}ms';
  static const detailScreenDetails = 'Details';
  static const detailScreenOverview = 'Overview';
  static const detailScreenRequest = 'Request';
  static const detailScreenResponse = 'Response';
  static const detailScreenCopied = 'Copied';
  static const historyScreenNetwork = 'Succeed requests';
  static const historyScreenError = 'Error requests';
  static const historyScreenHttp = 'History';
  static const historyScreenDeleteConfirm =
      'Are you sure to delete all record?';
  static const historyScreenCancel = 'Cancel';
  static const historyScreenOk = 'OK';
}
