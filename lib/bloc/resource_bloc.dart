import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tm_ressource_tracker/entities/resource_entity.dart';

part 'resource_event.dart';

part 'resource_state.dart';

class ResourceBloc extends Bloc<ResourceEvent, ResourceState> {
  ResourceBloc()
      : super(ResourceState(
            ResourceEntity(history: [], production: 0, stock: 0))) {
    on<ResourceEvent>((event, emit) {
      if (event is ResourceChanged) {
        emit(ResourceState(event.resource));
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
}
