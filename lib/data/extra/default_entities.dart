import 'package:tm_ressource_tracker/domain/entities/cost_resource.dart';
import 'package:tm_ressource_tracker/domain/entities/resource.dart';
import 'package:tm_ressource_tracker/domain/entities/settings.dart';
import 'package:tm_ressource_tracker/domain/entities/standard_project.dart';
import 'package:tm_ressource_tracker/domain/entities/standard_project_config.dart';

enum DefaultStandardProjects {
  greenery,
  city,
  ocean,
  powerPlant,
  temperature,
  lobby,
  airScrapping,
  buildColony,
  convertHeat,
  convertPlants;

  const DefaultStandardProjects();

  StandardProject get project => _project.copyWith(defaultType: this);

  StandardProject get _project {
    switch (this) {
      case DefaultStandardProjects.greenery:
        return StandardProject(
          id: name,
          cost: [
            CostResource.stock(
              value: 23,
              type: ResourceType.credit,
            ),
          ],
          reward: [
            CostResource.marker(
              value: 1,
              marker: MarkerType.greenery,
            ),
          ],
        );
      case DefaultStandardProjects.city:
        return StandardProject(
          id: name,
          cost: [
            CostResource.stock(
              value: 25,
              type: ResourceType.credit,
            ),
          ],
          reward: [
            CostResource.marker(
              value: 1,
              marker: MarkerType.city,
            ),
            CostResource.production(
              value: 1,
              type: ResourceType.credit,
            ),
          ],
        );
      case DefaultStandardProjects.ocean:
        return StandardProject(
          id: name,
          cost: [
            CostResource.stock(
              value: 18,
              type: ResourceType.credit,
            ),
          ],
          reward: [
            CostResource.marker(
              value: 1,
              marker: MarkerType.ocean,
            ),
          ],
        );
      case DefaultStandardProjects.powerPlant:
        return StandardProject(
          id: name,
          cost: [
            CostResource.stock(
              value: 11,
              type: ResourceType.credit,
            ),
          ],
          reward: [
            CostResource.production(
              value: 1,
              type: ResourceType.energy,
            ),
          ],
        );
      case DefaultStandardProjects.temperature:
        return StandardProject(
          id: name,
          cost: [
            CostResource.stock(
              value: 14,
              type: ResourceType.credit,
            ),
          ],
          reward: [
            CostResource.marker(
              value: 1,
              marker: MarkerType.temperature,
            ),
          ],
        );
      case DefaultStandardProjects.lobby:
        return StandardProject(
          id: name,
          cost: [
            CostResource.stock(
              value: 5,
              type: ResourceType.credit,
            ),
          ],
          reward: [
            CostResource.marker(
              value: 1,
              marker: MarkerType.delegate,
            ),
          ],
        );
      case DefaultStandardProjects.convertHeat:
        return StandardProject(
          id: name,
          cost: [
            CostResource.stock(
              value: 8,
              type: ResourceType.heat,
            ),
          ],
          reward: [
            CostResource.marker(
              value: 1,
              marker: MarkerType.temperature,
            ),
          ],
        );
      case DefaultStandardProjects.convertPlants:
        return StandardProject(
          id: name,
          cost: [
            CostResource.stock(
              value: 8,
              type: ResourceType.plant,
            ),
          ],
          reward: [
            CostResource.marker(
              value: 1,
              marker: MarkerType.greenery,
            ),
          ],
        );
      case DefaultStandardProjects.airScrapping:
        return StandardProject(
          id: name,
          cost: [
            CostResource.stock(
              value: 15,
              type: ResourceType.credit,
            ),
          ],
          reward: [
            CostResource.marker(
              value: 1,
              marker: MarkerType.venus,
            ),
          ],
        );
      case DefaultStandardProjects.buildColony:
        return StandardProject(
          id: name,
          cost: [
            CostResource.stock(
              value: 17,
              type: ResourceType.credit,
            ),
          ],
          reward: [
            CostResource.marker(
              value: 1,
              marker: MarkerType.colony,
            ),
          ],
        );
    }
  }
}

const Settings defaultSettings = Settings(
  useTurmoil: false,
  editValuesWithText: false,
  stockBelowZero: false,
  useVenus: false,
  useColonies: false,
);

final StandardProjectConfig defaultProjectConfig = StandardProjectConfig(
  projects: Map.fromEntries(
    DefaultStandardProjects.values.map(
      (p) => MapEntry(
        p.project.id,
        p.project,
      ),
    ),
  ),
);
