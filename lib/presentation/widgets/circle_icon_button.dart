import 'package:flutter/material.dart';
import 'package:tm_ressource_tracker/jsons.dart';
import 'package:tm_ressource_tracker/presentation/extension/locales_ext.dart';

class ShapeIconButton extends StatelessWidget {
  ShapeIconButton({
    required this.onPressed,
    required this.icon,
    Key? key,
    this.fillColor,
    String? semanticsKey,
    this.padding = const EdgeInsets.all(15),
    this.shape = const CircleBorder(),
  })  : semanticsKey = semanticsKey,
        super(key: key);

  final Function() onPressed;
  final Color? fillColor;
  final Widget icon;
  final EdgeInsetsGeometry padding;
  final String? semanticsKey;
  final ShapeBorder shape;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message:
          semanticsKey ?? LocaleKeys.common.icon_button().translate(context),
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
