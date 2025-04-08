import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:meditation_app/features/sleep/domain/models/sleep_data.dart';

class SleepNotifier extends StateNotifier<List<SleepData>> {
  final Box<SleepData> _box;

  SleepNotifier(this._box) : super(_box.values.toList());

  Future<void> addSleepData(SleepData data) async {
    await _box.put(data.id, data);
    state = _box.values.toList();
  }

  Future<void> updateSleepData(SleepData data) async {
    await _box.put(data.id, data);
    state = _box.values.toList();
  }

  Future<void> deleteSleepData(String id) async {
    await _box.delete(id);
    state = _box.values.toList();
  }
}

final sleepProvider = StateNotifierProvider<SleepNotifier, List<SleepData>>((ref) {
  final box = Hive.box<SleepData>('sleep_data');
  return SleepNotifier(box);
});
