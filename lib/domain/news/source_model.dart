
import 'package:freezed_annotation/freezed_annotation.dart';
part 'source_model.freezed.dart';
part 'source_model.g.dart';

@freezed
abstract class SourceModel with _$SourceModel {
  @JsonSerializable(explicitToJson: true)
  const factory SourceModel({
    @nullable
    String id,
    String name
  }) = _SourceModel;

  factory SourceModel.fromJson(Map<String, dynamic> json) =>
      _$SourceModelFromJson(json);

}