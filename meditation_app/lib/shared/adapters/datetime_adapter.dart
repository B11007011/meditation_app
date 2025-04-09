import 'package:hive/hive.dart';

class DateTimeAdapter extends TypeAdapter<DateTime> {
  @override
  final int typeId = 33; // This is the missing adapter with typeId 33

  @override
  DateTime read(BinaryReader reader) {
    final timestamp = reader.readInt();
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  @override
  void write(BinaryWriter writer, DateTime obj) {
    writer.writeInt(obj.millisecondsSinceEpoch);
  }
} 