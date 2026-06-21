// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bmi_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BMIRecordAdapter extends TypeAdapter<BMIRecord> {
  @override
  final int typeId = 0;

  @override
  BMIRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BMIRecord(
      dateTime: fields[0] as DateTime,
      weight: fields[1] as double,
      height: fields[2] as double,
      bmi: fields[3] as double,
      category: fields[4] as String,
      gender: fields[5] as String,
      age: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, BMIRecord obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.dateTime)
      ..writeByte(1)
      ..write(obj.weight)
      ..writeByte(2)
      ..write(obj.height)
      ..writeByte(3)
      ..write(obj.bmi)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.gender)
      ..writeByte(6)
      ..write(obj.age);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BMIRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
