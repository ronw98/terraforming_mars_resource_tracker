import 'package:appwrite/appwrite.dart';
import 'package:injectable/injectable.dart';
import 'package:tm_ressource_tracker/core/injection.dart';
import 'package:tm_ressource_tracker/core/log.dart';
import 'package:tm_ressource_tracker/data/adapters/user_resources_adapter.dart';
import 'package:tm_ressource_tracker/data/datasources/remote/user_resources_data_source.dart';
import 'package:tm_ressource_tracker/domain/entities/resources.dart';
import 'package:tm_ressource_tracker/domain/entities/user_resources.dart';
import 'package:tm_ressource_tracker/domain/exceptions.dart';
import 'package:tm_ressource_tracker/domain/repositories/user_resources_repository.dart';

@Injectable(as: UserResourcesRepository)
class UserResourcesRepositoryImpl implements UserResourcesRepository {
  UserResourcesRepositoryImpl(this.dataSource, this._userResourcesAdapter);

  final UserResourcesDataSource dataSource;
  final UserResourcesAdapter _userResourcesAdapter;

  @override
  Future<bool> createUserResources(
    String teamId,
    Resources newResources,
  ) async {
    try {
      final currentUserAccount = await serviceLocator<Account>().get();
      final userId = currentUserAccount.$id;

      final userResources = UserResources(
        userId: userId,
        userName: currentUserAccount.name,
        resources: newResources,
      );

      return await dataSource.createUserResources(
        userId,
        teamId,
        _userResourcesAdapter.entityToModel(userResources),
      );
    } catch (e, s) {
      logger.e(
        '[UserResourcesRepository] Error creating user resources',
        stackTrace: s,
        error: e,
      );
      return false;
    }
  }

  @override
  Future<bool> deleteUserResources() async {
    try {
      final currentUserAccount = await serviceLocator<Account>().get();
      final userId = currentUserAccount.$id;

      await dataSource.deleteUserResources(userId);
      return true;
    } catch (e, s) {
      logger.e(
        '[UserResourcesRepository] Error deleting user resources',
        stackTrace: s,
        error: e,
      );
      return false;
    }
  }

  @override
  Future<bool> updateUserResources(
    Resources newResources,
  ) async {
    try {
      final currentUserAccount = await serviceLocator<Account>().get();
      final userId = currentUserAccount.$id;

      final userResources = UserResources(
        userId: userId,
        userName: currentUserAccount.name,
        resources: newResources,
      );

      return await dataSource.updateUserResources(
        userId,
        _userResourcesAdapter.entityToModel(userResources),
      );
    } catch (e, s) {
      logger.e(
        '[UserResourcesRepository] Error updating user resources',
        stackTrace: s,
        error: e,
      );
      return false;
    }
  }

  @override
  Stream<List<UserResources>> watchGameResources() async* {
    try {
      final currentUserAccount = await serviceLocator<Account>().get();
      final userId = currentUserAccount.$id;

      yield* dataSource.watchGamesResources(userId).map(
            (resourcesModels) => resourcesModels
                .map((m) => _userResourcesAdapter.modelToEntity(m))
                .whereType<UserResources>()
                .toList(),
          );
    } catch (e, s) {
      logger.e(
        '[UserResourcesRepository] Error watching user resources',
        stackTrace: s,
        error: e,
      );
      throw UserResourcesRepositoryException('Could not watch game resources');
    }
  }

  @override
  Future<bool> userHasUploadedResources() async {
    try {
      final currentUserAccount = await serviceLocator<Account>().get();
      final userId = currentUserAccount.$id;
      return await dataSource.userHasUploadedResources(userId);
    } catch (e, s) {
      logger.e(
        '[UserResourcesRepository] Error checking user resources',
        stackTrace: s,
        error: e,
      );
      throw UserResourcesRepositoryException(
        'Could not determine if user has uploaded resources',
      );
    }
  }
}
