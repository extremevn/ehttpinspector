// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_entry_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MapEntryEntityAdapter extends TypeAdapter<MapEntryEntity> {
  @override
  final int typeId = 101;

  @override
  MapEntryEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MapEntryEntity(
      entryKey: fields[0] as String,
      entryValue: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MapEntryEntity obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.entryKey)
      ..writeByte(1)
      ..write(obj.entryValue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MapEntryEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
