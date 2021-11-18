import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tm_ressource_tracker/entities/resource_entity.dart';

part 'resource_detail_event.dart';

part 'resource_detail_state.dart';

class ResourceDetailBloc
    extends Bloc<ResourceDetailEvent, ResourceDetailState> {
  int stockThreshold;
  int prodThreshold;

  ResourceDetailBloc({
    required this.stockThreshold,
    required this.prodThreshold,
    required ResourceEntity resource,
  }) : super(ResourceDetailState(
            stock: resource.stock, production: resource.production)) {
    on<ResourceDetailEvent>((event, emit) {
      if (event is ProductionChangedEvent) {
        final int newValue = state.production + event.change;
        if (newValue >= prodThreshold)
          emit(state.copyWith(production: newValue));
        else {
          emit(state.copyWith(production: prodThreshold));
        }
      } else if (event is StockChangedEvent) {
        final int newValue = state.stock + event.change;
        if (newValue >= stockThreshold)
          emit(state.copyWith(stock: newValue));
        else
          emit(state.copyWith(stock: stockThreshold));
      }
    });
  }
}
