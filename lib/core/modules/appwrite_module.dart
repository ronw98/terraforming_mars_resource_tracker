import 'package:appwrite/appwrite.dart';
import 'package:injectable/injectable.dart';
import 'package:tm_ressource_tracker/constants.dart';
import 'package:tm_ressource_tracker/core/injection.dart';

@module
abstract class AppWriteModule {
  Client get client => Client()
      .setEndpoint('https://terraforming.reblochor.dev/v1')
      .setProject(AppConstants.projectId);

  Realtime get realtime => Realtime(serviceLocator());

  Databases get databases => Databases(serviceLocator());

  Account get account => Account(serviceLocator());

  Teams get teams => Teams(serviceLocator());

  Functions get functions => Functions(serviceLocator());
}
