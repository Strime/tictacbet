import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

/// Base failure hierarchy for the app.
@freezed
sealed class AppFailure with _$AppFailure {
  const factory AppFailure.unknown({String? debugInfo}) = UnknownFailure;
}
