// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_todo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveTodoAdapter extends TypeAdapter<HiveTodo> {
  @override
  final int typeId = 0;

  @override
  HiveTodo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveTodo()
      ..id = fields[0] as String
      ..title = fields[1] as String
      ..description = fields[2] as String
      ..isCompleted = fields[3] as bool
      ..createdAt = fields[4] as DateTime
      ..dueDate = fields[5] as DateTime?
      ..priority = fields[6] as int;
  }

  @override
  void write(BinaryWriter writer, HiveTodo obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.isCompleted)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.dueDate)
      ..writeByte(6)
      ..write(obj.priority);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveTodoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
