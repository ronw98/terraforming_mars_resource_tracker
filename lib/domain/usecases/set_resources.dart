import 'package:injectable/injectable.dart';
import 'package:tm_ressource_tracker/domain/entities/resource.dart';
import 'package:tm_ressource_tracker/domain/repositories/resource_repository.dart';
import 'package:tm_ressource_tracker/domain/repositories/user_repository.dart';
import 'package:tm_ressource_tracker/domain/usecases/upload_resources.dart';

/// Sets resources locally and online
@injectable
class SetResources {
  final ResourceRepository repository;
  final UploadResources uploadResources;
  final UserRepository userRepository;

  SetResources(this.repository, this.uploadResources, this.userRepository);

  Future<bool> call(List<Resource> resources) async {
    final connected = await userRepository.isConnected();
    if(connected) {
      uploadResources.call(
        Map.fromEntries(
          resources.map(
            (r) => MapEntry(r.type, r),
          ),
        ),
      );
    }
    return await repository.setResources(resources);
  }
}
