// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sleep_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SleepDataAdapter extends TypeAdapter<SleepData> {
  @override
  final int typeId = 1;

  @override
  SleepData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SleepData(
      id: fields[0] as String,
      startTime: fields[1] as DateTime,
      endTime: fields[2] as DateTime,
      qualityRating: fields[3] as int,
      notes: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SleepData obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.startTime)
      ..writeByte(2)
      ..write(obj.endTime)
      ..writeByte(3)
      ..write(obj.qualityRating)
      ..writeByte(4)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SleepDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
