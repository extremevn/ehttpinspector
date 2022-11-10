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
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:e_http_inspector/e_http_inspector.dart';
import 'package:e_http_inspector_example/common/api/data_provider_impl.dart';
import 'package:e_http_inspector_example/common/ui/generated/app_localization_keys.g.dart';
import 'package:e_http_inspector_example/http_request_item.dart';
import 'package:e_http_inspector_example/request_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization_loader/easy_localization_loader.dart';
import 'package:esizer/esizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

var _dio = Dio();
GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
DataProviderImpl dataProviderImpl = DataProviderImpl();
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  EHttpInspector.initInterceptor(_dio);
  bool? hasPermission = await EHttpInspector.initNotification(_navigatorKey,
      "EHttpInspector", "EHttpInspector", "EHttpInspector channel");
  debugPrint("hasPermission: $hasPermission");
  await dataProviderImpl.init(_dio);
  runApp(
    EasyLocalization(
        supportedLocales: const [
          Locale('en', 'US'),
        ],
        useFallbackTranslations: true,
        fallbackLocale: const Locale('en', 'US'),
        path: 'assets/lang',
        assetLoader: YamlAssetLoader(),
        child: const MyApp()),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      title: AppLocalizationKeys.appName.tr(),
      navigatorKey: _navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      builder: (context, widget) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: widget!,
        );
      },
      home: ESizer(
          builder: (BuildContext context) {
            return MyHomePage(title: AppLocalizationKeys.mainScreenTitle.tr());
          },
          sizeFileResolver: (
                  {BoxConstraints? boxConstraints, Orientation? orientation}) =>
              "phone.yaml"),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<RequestItem> items = [];
  @override
  void initState() {
    super.initState();

    items.add(
        RequestItem(method: "POST", url: "https://reqres.in/api/users", param: {
      "name": "morpheus",
      "job": "leader",
      "id": 651,
      "createdAt": "2022-04-14T02:34:51.527Z"
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Stack(
          children: [
            ListView.builder(
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) => InkWell(
                      onTap: () {
                        dataProviderImpl.callApi();
                      },
                      child: HttpRequestItemWidget(item: items[index]),
                    )),
          ],
        ));
  }

  // void _bulkRequest() async {
  //   try {
  //     for (var element in items) {
  //       if (element.method == "GET") {
  //         await getHttp(element.url);
  //       } else {
  //         await postHttp(element.url, element.param);
  //       }
  //     }
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   }
  // }

  Future<void> getHttp(String url) async {
    try {
      await _dio.get(url);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> postHttp(String url, dynamic data) async {
    try {
      await _dio.post(url,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }),
          data: jsonEncode(data));
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
