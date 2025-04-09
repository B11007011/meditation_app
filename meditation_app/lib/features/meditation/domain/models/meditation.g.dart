// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meditation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MeditationAdapter extends TypeAdapter<Meditation> {
  @override
  final int typeId = 5;

  @override
  Meditation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Meditation(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      category: fields[3] as String,
      imageUrl: fields[4] as String,
      audioUrl: fields[5] as String,
      duration: fields[6] as Duration,
      narrator: fields[7] as String,
      isPremium: fields[8] as bool,
      isDownloaded: fields[9] as bool,
      localAudioPath: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Meditation obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.imageUrl)
      ..writeByte(5)
      ..write(obj.audioUrl)
      ..writeByte(6)
      ..write(obj.duration)
      ..writeByte(7)
      ..write(obj.narrator)
      ..writeByte(8)
      ..write(obj.isPremium)
      ..writeByte(9)
      ..write(obj.isDownloaded)
      ..writeByte(10)
      ..write(obj.localAudioPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeditationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
