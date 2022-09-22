// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionModalAdapter extends TypeAdapter<TransactionModal> {
  @override
  final int typeId = 3;

  @override
  TransactionModal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactionModal(
      amount: fields[4] as num,
      id: fields[0] as String,
      categoryModal: fields[1] as CategoryModal,
      date: fields[2] as DateTime,
      type: fields[3] as CategoryType,
    );
  }

  @override
  void write(BinaryWriter writer, TransactionModal obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.categoryModal)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.amount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionModalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
