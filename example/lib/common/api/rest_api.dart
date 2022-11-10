import 'package:dio/dio.dart';
import 'package:e_http_inspector_example/common/pojo/user.dart';
import 'package:retrofit/retrofit.dart';

part 'rest_api.g.dart';

@RestApi(baseUrl: "https://reqres.in/api/users")
abstract class RestApiClient {
  factory RestApiClient(Dio dio, {String baseUrl}) = _RestApiClient;

  @POST("/user")
  Future<UserResponse> createStamp({
    @Field("name") required String name,
    @Field("job") required String job,
    @Field("id") required int id,
    @Field("createdAt") required String createdAt,
  });
}
