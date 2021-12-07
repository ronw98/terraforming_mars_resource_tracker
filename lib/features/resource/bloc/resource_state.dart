part of 'resource_bloc.dart';

class ResourceState extends Equatable {
  const ResourceState({
    required this.credits,
    required this.plant,
    required this.titanium,
    required this.steel,
    required this.energy,
    required this.heat,
    required this.nt,
  });

  final ResourceEntity nt;
  final ResourceEntity credits;
  final ResourceEntity plant;
  final ResourceEntity titanium;
  final ResourceEntity steel;
  final ResourceEntity energy;
  final ResourceEntity heat;

  @override
  List<Object?> get props =>
      [nt, credits, plant, titanium, steel, energy, heat];

  ResourceState.empty()
      : this(
          nt: ResourceEntity().copyWith(stock: 20),
          credits: ResourceEntity(),
          plant: ResourceEntity(),
          titanium: ResourceEntity(),
          energy: ResourceEntity(),
          heat: ResourceEntity(),
          steel: ResourceEntity(),
        );

  ResourceState copyWith({
    ResourceEntity? nt,
    ResourceEntity? credits,
    ResourceEntity? plant,
    ResourceEntity? steel,
    ResourceEntity? titanium,
    ResourceEntity? heat,
    ResourceEntity? energy,
  }) =>
      ResourceState(
        nt: nt ?? this.nt,
        credits: credits ?? this.credits,
        plant: plant ?? this.plant,
        steel: steel ?? this.steel,
        titanium: titanium ?? this.titanium,
        heat: heat ?? this.heat,
        energy: energy ?? this.energy,
      );
}
