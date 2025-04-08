// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meditation_session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MeditationSessionAdapter extends TypeAdapter<MeditationSession> {
  @override
  final int typeId = 0;

  @override
  MeditationSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MeditationSession(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      duration: fields[3] as Duration,
      audioUrl: fields[4] as String,
      imageUrl: fields[5] as String,
      createdAt: fields[6] as DateTime,
      isFavorite: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, MeditationSession obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.duration)
      ..writeByte(4)
      ..write(obj.audioUrl)
      ..writeByte(5)
      ..write(obj.imageUrl)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.isFavorite);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeditationSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
