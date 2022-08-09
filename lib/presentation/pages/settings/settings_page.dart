import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tm_ressource_tracker/presentation/dialogs/confirm_dialog.dart';
import 'package:tm_ressource_tracker/presentation/extension/special_project_extension.dart';
import 'package:tm_ressource_tracker/presentation/managers/configuration_cubit.dart';
import 'package:tm_ressource_tracker/presentation/spacers.dart';
import 'package:tm_ressource_tracker/presentation/views/TMDefaultPage.dart';
import 'package:tm_ressource_tracker/presentation/widgets/category_separator_widget.dart';
import 'package:tm_ressource_tracker/presentation/widgets/custom_card.dart';
import 'package:tm_ressource_tracker/presentation/widgets/editable_special_project_tile.dart';
import 'package:tm_ressource_tracker/presentation/widgets/none_widget.dart';
import 'package:tm_ressource_tracker/presentation/widgets/switch_widget.dart';
import 'package:tm_ressource_tracker/presentation/widgets/tm_app_bar.dart';
import 'package:tm_ressource_tracker/presentation/widgets/tm_text_button.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TMDefaultPage(
      pageContent: Scaffold(
        appBar: TMAppBar(title: 'Settings'),
        body: SafeArea(
          child: CustomCard(
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: SingleChildScrollView(
                child: BlocBuilder<ConfigurationCubit, ConfigurationState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      loaded: (config) => Column(
                        children: [
                          const CategorySeparatorWidget(text: 'General'),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding,
                            ),
                            child: Column(
                              children: [
                                SwitchWidget(
                                  title: 'Edit values with keyboard',
                                  value: config.settings.editValuesWithText,
                                  onChanged: (value) {
                                    BlocProvider.of<ConfigurationCubit>(context)
                                        .updateSettings(
                                      config.settings.copyWith(
                                        editValuesWithText: value,
                                      ),
                                    );
                                  },
                                ),
                                verticalSpacer,
                                TMTextButton(
                                  child: Text('Reset settings to default'),
                                  onTap: () => _onResetSettingsTap(context),
                                ),
                              ],
                            ),
                          ),
                          verticalBigSpacer,
                          const CategorySeparatorWidget(text: 'Extensions'),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding,
                            ),
                            child: Column(
                              children: [
                                SwitchWidget(
                                  title: 'Use Turmoil',
                                  subtitle: '(-1 TR each turn)',
                                  value: config.settings.useTurmoil,
                                  onChanged: (value) {
                                    BlocProvider.of<ConfigurationCubit>(context)
                                        .updateSettings(
                                      config.settings.copyWith(
                                        useTurmoil: value,
                                      ),
                                    );
                                  },
                                ),
                                verticalSpacer,
                                SwitchWidget(
                                  title: 'Use Venus Next',
                                  value: config.settings.useVenus,
                                  onChanged: (value) {
                                    BlocProvider.of<ConfigurationCubit>(context)
                                        .updateSettings(
                                      config.settings.copyWith(
                                        useVenus: value,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          const CategorySeparatorWidget(
                              text: 'Standard projects'),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: defaultPadding,
                            ),
                            child: Column(
                              children:
                                  config.specialProjectConfig.projects.values
                                      .filterWithSettings(config.settings)
                                      .map(
                                        (project) => EditableSpecialProjectTile(
                                          project: project,
                                        ),
                                      )
                                      .toList(),
                            ),
                          ),
                        ],
                      ),
                      orElse: () => const NoneWidget(),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onResetSettingsTap(BuildContext context) async {
    final reset = await showDialog(
      context: context,
      builder: (_) => ConfirmDialog(
          text: 'Reset settings?\n(Cannot be undone)',
          confirm: 'Reset',
          cancel: 'Cancel'),
    );
    if (reset) {
      BlocProvider.of<ConfigurationCubit>(context).reset();
    }
  }
}
