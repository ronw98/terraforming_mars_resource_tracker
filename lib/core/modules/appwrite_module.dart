import 'package:appwrite/appwrite.dart';
import 'package:injectable/injectable.dart';
import 'package:tm_ressource_tracker/core/injection.dart';

@module
abstract class AppWriteModule {
  Client get client => Client()
      // TODO: Use production url
      .setEndpoint('https://10.31.1.114/v1')
      .setProject('63a19394a9a11f708b98')
      .setSelfSigned(status: true);

  Realtime get realtime => Realtime(serviceLocator());
  Databases get databases => Databases(serviceLocator());
  Account get account => Account(serviceLocator());
  Teams get teams => Teams(serviceLocator());
  Functions get functions => Functions(serviceLocator());
}
