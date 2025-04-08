import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:meditation_app/features/meditation/domain/models/meditation_session.dart';

class MeditationNotifier extends StateNotifier<List<MeditationSession>> {
  final Box<MeditationSession> _box;

  MeditationNotifier(this._box) : super(_box.values.toList());

  Future<void> addSession(MeditationSession session) async {
    await _box.put(session.id, session);
    state = _box.values.toList();
  }

  Future<void> updateSession(MeditationSession session) async {
    await _box.put(session.id, session);
    state = _box.values.toList();
  }

  Future<void> deleteSession(String id) async {
    await _box.delete(id);
    state = _box.values.toList();
  }

  Future<void> toggleFavorite(String id) async {
    final session = _box.get(id);
    if (session != null) {
      await _box.put(id, session.copyWith(isFavorite: !session.isFavorite));
      state = _box.values.toList();
    }
  }
}

final meditationProvider = StateNotifierProvider<MeditationNotifier, List<MeditationSession>>((ref) {
  final box = Hive.box<MeditationSession>('meditation_sessions');
  return MeditationNotifier(box);
});
