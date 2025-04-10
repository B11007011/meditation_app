// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sleep_story.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SleepStoryAdapter extends TypeAdapter<SleepStory> {
  @override
  final int typeId = 6;

  @override
  SleepStory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SleepStory(
      id: fields[0] as String,
      title: fields[1] as String,
      type: fields[2] as String,
      duration: fields[3] as Duration,
      imageUrl: fields[4] as String?,
      audioUrl: fields[5] as String?,
      narrator: fields[6] as String?,
      description: fields[7] as String?,
      isPremium: fields[8] as bool,
      isDownloaded: fields[9] as bool,
      localAudioPath: fields[10] as String?,
      tags: (fields[11] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, SleepStory obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.duration)
      ..writeByte(4)
      ..write(obj.imageUrl)
      ..writeByte(5)
      ..write(obj.audioUrl)
      ..writeByte(6)
      ..write(obj.narrator)
      ..writeByte(7)
      ..write(obj.description)
      ..writeByte(8)
      ..write(obj.isPremium)
      ..writeByte(9)
      ..write(obj.isDownloaded)
      ..writeByte(10)
      ..write(obj.localAudioPath)
      ..writeByte(11)
      ..write(obj.tags);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SleepStoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
