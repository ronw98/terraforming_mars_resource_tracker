import 'dart:convert';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tm_ressource_tracker/entities/resource_entity.dart';

part 'resource_event.dart';

part 'resource_state.dart';

class ResourceBloc extends Bloc<ResourceEvent, ResourceState> {
  ResourceBloc({required this.sharedPrefsKey})
      : super(ResourceState(
            ResourceEntity(history: [], production: 0, stock: 0))) {
    on<ResourceEvent>((event, emit) {
      if (event is ResourceChanged) {
        emit(ResourceState(state.resource.copyWith(
          history: event.history,
          stock: event.stock,
          production: event.production,
        )));
      }
      if (event is ResourceReset) {
        emit(ResourceState(state.resource.copyWith(
          stock: event.stock,
          production: event.production,
          history: [],
        )));
      }
      if (event is StockAdded) {
        emit(ResourceState(state.resource
            .copyWith(stock: state.resource.stock + event.change)));
      }
      if (event is ProduceEvent) {
        emit(
          ResourceState(
            state.resource.copyWith(
              stock: max(
                state.resource.stock + state.resource.production,
                0,
              ),
            ),
          ),
        );
      }
      if (event is ProductionAdded) {
        emit(ResourceState(state.resource
            .copyWith(production: state.resource.production + event.change)));
      }
    });
  }
  @override
  void onChange(Change<ResourceState> change) {
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      prefs.setString(sharedPrefsKey, json.encode(change.nextState.resource.toJson()));
    });
    super.onChange(change);
  }

  final String sharedPrefsKey;
}
