import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:meditation_app/features/music/domain/models/music_track.dart';

class MusicNotifier extends StateNotifier<List<MusicTrack>> {
  final Box<MusicTrack> _box;

  MusicNotifier(this._box) : super(_box.values.toList());

  Future<void> addTrack(MusicTrack track) async {
    await _box.put(track.id, track);
    state = _box.values.toList();
  }

  Future<void> updateTrack(MusicTrack track) async {
    await _box.put(track.id, track);
    state = _box.values.toList();
  }

  Future<void> deleteTrack(String id) async {
    await _box.delete(id);
    state = _box.values.toList();
  }

  Future<void> toggleDownloadStatus(String id) async {
    final track = _box.get(id);
    if (track != null) {
      await _box.put(id, track.copyWith(isDownloaded: !track.isDownloaded));
      state = _box.values.toList();
    }
  }
}

final musicProvider = StateNotifierProvider<MusicNotifier, List<MusicTrack>>((ref) {
  final box = Hive.box<MusicTrack>('music_tracks');
  return MusicNotifier(box);
});
