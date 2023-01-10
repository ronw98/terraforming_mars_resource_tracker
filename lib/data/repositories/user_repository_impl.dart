import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:tm_ressource_tracker/data/datasources/remote/user_data_source.dart';
import 'package:tm_ressource_tracker/domain/repositories/user_repository.dart';

@Injectable(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final UserDataSource userDataSource;

  UserRepositoryImpl(this.userDataSource);

  @override
  Future<bool> clearUserData() async {
    try {
      // Delete data
      final result = await userDataSource.deleteAllUserData();

      return result;
    } catch (e, s) {
      log(
        'Error clearing user data',
        name: 'UserRepositoryImpl',
        error: e,
        stackTrace: s,
      );
      return false;
    }
  }
}
