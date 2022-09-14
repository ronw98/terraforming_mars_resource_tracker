extension NumExt on num {
  String toSignedString() => this <= 0 ? toString() : '+$this';
}

extension NumNullExt<T extends num> on T? {
  T? add(T? other) =>
      (this == null || other == null ? null : this! + other) as T;
}

extension HistoryExt<T> on List<T> {
  List<T> addIfNotNull(T? value) => value == null ? this : [...this, value];
}
