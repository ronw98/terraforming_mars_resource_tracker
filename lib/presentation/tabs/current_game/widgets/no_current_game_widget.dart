import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tm_ressource_tracker/jsons.dart';
import 'package:tm_ressource_tracker/presentation/extension/string_extension.dart';
import 'package:tm_ressource_tracker/presentation/managers/online_game_cubit.dart';
import 'package:tm_ressource_tracker/presentation/managers/resource_cubit.dart';
import 'package:tm_ressource_tracker/presentation/spacers.dart';
import 'package:tm_ressource_tracker/presentation/tabs/current_game/widgets/create_game_dialog.dart';
import 'package:tm_ressource_tracker/presentation/tabs/current_game/widgets/join_game_dialog.dart';
import 'package:tm_ressource_tracker/presentation/widgets/custom_card.dart';

class NoCurrentGameWidget extends StatelessWidget {
  const NoCurrentGameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      constrainedAxis: Axis.horizontal,
      alignment: Alignment.topCenter,
      child: CustomCard(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                LocaleKeys.game.no_game.translate(context),
              ),
              verticalSpacer,
              ElevatedButton.icon(
                onPressed: () => _joinGame(context),
                icon: Icon(Icons.group_add_outlined),
                label: Text(
                  LocaleKeys.game.no_game.translate(context),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _createGame(context),
                icon: Icon(Icons.extension_outlined),
                label: Text(
                  LocaleKeys.game.no_game.translate(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _joinGame(BuildContext context) async {
    final cubit = BlocProvider.of<OnlineGameCubit>(context);
    final resourceCubit = BlocProvider.of<ResourceCubit>(context);

    final info = await showDialog<JoinInfo>(
      context: context,
      builder: (_) => JoinGameDialog(),
    );
    if (info == null) return;

    final resources = resourceCubit.isClosed
        ? null
        : resourceCubit.state.mapOrNull(loaded: (loaded) => loaded.resources);

    cubit.joinGame(info.userName, info.inviteCode, resources);
  }

  void _createGame(BuildContext context) async {
    final cubit = BlocProvider.of<OnlineGameCubit>(context);
    final resourceCubit = BlocProvider.of<ResourceCubit>(context);

    final userName = await showDialog<String>(
      context: context,
      builder: (_) => CreateGameDialog(),
    );

    if (userName == null) {
      return;
    }

    final resources = resourceCubit.isClosed
        ? null
        : resourceCubit.state.mapOrNull(loaded: (loaded) => loaded.resources);
    cubit.createGame(userName, resources);
  }
}
