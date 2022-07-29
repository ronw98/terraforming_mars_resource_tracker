import 'package:tm_ressource_tracker/domain/entities/cost_resource.dart';
import 'package:tm_ressource_tracker/domain/entities/resource.dart';
import 'package:tm_ressource_tracker/domain/entities/settings.dart';
import 'package:tm_ressource_tracker/domain/entities/special_project.dart';
import 'package:tm_ressource_tracker/domain/entities/special_project_config.dart';

enum DefaultSpecialProjects {
  greenery,
  city,
  ocean,
  powerPlant,
  temperature,
  lobby,
  convertHeat,
  convertPlants;

  const DefaultSpecialProjects();

   SpecialProject get project {
     switch(this) {
       case DefaultSpecialProjects.greenery:
         return SpecialProject(
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
       case DefaultSpecialProjects.city:
         return SpecialProject(
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
       case DefaultSpecialProjects.ocean:
         return SpecialProject(
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
       case DefaultSpecialProjects.powerPlant:
         return SpecialProject(
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
       case DefaultSpecialProjects.temperature:
         return SpecialProject(
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
       case DefaultSpecialProjects.lobby:
         return SpecialProject(
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
       case DefaultSpecialProjects.convertHeat:
         return SpecialProject(
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
       case DefaultSpecialProjects.convertPlants:
         return SpecialProject(
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
     }
   }
}

const Settings defaultSettings = Settings(useTurmoil: false);

final SpecialProjectConfig defaultProjectConfig = SpecialProjectConfig(
  projects: DefaultSpecialProjects.values.map((p) => p.project).toList(),
);
