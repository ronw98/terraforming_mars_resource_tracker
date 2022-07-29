import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tm_ressource_tracker/data/models/resource_model.dart';
import 'package:tm_ressource_tracker/data/models/resources_holder.dart';

const String kResources = 'resources';

abstract class ResourceDataSourceLocal {
  List<ResourceModel>? getResources();

  Future<bool> setResources(List<ResourceModel> resources);
}

@Injectable(as: ResourceDataSourceLocal)
class ResourceDataSourceLocalImpl implements ResourceDataSourceLocal {
  final SharedPreferences sharedPreferences;

  const ResourceDataSourceLocalImpl({required this.sharedPreferences});

  @override
  List<ResourceModel>? getResources() {
    final resourcesString = sharedPreferences.getString(kResources);
    if(resourcesString == null) {
      return null;
    }
    return ResourcesHolderModel.fromJson(
      json.decode(resourcesString),
    ).resources;
  }

  @override
  Future<bool> setResources(List<ResourceModel> resources) {
    return sharedPreferences.setString(
      kResources,
      json.encode(
        ResourcesHolderModel(resources: resources).toJson(),
      ),
    );
  }
}
