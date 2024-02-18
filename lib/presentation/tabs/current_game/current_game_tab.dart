import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tm_ressource_tracker/jsons.dart';
import 'package:tm_ressource_tracker/presentation/extension/locales_ext.dart';
import 'package:tm_ressource_tracker/presentation/managers/online_game_cubit.dart';
import 'package:tm_ressource_tracker/presentation/spacers.dart';
import 'package:tm_ressource_tracker/presentation/tabs/current_game/views/online_game_view.dart';
import 'package:tm_ressource_tracker/presentation/tabs/current_game/widgets/no_current_game_widget.dart';
import 'package:tm_ressource_tracker/presentation/tabs/current_game/widgets/online_error_widget.dart';
import 'package:tm_ressource_tracker/presentation/theme/app_theme.dart';
import 'package:tm_ressource_tracker/presentation/widgets/experimental_button.dart';

class CurrentGameTab extends StatefulWidget {
  const CurrentGameTab({Key? key}) : super(key: key);

  @override
  State<CurrentGameTab> createState() => _CurrentGameTabState();
}

class _CurrentGameTabState extends State<CurrentGameTab>
    with AutomaticKeepAliveClientMixin {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    HapticFeedback.vibrate();
    await BlocProvider.of<OnlineGameCubit>(context).restart();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // TODO: create a connection cubit that handles network status
    return BlocListener<OnlineGameCubit, OnlineGameState>(
      listener: (context, state) {
        state.mapOrNull(
          loaded: (_) {
            _refreshController.refreshCompleted();
          },
        );
      },
      child: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          child: Column(
            children: [
              verticalSpacer,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: OnlineErrorWidget(),
              ),
              const ExperimentalButton(),
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
                    orElse: () => Center(
                      child: Text(
                        LocaleKeys.game.unknown_error().translate(context),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
