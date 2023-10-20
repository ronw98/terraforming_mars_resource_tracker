import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tm_ressource_tracker/domain/entities/resources.dart';

part 'user_resources.freezed.dart';

/// Holds data for the resources of one user.
@freezed
class UserResources with _$UserResources {
  const factory UserResources({
    /// The user's id
    required String userId,

    /// The user's name
    required String userName,

    /// The user's resources with stock and production
    required Resources resources,
  }) = _UserResources;
}
