import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tm_ressource_tracker/core/injection.dart';
import 'package:tm_ressource_tracker/jsons.dart';
import 'package:tm_ressource_tracker/presentation/extension/string_extension.dart';
import 'package:tm_ressource_tracker/presentation/managers/resource_cubit.dart';
import 'package:tm_ressource_tracker/presentation/pages/home/home_content.dart';
import 'package:tm_ressource_tracker/presentation/pages/settings/settings_page.dart';
import 'package:tm_ressource_tracker/presentation/views/tm_default_page.dart';
import 'package:tm_ressource_tracker/presentation/widgets/circle_icon_button.dart';
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
              BlocBuilder<ResourceCubit, ResourceState>(
                buildWhen: (previous, current) => current is ResourcesLoaded,
                builder: (context, state) {
                  if (!sl<ResourceCubit>().canUndo) {
                    return const NoneWidget();
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ShapeIconButton(
                      onPressed: () {
                        sl<ResourceCubit>().undo();
                      },
                      icon: Icon(Icons.replay),
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ShapeIconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => SettingsPage(),
                      ),
                    );
                  },
                  icon: Icon(Icons.settings),
                  semanticsKey:
                      LocaleKeys.settings.page_title.translate(context),
                ),
              ),
            ],
            title: LocaleKeys.common.app_name.translate(context),
          ),
          body: SafeArea(
            child: HomeContent(),
          ),
        ),
      ),
    );
  }
}
