import 'package:flutter/material.dart';
import 'package:tm_ressource_tracker/presentation/spacers.dart';
import 'package:tm_ressource_tracker/presentation/widgets/notch.dart';

class TMDefaultBottomSheet extends StatelessWidget {
  const TMDefaultBottomSheet({
    required this.child,
    Key? key,
    this.expand = false,
    this.initialChildSize = 0.3,
    this.minChildSize = 0.25,
    this.maxChildSize = 0.75,
    this.bottomChild,
  }) : super(key: key);

  final Widget child;
  final Widget? bottomChild;
  final bool expand;
  final double initialChildSize;
  final double maxChildSize;
  final double minChildSize;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: expand,
      initialChildSize: initialChildSize,
      maxChildSize: maxChildSize,
      minChildSize: minChildSize,
      builder: (context, scrollController) => Padding(
        padding: const EdgeInsets.only(top: bigPadding),
        child: Stack(
          children: [
            const Align(
              alignment: Alignment.topCenter,
              child: Notch(),
            ),
            Positioned.fill(
              child: SingleChildScrollView(
                controller: scrollController,
                physics: const ClampingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: largePadding,
                  ),
                  child: child,
                ),
              ),
            ),
            if (bottomChild != null)
              Positioned(bottom: 0, left: 0, right: 0, child: bottomChild!),
          ],
        ),
      ),
    );
  }
}
