part of 'resource_bloc.dart';

abstract class ResourceEvent extends Equatable {
  const ResourceEvent();

  @override
  List<Object?> get props => [];
}

class ResourceChanged extends ResourceEvent {
  const ResourceChanged({
    required this.resource,
    this.stock,
    this.production,
    this.history,
  });

  final int? stock;
  final int? production;
  final List<HistoryElement>? history;
  final Resource resource;

  @override
  List<Object?> get props => [stock, production, history, resource];
}

class ResourceReset extends ResourceEvent {
  const ResourceReset({required this.resource, this.stock = 0, this.production = 0});

  final Resource resource;
  final int stock;
  final int production;

  @override
  List<Object?> get props => [stock, production, resource];
}

class StockAdded extends ResourceEvent {
  const StockAdded(this.resource, this.change);
  final Resource resource;
  final int change;

  @override
  List<Object?> get props => [change, resource];
}

class ProductionAdded extends ResourceEvent {
  const ProductionAdded(this.resource, this.change);

  final Resource resource;
  final int change;

  @override
  List<Object?> get props => [change, resource];
}

class ProduceEvent extends ResourceEvent {
  const ProduceEvent({required this.turmoil});

  final bool turmoil;

  @override
  List<Object?> get props => [turmoil];
}

class RestartEvent extends ResourceEvent {}
