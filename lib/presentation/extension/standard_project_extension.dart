import 'package:flutter/material.dart';
import 'package:tm_ressource_tracker/data/extra/default_entities.dart';
import 'package:tm_ressource_tracker/domain/entities/settings.dart';
import 'package:tm_ressource_tracker/domain/entities/standard_project.dart';
import 'package:tm_ressource_tracker/presentation/extension/default_standard_projects_ext.dart';
import 'package:tm_ressource_tracker/presentation/extension/locales_ext.dart';
import 'package:tm_ressource_tracker/presentation/extension/string_extension.dart';

extension StandardProjectsExt on Iterable<StandardProject> {
  Iterable<StandardProject> filterWithSettings(Settings settings) => where(
        (project) =>
            settings.useTurmoil ||
            project.defaultType != DefaultStandardProjects.lobby,
      )
          .where(
            (project) =>
                settings.useVenus ||
                project.defaultType != DefaultStandardProjects.airScrapping,
          )
          .where(
            (project) =>
                settings.useColonies ||
                project.defaultType != DefaultStandardProjects.buildColony,
          );
}

extension StandardProjectExt on StandardProject {
  String translatedName(BuildContext context) =>
      defaultType?.translateKey.translate(context) ?? id.capitalizeFirst();
}
