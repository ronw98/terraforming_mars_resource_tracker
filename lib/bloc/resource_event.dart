part of 'resource_bloc.dart';

abstract class ResourceEvent extends Equatable {
  const ResourceEvent();

  @override
  List<Object?> get props => [];
}

class ResourceChanged extends ResourceEvent {
  const ResourceChanged(this.resource);

  final ResourceEntity resource;

  @override
  List<Object?> get props => [resource];
}

class StockAdded extends ResourceEvent {
  const StockAdded(this.change);
  final int change;
  @override
  List<Object?> get props => [change];
}

class ProductionAdded extends ResourceEvent {
  const ProductionAdded(this.change);
  final int change;
  @override
  List<Object?> get props => [change];
}

class ProduceEvent extends ResourceEvent {}