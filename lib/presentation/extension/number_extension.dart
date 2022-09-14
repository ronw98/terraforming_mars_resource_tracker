extension NumExt on num {
  String toSignedString() => this <= 0 ? toString(): '+$this';
}