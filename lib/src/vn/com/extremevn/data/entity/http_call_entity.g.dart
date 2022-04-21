// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'http_call_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HttpCallEntityAdapter extends TypeAdapter<HttpCallEntity> {
  @override
  final int typeId = 100;

  @override
  HttpCallEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HttpCallEntity()
      ..url = fields[0] as String?
      ..host = fields[1] as String?
      ..schema = fields[2] as String?
      ..method = fields[3] as String?
      ..requestHeader = (fields[4] as List?)?.cast<MapEntryEntity>()
      ..requestBody = fields[5] as String?
      ..requestFormData = (fields[6] as List?)?.cast<MapEntryEntity>()
      ..responseCode = fields[7] as int?
      ..response = fields[8] as String?
      ..responseHeader = (fields[9] as List?)?.cast<MapEntryEntity>()
      ..requestTime = fields[10] as String?
      ..responseTime = fields[11] as String?
      ..requestTimeMillisecond = fields[12] as int
      ..responseTimeMillisecond = fields[13] as int;
  }

  @override
  void write(BinaryWriter writer, HttpCallEntity obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.url)
      ..writeByte(1)
      ..write(obj.host)
      ..writeByte(2)
      ..write(obj.schema)
      ..writeByte(3)
      ..write(obj.method)
      ..writeByte(4)
      ..write(obj.requestHeader)
      ..writeByte(5)
      ..write(obj.requestBody)
      ..writeByte(6)
      ..write(obj.requestFormData)
      ..writeByte(7)
      ..write(obj.responseCode)
      ..writeByte(8)
      ..write(obj.response)
      ..writeByte(9)
      ..write(obj.responseHeader)
      ..writeByte(10)
      ..write(obj.requestTime)
      ..writeByte(11)
      ..write(obj.responseTime)
      ..writeByte(12)
      ..write(obj.requestTimeMillisecond)
      ..writeByte(13)
      ..write(obj.responseTimeMillisecond);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HttpCallEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
