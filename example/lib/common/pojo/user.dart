import 'dart:convert';

import 'package:e_http_inspector_example/common/api/json_convert_content.dart';
import 'package:e_http_inspector_example/common/api/json_field.dart';

@JsonSerializable()
class UserResponse {
  String? name;
  String? job;
  int? id;
  String? createdAt;

  UserResponse({this.name, this.job, this.id, this.createdAt});

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      $UserResponseFromJson(json);

  Map<String, dynamic> toJson() => $UserResponseToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

UserResponse $UserResponseFromJson(Map<String, dynamic> json) {
  final UserResponse userResponse = UserResponse();
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    userResponse.name = name;
  }
  final String? job = jsonConvert.convert<String>(json['job']);
  if (job != null) {
    userResponse.job = job;
  }
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    userResponse.id = id;
  }
  final String? createdAt = jsonConvert.convert<String>(json['createdAt']);
  if (createdAt != null) {
    userResponse.createdAt = createdAt;
  }
  return userResponse;
}

Map<String, dynamic> $UserResponseToJson(UserResponse entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['name'] = entity.name;
  data['job'] = entity.job;
  data['id'] = entity.id;
  data['createdAt'] = entity.createdAt;
  return data;
}
