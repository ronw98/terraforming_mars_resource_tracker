import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tm_ressource_tracker/presentation/managers/online_game_cubit.dart';
import 'package:tm_ressource_tracker/presentation/spacers.dart';
import 'package:tm_ressource_tracker/presentation/tabs/current_game/views/online_game_view.dart';
import 'package:tm_ressource_tracker/presentation/tabs/current_game/widgets/no_current_game_widget.dart';
import 'package:tm_ressource_tracker/presentation/tabs/current_game/widgets/online_error_widget.dart';
import 'package:tm_ressource_tracker/presentation/theme/app_theme.dart';

class CurrentGameTab extends StatelessWidget {
  const CurrentGameTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          verticalSpacer,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: OnlineErrorWidget(),
          ),
          BlocBuilder<OnlineGameCubit, OnlineGameState>(
            buildWhen: (previous, next) => next.maybeMap(
              error: (_) => false,
              orElse: () => true,
            ),
            builder: (context, state) {
              return state.maybeMap(
                initial: (_) => NoCurrentGameWidget(),
                loaded: (loaded) {
                  final game = loaded.game;
                  return OnlineGameView(game: game);
                },
                loading: (_) => Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: TMColors.dialogBackgroundColor,
                    ),
                  ),
                ),
                orElse: () => const Center(
                  child: Text('Unknown error, try to restart the app'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
