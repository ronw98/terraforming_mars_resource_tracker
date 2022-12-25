import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

@module
abstract class UuidModule {
  @preResolve
  Future<Uuid> get uuid => Future.value(const Uuid());
}
