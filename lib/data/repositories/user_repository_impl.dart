import 'package:appwrite/appwrite.dart';
import 'package:injectable/injectable.dart';
import 'package:tm_ressource_tracker/core/injection.dart';
import 'package:tm_ressource_tracker/core/log.dart';
import 'package:tm_ressource_tracker/data/datasources/remote/user_data_source.dart';
import 'package:tm_ressource_tracker/domain/repositories/user_repository.dart';

@Injectable(as: UserRepository)
class UserRepositoryImpl implements UserRepository {

  UserRepositoryImpl(this.userDataSource);
  final UserDataSource userDataSource;

  @override
  Future<bool> clearUserData() async {
    try {
      // Delete data
      final result = await userDataSource.deleteAllUserData();

      return result;
    } catch (e, s) {
      logger.e(
        '[UserRepositoryImpl] Error clearing user data',
        error: e,
        stackTrace: s,
      );
      return false;
    }
  }

  @override
  Future<bool> isConnected() async {
    try {
      await serviceLocator<Account>().get();
      return true;
    } on AppwriteException catch (_, __) {
      return false;
    }
  }
}
