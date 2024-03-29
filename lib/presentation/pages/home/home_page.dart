import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tm_ressource_tracker/jsons.dart';
import 'package:tm_ressource_tracker/presentation/extension/locales_ext.dart';
import 'package:tm_ressource_tracker/presentation/managers/resource_cubit.dart';
import 'package:tm_ressource_tracker/presentation/pages/home/home_content.dart';
import 'package:tm_ressource_tracker/presentation/pages/settings/settings_page.dart';
import 'package:tm_ressource_tracker/presentation/views/tm_default_page.dart';
import 'package:tm_ressource_tracker/presentation/widgets/none_widget.dart';
import 'package:tm_ressource_tracker/presentation/widgets/tm_app_bar.dart';
import 'package:tm_ressource_tracker/presentation/widgets/unfocus_parent_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnfocusParentWidget(
      child: TMDefaultPage(
        pageContent: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: TMAppBar(
            actions: [
              BlocBuilder<LocalGameCubit, LocalGameState>(
                buildWhen: (previous, current) {
                  return current.maybeMap(
                    orElse: () => false,
                    loaded: (_) => true,
                  );
                },
                builder: (context, state) {
                  if (!BlocProvider.of<LocalGameCubit>(context).canUndo) {
                    return const NoneWidget();
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      onPressed: () {
                        HapticFeedback.vibrate();
                        BlocProvider.of<LocalGameCubit>(context).undo();
                      },
                      icon: Icon(Icons.undo),
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => SettingsPage(),
                      ),
                    );
                  },
                  icon: Icon(Icons.settings),
                  tooltip: LocaleKeys.settings.page_title().translate(context),
                ),
              ),
            ],
            title: LocaleKeys.common.app_name().translate(context),
          ),
          body: SafeArea(
            child: HomeContent(),
          ),
        ),
      ),
    );
  }
}
