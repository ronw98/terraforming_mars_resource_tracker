import 'package:flutter/cupertino.dart';
import 'package:tm_ressource_tracker/domain/failures.dart';
import 'package:tm_ressource_tracker/jsons.dart';
import 'package:tm_ressource_tracker/presentation/extension/string_extension.dart';

extension FailureExt on Failure {
  String? translateReason(BuildContext context) {
    return when(
      failure: (r) => r,
      gameLeave: (r) => r,
      gameJoin: (r) {
        switch (r) {
          case GameJoinFailure.unknown:
            return LocaleKeys.game.join_error.translate(context);
          case GameJoinFailure.invalidCode:
            return LocaleKeys.game.invalid_join_code.translate(context);
        }
      },
      watchGame: (r) => r,
      noGame: (r) => r,
      resumeGame: (r) => r,
      createGame: (r) => r,
    );
  }
}
