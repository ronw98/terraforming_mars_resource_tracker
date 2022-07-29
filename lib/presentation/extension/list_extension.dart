extension ListExt<T> on List<T> {
  List<List<T>> partition(int partitionSize) {
    final result = <List<T>>[];
    for (int i = 0; i < length; i++) {
      if (i % partitionSize == 0) {
        result.add([this[i]]);
      } else {
        result.last.add(this[i]);
      }
    }
    return result;
  }
}
