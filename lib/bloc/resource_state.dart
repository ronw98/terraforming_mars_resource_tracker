part of 'resource_bloc.dart';

class ResourceState extends Equatable {
  const ResourceState(this.resource);

  final ResourceEntity resource;

  @override
  List<Object?> get props => [resource];
}
