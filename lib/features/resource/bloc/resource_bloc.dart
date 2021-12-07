import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tm_ressource_tracker/constants.dart';
import 'package:tm_ressource_tracker/entities/resource_entity.dart';

part 'resource_event.dart';

part 'resource_state.dart';

class ResourceBloc extends Bloc<ResourceEvent, ResourceState> {
  ResourceBloc() : super(ResourceState.empty()) {
    on<RestartEvent>((event, emit) {
      final ResourceState newState =
          ResourceState.empty().editResource(resource: Resource.NT, stock: 20);
      emit(newState);
    });
    on<ResourceEvent>((event, emit) {
      if (event is ResourceChanged) {
        emit(state.editResource(
          resource: event.resource,
          stock: event.stock,
          prod: event.production,
          history: event.history,
        ));
      }
      if (event is ResourceReset) {
        emit(state.editResource(
          resource: event.resource,
          stock: event.stock,
          prod: event.production,
          history: [],
        ));
      }
      if (event is StockAdded) {
        emit(state.editResource(
          resource: event.resource,
          stock: state.resources[event.resource]!.stock + event.change,
        ));
      }
      if (event is ProduceEvent) {
        final ResourceState newState = state.copyWith(
          resources: state.resources.map(
            (Resource r, ResourceEntity e) => MapEntry(r, e.produce()),
          ),
        );
        if (event.turmoil) {
          newState.resources[Resource.NT] =
              newState.resources[Resource.NT]!.addStock(-1);
        }
        emit(newState);
      }
      if (event is ProductionAdded) {
        emit(state.editResource(
          resource: event.resource,
          prod: state.resources[event.resource]!.production + event.change,
        ));
      }
    });
  }

  @override
  void onChange(Change<ResourceState> change) {
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      prefs.setString(
        AppConstants.prefs_nt,
        json.encode(change.nextState.nt.toJson()),
      );
      prefs.setString(
        AppConstants.prefs_credit,
        json.encode(change.nextState.credits.toJson()),
      );
      prefs.setString(
        AppConstants.prefs_plant,
        json.encode(change.nextState.plant.toJson()),
      );
      prefs.setString(
        AppConstants.prefs_steel,
        json.encode(change.nextState.steel.toJson()),
      );
      prefs.setString(
        AppConstants.prefs_titanium,
        json.encode(change.nextState.titanium.toJson()),
      );
      prefs.setString(
        AppConstants.prefs_energy,
        json.encode(change.nextState.energy.toJson()),
      );
      prefs.setString(
        AppConstants.prefs_heat,
        json.encode(change.nextState.heat.toJson()),
      );
    });
    super.onChange(change);
  }
}
