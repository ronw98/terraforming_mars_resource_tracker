import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    Key? key,
    this.borderColors = const [
      Colors.white,
      Colors.grey,
      Colors.black,
    ],
    double borderWidth = 3,
    this.backgroundColor = const Color.fromARGB(200, 220, 220, 220),
    this.shadowColor,
    this.elevation,
    this.shape,
    this.borderOnForeground = true,
    this.margin,
    this.clipBehavior,
    this.child,
    this.semanticContainer = true,
  })  : assert(elevation == null || elevation >= 0.0),
        _borderWidth = borderWidth / borderColors.length,
        super(key: key);

  final Color? backgroundColor;
  final Color? shadowColor;
  final double? elevation;
  final ShapeBorder? shape;
  final bool borderOnForeground;
  final Clip? clipBehavior;
  final EdgeInsetsGeometry? margin;
  final bool semanticContainer;
  final Widget? child;

  /// The list of colors for the border
  final List<Color> borderColors;
  final double _borderWidth;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      shadowColor: shadowColor,
      elevation: elevation,
      shape: ContinuousRectangleBorder(),
      borderOnForeground: borderOnForeground,
      margin: margin,
      clipBehavior: clipBehavior,
      child: _buildBorder(
        colors: borderColors,
        child: child,
      ),
      semanticContainer: semanticContainer,
    );
  }

  Widget? _buildBorder({required List<Color> colors, Widget? child}) {
    if (colors.isEmpty) {
      return child;
    }
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colors.first, width: _borderWidth),
      ),
      child: _buildBorder(
        colors: colors.sublist(1),
        child: child,
      ),
    );
  }
}
