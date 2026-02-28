import 'package:freezed_annotation/freezed_annotation.dart';

import 'card_entity.dart';

part 'cell_entity.freezed.dart';

/// Type of bonus hidden in a cell.
enum CellBonus { coin, clover, xp }

/// A single cell on the 3x3 board.
@freezed
sealed class CellEntity with _$CellEntity {
  const factory CellEntity({
    required int row,
    required int col,
    CellBonus? bonus,
    CardEntity? card,
    @Default(false) bool revealed,
  }) = _CellEntity;
}

extension CellEntityX on CellEntity {
  int get index => row * 3 + col;
  bool get isEmpty => card == null;
  bool get isNotEmpty => card != null;
}
