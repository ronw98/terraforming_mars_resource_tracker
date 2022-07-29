import 'package:flutter/material.dart';

class ShapeIconButton extends StatelessWidget {
  const ShapeIconButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    this.fillColor,
    this.semanticsLabel='Icon button',
    this.padding = const EdgeInsets.all(15),
    this.shape = const CircleBorder(),
  }) : super(key: key);

  final Function() onPressed;
  final Color? fillColor;
  final Widget icon;
  final EdgeInsetsGeometry padding;
  final String? semanticsLabel;
  final ShapeBorder shape;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: semanticsLabel,
      padding: EdgeInsets.all(0),
      child: RawMaterialButton(
        onPressed: onPressed,
        elevation: 2.0,
        fillColor: fillColor,
        child: icon,
        padding: padding,
        shape: shape,
        visualDensity: VisualDensity(horizontal: -4, vertical: -4),
        constraints: BoxConstraints(minHeight: 0, minWidth: 0),
      ),
    );
  }
}
