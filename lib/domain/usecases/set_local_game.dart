import 'package:injectable/injectable.dart';
import 'package:tm_ressource_tracker/domain/entities/local_game.dart';
import 'package:tm_ressource_tracker/domain/repositories/resource_repository.dart';
import 'package:tm_ressource_tracker/domain/repositories/user_repository.dart';
import 'package:tm_ressource_tracker/domain/usecases/upload_resources.dart';

/// Sets resources locally and online
@injectable
class SetLocalGame {
  SetLocalGame(this.repository, this.uploadResources, this.userRepository);

  final LocalGameRepository repository;
  final UploadResources uploadResources;
  final UserRepository userRepository;

  Future<bool> call(LocalGame game) async {
    final connected = await userRepository.isConnected();
    if (connected) {
      uploadResources.call(game.resources);
    }
    return await repository.setGame(game);
  }
}
