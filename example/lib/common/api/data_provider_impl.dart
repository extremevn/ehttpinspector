import 'package:dio/dio.dart';
import 'package:e_http_inspector/e_http_inspector.dart';
import 'package:e_http_inspector_example/common/api/rest_api.dart';

class DataProviderImpl {
  late RestApiClient client;

  Future<void> init(Dio dio) async {
    EHttpInspector.initInterceptor(dio);
    client = RestApiClient(dio);
  }

  Future callApi() async {
    client.createStamp(
        name: "morpheus",
        job: "leader",
        id: 132,
        createdAt: "2022-04-14T02:34:51.527Z");
  }
}
