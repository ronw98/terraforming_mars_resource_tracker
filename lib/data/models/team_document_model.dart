import 'package:freezed_annotation/freezed_annotation.dart';

part 'team_document_model.freezed.dart';
part 'team_document_model.g.dart';

@freezed
class TeamDocumentModel with _$TeamDocumentModel {
  const factory TeamDocumentModel({
    required String teamId,
    required String teamCode,
  }) = _TeamDocumentModel;

  factory TeamDocumentModel.fromJson(Map<String, dynamic> json) =>
      _$TeamDocumentModelFromJson(json);
}
