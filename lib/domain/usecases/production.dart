import 'package:injectable/injectable.dart';
import 'package:tm_ressource_tracker/domain/entities/local_game.dart';
import 'package:tm_ressource_tracker/domain/entities/resource.dart';
import 'package:tm_ressource_tracker/domain/repositories/configuration_repository.dart';

@injectable
class ProduceOneResource {
  PrimaryResource call(PrimaryResource resource, [int? additionalStock]) {
    final newStock =
        resource.stock + resource.production + (additionalStock ?? 0);
    return resource.copyWith(
      stock: newStock,
      stockHistory: [
        ...resource.stockHistory,
        if (resource.stock != newStock) newStock,
      ],
    );
  }
}

@injectable
class Produce {
  Produce(this._produceOneResource, this._configurationRepository);

  final ProduceOneResource _produceOneResource;

  final ConfigurationRepository _configurationRepository;

  Future<LocalGame> call(LocalGame game) async {
    final config = await _configurationRepository.getConfig();
    final useTurmoil = config.settings.useTurmoil;
    final resources = game.resources;
    return game.copyWith(
      generationNumber: game.generationNumber + 1,
      resources: resources.copyWith(
        terraformingRating: useTurmoil
            ? TerraformingRating(
                stock: resources.terraformingRating.stock - 1,
                stockHistory: [],
              )
            : resources.terraformingRating,
        credits: _produceOneResource(
          resources.credits,
          resources.terraformingRating.stock,
        ),
        plants: _produceOneResource(resources.plants),
        steel: _produceOneResource(resources.steel),
        titanium: _produceOneResource(resources.titanium),
        energy: _produceOneResource(
          resources.energy,
          resources.energy.stock * -1,
        ),
        heat: _produceOneResource(
          resources.heat,
          resources.energy.stock,
        ),
      ),
    );
  }
}
