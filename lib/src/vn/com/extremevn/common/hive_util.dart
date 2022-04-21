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
import 'package:e_http_inspector/src/vn/com/extremevn/data/entity/map_entry_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveUtil {
  static const httpCallEntityTypeId = 100;
  static const mapEntryEntityTypeId = 101;

  static late Box _httpCallsBox;

  static get dataBox => _httpCallsBox;

  /// Open hive box.
  /// [boxName] specified name of box
  /// return [Box] instance
  static Future<Box> openHiveBox(String boxName) async {
    initAdapterIfNeed();
    if (!Hive.isBoxOpen(boxName)) {
      Hive.init((await getApplicationDocumentsDirectory()).path);
    }
    return await Hive.openBox(boxName);
  }

  /// Initialize hive and entity adapters.
  static Future<void> initHive() async {
    WidgetsFlutterBinding.ensureInitialized();
    final document = await getApplicationDocumentsDirectory();
    Hive.init(document.path);
    initAdapterIfNeed();
    _httpCallsBox = await HiveUtil.openHiveBox(httpCallEntityBox);
  }

  /// Close data box and Hive
  static Future<void> closeHive() async {
    await _httpCallsBox.close();
    await Hive.close();
  }

  /// Initialize hive entity adapters if need.
  static initAdapterIfNeed() {
    if (!Hive.isAdapterRegistered(httpCallEntityTypeId)) {
      Hive.registerAdapter(HttpCallEntityAdapter());
    }
    if (!Hive.isAdapterRegistered(mapEntryEntityTypeId)) {
      Hive.registerAdapter(MapEntryEntityAdapter());
    }
  }
}
