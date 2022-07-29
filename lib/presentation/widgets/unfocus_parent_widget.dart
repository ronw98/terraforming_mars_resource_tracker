import 'package:flutter/material.dart';

class UnfocusParentWidget extends StatelessWidget {
  const UnfocusParentWidget({
    required this.child,
    Key? key,
  }) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        FocusScopeNode currentFocus = FocusScope.of(context);
        // Remove Keyboard only if focus is up on EditableText
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild?.context?.widget != null) {
          currentFocus.focusedChild?.unfocus();
        }
      },
      child: child,
    );
  }
}
