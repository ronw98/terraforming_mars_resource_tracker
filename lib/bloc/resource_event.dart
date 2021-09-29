part of 'resource_bloc.dart';

abstract class ResourceEvent extends Equatable {
  const ResourceEvent();

  @override
  List<Object?> get props => [];
}

class ResourceChanged extends ResourceEvent {
  const ResourceChanged({this.stock, this.production, this.history});

  final int? stock;
  final int? production;
  final List<HistoryElement>? history;

  @override
  List<Object?> get props => [stock, production, history];
}

class ResourceReset extends ResourceEvent {
  const ResourceReset({this.stock=0, this.production=0});

  final int stock;
  final int production;

  @override
  List<Object?> get props => [stock, production];
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