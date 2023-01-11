import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tm_ressource_tracker/domain/entities/game.dart';
import 'package:tm_ressource_tracker/presentation/managers/online_game_cubit.dart';
import 'package:tm_ressource_tracker/presentation/spacers.dart';
import 'package:tm_ressource_tracker/presentation/tabs/current_game/widgets/user_resources_widget.dart';
import 'package:tm_ressource_tracker/presentation/widgets/custom_card.dart';

class OnlineGameView extends StatelessWidget {
  const OnlineGameView({
    Key? key,
    required this.game,
  }) : super(key: key);

  final Game game;

  @override
  Widget build(BuildContext context) {
    final code = game.info.mapOrNull(created: (g) => g.code);

    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (code != null)
              InkWell(
                onTap: () => Clipboard.setData(
                  ClipboardData(
                    text: code.toUpperCase(),
                  ),
                ),
                child: CustomCard(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Code: ' + code.toUpperCase()),
                        Icon(Icons.copy),
                      ],
                    ),
                  ),
                ),
              ),
            if (game.resources.isNotEmpty) ...[
              verticalSpacer,
              ...game.resources.map(
                (r) => FractionallySizedBox(
                  widthFactor: 1,
                  child: UserResourcesWidget(userResources: r),
                ),
              ),
            ],
            verticalBigSpacer,
            ElevatedButton(
              onPressed: () =>
                  BlocProvider.of<OnlineGameCubit>(context).leaveGame(),
              child: Text('Leave game'),
            ),
          ],
        ),
      ),
    );
  }
}