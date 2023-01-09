import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:tm_ressource_tracker/domain/entities/game_info.dart';
import 'package:tm_ressource_tracker/domain/entities/resource.dart';
import 'package:tm_ressource_tracker/domain/repositories/games_repository.dart';
import 'package:tm_ressource_tracker/domain/repositories/user_resources_repository.dart';

/// Uploads the user's current resources on the server
@injectable
class UploadResources {
  UploadResources(this.gamesRepository, this.userResourcesRepository);

  final GamesRepository gamesRepository;
  final UserResourcesRepository userResourcesRepository;

  Future<bool> call(Map<ResourceType, Resource> resources) async {
    final bool userHasUploadedResources;
    try {
      userHasUploadedResources =
          await userResourcesRepository.userHasUploadedResources();
    } on Exception catch (_) {
      return false;
    }
    // User already has resources
    if (userHasUploadedResources) {
      try {
        return await userResourcesRepository.updateUserResources(resources);
      } on Exception catch (_) {
        return false;
      }
    }

    // User doesn't have resources, get game id
    final GameInfo info;
    try {
      info = await gamesRepository.getCurrentGame();
      return await userResourcesRepository.createUserResources(
        info.id,
        resources,
      );
    } on Exception catch (e, s) {
      log(
        'Error uploading resources',
        name: 'UploadResources',
        error: e,
        stackTrace: s,
      );
      return false;
    }
  }
}
