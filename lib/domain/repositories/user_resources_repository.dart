import 'package:tm_ressource_tracker/domain/entities/resource.dart';
import 'package:tm_ressource_tracker/domain/entities/user_resources.dart';

abstract class UserResourcesRepository {
  /// Returns a stream of [UserResources] lists emitting a new list each time the server changes
  Stream<List<UserResources>> watchGameResources();

  /// Deletes the current user's resources from the server
  ///
  /// Returns true on a success
  Future<bool> deleteUserResources();

  /// Updates the current user's resource on the server
  ///
  /// Returns true on success
  /// [newResources] must be a map containing all values of [ResourceType]
  Future<bool> updateUserResources(Map<ResourceType, Resource> newResources);

  /// Uploads the current user's resource on the server
  ///
  /// Returns true on success
  /// [newResources] must be a map containing all values of [ResourceType]
  Future<bool> createUserResources(
    String teamId,
    Map<ResourceType, Resource> newResources,
  );

  /// Gets whether the user already has resources uploaded on the server or not
  Future<bool> userHasUploadedResources();
}
