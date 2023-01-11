import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:injectable/injectable.dart';
import 'package:tm_ressource_tracker/core/injection.dart';
import 'package:tm_ressource_tracker/data/adapters/adapter_utils.dart';
import 'package:tm_ressource_tracker/data/adapters/user_resources_adapter.dart';
import 'package:tm_ressource_tracker/data/datasources/remote/user_resources_data_source.dart';
import 'package:tm_ressource_tracker/domain/entities/resource.dart';
import 'package:tm_ressource_tracker/domain/entities/user_resources.dart';
import 'package:tm_ressource_tracker/domain/exceptions.dart';
import 'package:tm_ressource_tracker/domain/repositories/user_resources_repository.dart';

@Injectable(as: UserResourcesRepository)
class UserResourcesRepositoryImpl implements UserResourcesRepository {
  final UserResourcesDataSource dataSource;

  UserResourcesRepositoryImpl(this.dataSource);

  @override
  Future<bool> createUserResources(
      String teamId, Map<ResourceType, Resource> newResources) async {
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
        userResourcesEntityToModel(userResources),
      );
    } catch (e, s) {
      log(
        'Error creating user resources',
        name: 'UserResourcesRepository',
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
      log(
        'Error deleting user resources',
        name: 'UserResourcesRepository',
        stackTrace: s,
        error: e,
      );
      return false;
    }
  }

  @override
  Future<bool> updateUserResources(
      Map<ResourceType, Resource> newResources) async {
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
        userResourcesEntityToModel(userResources),
      );
    } catch (e, s) {
      log(
        'Error updating user resources',
        name: 'UserResourcesRepository',
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
                .map((m) => modelToEntity(m, userResourcesModelToEntity))
                .whereType<UserResources>()
                .toList(),
          );
    } catch (e, s) {
      log(
        'Error watching user resources',
        name: 'UserResourcesRepository',
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
      log(
        'Error checking user resources',
        name: 'UserResourcesRepository',
        stackTrace: s,
        error: e,
      );
      throw UserResourcesRepositoryException(
        'Could not determine if user has uploaded resources',
      );
    }
  }
}