import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:injectable/injectable.dart';
import 'package:tm_ressource_tracker/constants.dart';
import 'package:tm_ressource_tracker/core/injection.dart';

abstract class UserDataSource {
  Future<bool> deleteAllUserData();
}

@Injectable(as: UserDataSource)
class UserDataSourceImpl implements UserDataSource {
  @override
  Future<bool> deleteAllUserData() async {
    final execution = await serviceLocator<Functions>().createExecution(
      functionId: AppConstants.deleteUserDataFnId,
    );
    final statusCode = jsonDecode(execution.responseBody)['status'] as int;
    return statusCode >= 200 &&
        statusCode < 300;
  }
}
