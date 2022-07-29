extension StringExt on String {
  String capitalizeFirst() => replaceRange(0, 1, this[0].toUpperCase());
}