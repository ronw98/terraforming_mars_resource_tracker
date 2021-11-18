part of 'resource_detail_bloc.dart';

class ResourceDetailState extends Equatable {
  const ResourceDetailState({required this.stock, required this.production});

  final int production;
  final int stock;

  @override
  List<Object?> get props => [production, stock];

  ResourceDetailState copyWith({int? stock, int? production}) =>
      ResourceDetailState(
        stock: stock ?? this.stock,
        production: production ?? this.production,
      );
}
