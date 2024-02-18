import 'package:flutter/material.dart';
import 'package:tm_ressource_tracker/presentation/spacers.dart';
import 'package:tm_ressource_tracker/presentation/widgets/custom_card.dart';

class TMTextButton extends StatelessWidget {
  const TMTextButton({
    required this.child,
    required this.onTap,
    Key? key,
  }) : super(key: key);
  final Widget child;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomCard(
        child: Padding(
          padding: const EdgeInsets.all(smallPadding),
          child: Center(
            child: child,
          ),
        ),
      ),
    );
  }
}
