import 'package:flutter/material.dart';
import 'package:tm_ressource_tracker/constants.dart';

class TMAppBar extends StatelessWidget with PreferredSizeWidget {
  const TMAppBar({
    Key? key,
    required this.title,
    this.actions,
  }) : super(key: key);

  final List<Widget>? actions;
  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Text(
        title,
        style: TextStyle(fontSize: 18),
      ),
      actionsIconTheme: IconThemeData(
        color: Colors.white,
        opacity: 0.8,
        size: 28,
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size(
        double.maxFinite,
        AppConstants.appBarHeight,
      );
}
