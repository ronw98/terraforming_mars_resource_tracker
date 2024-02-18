import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tm_ressource_tracker/constants.dart';
import 'package:tm_ressource_tracker/presentation/managers/resource_cubit.dart';
import 'package:tm_ressource_tracker/presentation/widgets/none_widget.dart';

class TMAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TMAppBar({
    required this.title,
    Key? key,
    this.actions,
  }) : super(key: key);

  final List<Widget>? actions;
  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18),
          ),
          BlocSelector<LocalGameCubit, LocalGameState, int?>(
            selector: (state) {
              return state.whenOrNull(
                loaded: (game) => game.generationNumber,
              );
            },
            builder: (context, genNumber) {
              if (genNumber == null) return const NoneWidget();
              return Text(
                'Gen#$genNumber',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade400,
                    ),
              );
            },
          ),
        ],
      ),
      actionsIconTheme: IconThemeData(
        color: Colors.white,
        opacity: 0.8,
        size: 28,
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size(
        double.maxFinite,
        AppConstants.appBarHeight,
      );
}
