part of 'resource_detail_bloc.dart';

abstract class ResourceDetailEvent extends Equatable {
  const ResourceDetailEvent();

  @override
  List<Object?> get props => [];
}

class ProductionChangedEvent extends ResourceDetailEvent {
  const ProductionChangedEvent(this.change);
  final int change;

  @override
  List<Object?> get props => [change];
}

class StockChangedEvent extends ResourceDetailEvent {
  const StockChangedEvent(this.change);
  final int change;

  @override
  List<Object?> get props => [change];
}
