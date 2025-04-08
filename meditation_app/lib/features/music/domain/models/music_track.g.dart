// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_track.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MusicTrackAdapter extends TypeAdapter<MusicTrack> {
  @override
  final int typeId = 2;

  @override
  MusicTrack read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MusicTrack(
      id: fields[0] as String,
      title: fields[1] as String,
      artist: fields[2] as String,
      audioUrl: fields[3] as String,
      imageUrl: fields[4] as String?,
      duration: fields[5] as Duration,
      isDownloaded: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, MusicTrack obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.artist)
      ..writeByte(3)
      ..write(obj.audioUrl)
      ..writeByte(4)
      ..write(obj.imageUrl)
      ..writeByte(5)
      ..write(obj.duration)
      ..writeByte(6)
      ..write(obj.isDownloaded);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MusicTrackAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
