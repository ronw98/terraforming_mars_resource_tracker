import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:tm_ressource_tracker/core/injection.config.dart';

final serviceLocator = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() => serviceLocator.init();
