
import 'package:tm_ressource_tracker/core/log.dart';

/// Describes the behavior of an adapter converting a model [M] to an entity [E]
abstract class BaseAdapter<E, M> {
  const BaseAdapter();
  E modelToEntity(M source) {
    throw UnimplementedError('This method is not supported');
  }

  /// Converts an entity to a model
  M entityToModel(E source) {
    throw UnimplementedError('This method is not supported');
  }

  /// Converts a model to an entity and returns null if the conversion failed
  E? tryModelToEntity(M? model) {
    try {
      if (model == null) {
        return null;
      }
      return modelToEntity(model);
    } catch (e, s) {
      logger.e('Error converting model $M to entity $E', error: e, stackTrace: s);
      return null;
    }
  }

  /// Converts a list of models to a list of non nullable entities,
  /// ignoring invalid models
  List<E> modelsToEntities(Iterable<M>? models) {
    return models
        ?.map((model) => tryModelToEntity(model))
        .whereType<E>()
        .toList(growable: true) ??
        [];
  }

  /// Converts a list of models to a list of non nullable entities,
  /// ignoring invalid models
  List<E> enforceModelsToEntities(Iterable<M>? models) {
    return models
        ?.map((model) => modelToEntity(model))
        .whereType<E>()
        .toList(growable: true) ??
        [];
  }

  /// Converts a list of entities to a list of models,
  List<M> entitiesToModels(Iterable<E>? entities) {
    return entities
        ?.map((entity) => entityToModel(entity))
        .whereType<M>()
        .toList(growable: true) ??
        [];
  }
}
