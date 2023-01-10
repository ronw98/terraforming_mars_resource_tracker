import 'package:injectable/injectable.dart';
import 'package:tm_ressource_tracker/domain/repositories/user_repository.dart';

@injectable
class DeleteUserData {
  final UserRepository userRepository;

  DeleteUserData(this.userRepository);

  Future<bool> call() async {
    try {
      // Delete data
      return await userRepository.clearUserData();
    } catch (e) {
      return false;
    }
  }
}
