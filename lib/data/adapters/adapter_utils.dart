typedef EntityConverter<E, M> = E Function(M);

/// Converts a model to an entity and returns null if the conversion failed
E? modelToEntity<E, M>(M? model, EntityConverter<E, M> converter) {
  try {
    if (model == null) {
      return null;
    }
    return converter(model);
  } catch (e) {
    return null;
  }
}

/// Converts a list of models to a list of non nullable entities,
/// ignoring invalid models
List<E> modelEntityListConverter<E, M>(
    Iterable<dynamic>? models,
    EntityConverter<E, M> converter,
    ) {
  return models
      ?.map((model) => modelToEntity<E, M>(model, converter))
      .whereType<E>()
      .toList(growable: true) ??
      [];
}