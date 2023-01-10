import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tm_ressource_tracker/jsons.dart';
import 'package:tm_ressource_tracker/presentation/dialogs/confirm_dialog.dart';
import 'package:tm_ressource_tracker/presentation/extension/standard_project_extension.dart';
import 'package:tm_ressource_tracker/presentation/extension/string_extension.dart';
import 'package:tm_ressource_tracker/presentation/managers/configuration_cubit.dart';
import 'package:tm_ressource_tracker/presentation/pages/settings/delete_user_data_button.dart';
import 'package:tm_ressource_tracker/presentation/spacers.dart';
import 'package:tm_ressource_tracker/presentation/views/tm_default_page.dart';
import 'package:tm_ressource_tracker/presentation/widgets/category_separator_widget.dart';
import 'package:tm_ressource_tracker/presentation/widgets/custom_card.dart';
import 'package:tm_ressource_tracker/presentation/widgets/editable_standard_project_tile.dart';
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
        appBar: TMAppBar(
          title: LocaleKeys.settings.page_title.translate(context),
        ),
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
                          CategorySeparatorWidget(
                            text: LocaleKeys.settings.general_settings
                                .translate(context),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding,
                            ),
                            child: Column(
                              children: [
                                SwitchWidget(
                                  title: LocaleKeys.settings.edit_with_keyboard
                                      .translate(context),
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
                                  child: Text(
                                    LocaleKeys.settings.reset.button_text
                                        .translate(context),
                                  ),
                                  onTap: () => _onResetSettingsTap(context),
                                ),
                              ],
                            ),
                          ),
                          verticalBigSpacer,
                          CategorySeparatorWidget(
                            text: LocaleKeys.settings.extensions
                                .translate(context),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding,
                            ),
                            child: Column(
                              children: [
                                SwitchWidget(
                                  title: LocaleKeys.settings.turmoil.title
                                      .translate(context),
                                  subtitle: LocaleKeys.settings.turmoil.subtitle
                                      .translate(context),
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
                                  title: LocaleKeys.settings.venus.title
                                      .translate(context),
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
                                SwitchWidget(
                                  title: LocaleKeys.settings.colonies.title
                                      .translate(context),
                                  value: config.settings.useColonies,
                                  onChanged: (value) {
                                    BlocProvider.of<ConfigurationCubit>(context)
                                        .updateSettings(
                                      config.settings.copyWith(
                                        useColonies: value,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          CategorySeparatorWidget(
                            text: LocaleKeys.settings.standard_projects.title
                                .translate(context),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: defaultPadding,
                            ),
                            child: Column(
                              children: config
                                  .standardProjectConfig.projects.values
                                  .filterWithSettings(config.settings)
                                  .map(
                                    (project) => EditableStandardProjectTile(
                                      project: project,
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                          verticalBigSpacer,
                          FractionallySizedBox(
                            widthFactor: 1,
                            child: DeleteUserDataButton(),
                          ),
                          verticalSpacer,
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
    final bool? reset = await showDialog(
      context: context,
      builder: (_) => ConfirmDialog(
        text: LocaleKeys.settings.reset.dialog.text.translate(context),
        confirm: LocaleKeys.settings.reset.dialog.confirm.translate(context),
        cancel: LocaleKeys.common.cancel.translate(context),
      ),
    );
    if (reset ?? false) {
      BlocProvider.of<ConfigurationCubit>(context).reset();
    }
  }
}
