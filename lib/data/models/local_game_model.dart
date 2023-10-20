import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tm_ressource_tracker/data/models/resource_model.dart';
import 'package:tm_ressource_tracker/data/models/serializable.dart';

part 'local_game_model.freezed.dart';
part 'local_game_model.g.dart';

@freezed
class LocalGameModel with _$LocalGameModel implements Serializable{
  const factory LocalGameModel({
    int? generationNumber,
    ResourcesModel? resources,
  }) = _LocalGameModel;

  factory LocalGameModel.fromJson(Map<String, dynamic> json) =>
      _$LocalGameModelFromJson(json);
}
