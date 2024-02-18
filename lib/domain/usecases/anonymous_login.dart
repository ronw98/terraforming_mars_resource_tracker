import 'package:appwrite/appwrite.dart';
import 'package:injectable/injectable.dart';
import 'package:tm_ressource_tracker/core/injection.dart';

/// A UseCase that initializes the appwrite account
///
/// Tries to get the current logged in account and on a failure logs in
/// anonymously.
@injectable
class AnonymousLogin {
  Future<void> call() async {
    try {
      await serviceLocator<Account>().get();
    } catch (_) {
      await serviceLocator<Account>().createAnonymousSession();
    }
  }
}
