import 'package:flutter/material.dart';
import 'package:tm_ressource_tracker/presentation/spacers.dart';
import 'package:tm_ressource_tracker/presentation/widgets/edit_value_button.dart';
import 'package:tm_ressource_tracker/presentation/widgets/text_editable_value.dart';

class EditValueWidget extends StatefulWidget {
  const EditValueWidget({
    Key? key,
    required this.value,
    this.onValueChanged,
    this.textStyle,
    this.editable = false,
  }) : super(key: key);
  final int value;
  final void Function(int change)? onValueChanged;
  final TextStyle? textStyle;
  final bool editable;

  @override
  State<EditValueWidget> createState() => _EditValueWidgetState();
}

class _EditValueWidgetState extends State<EditValueWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  Animation<int>? _animation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant EditValueWidget oldWidget) {
    if (oldWidget.value != widget.value) {
      _animation = IntTween(begin: oldWidget.value, end: widget.value)
          .animate(_animationController);
      _animationController.reset();
      _animationController.forward();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        EditValueButton(
          text: '-10',
          onPressed: () {
            widget.onValueChanged?.call(-10);
          },
        ),
        EditValueButton(
          text: '-5',
          onPressed: () {
            widget.onValueChanged?.call(-5);
          },
        ),
        EditValueButton(
          text: '-1',
          onPressed: () {
            widget.onValueChanged?.call(-1);
          },
        ),
        horizontalSpacer,
        TextEditableValue(
          value: _animation?.value ?? widget.value,
          style: widget.textStyle,
          editable: widget.editable,
        ),
        horizontalSpacer,
        EditValueButton(
          text: '+1',
          onPressed: () {
            widget.onValueChanged?.call(1);
          },
        ),
        EditValueButton(
          text: '+5',
          onPressed: () {
            widget.onValueChanged?.call(5);
          },
        ),
        EditValueButton(
          text: '+10',
          onPressed: () {
            widget.onValueChanged?.call(10);
          },
        ),
      ],
    );
  }
}
