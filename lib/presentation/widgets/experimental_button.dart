import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tm_ressource_tracker/jsons.dart';
import 'package:tm_ressource_tracker/presentation/extension/locales_ext.dart';
import 'package:tm_ressource_tracker/presentation/spacers.dart';
import 'package:tm_ressource_tracker/presentation/widgets/custom_card.dart';

class ExperimentalButton extends StatefulWidget {
  const ExperimentalButton({Key? key}) : super(key: key);

  @override
  State<ExperimentalButton> createState() => _ExperimentalButtonState();
}

class _ExperimentalButtonState extends State<ExperimentalButton>
    with SingleTickerProviderStateMixin {
  bool visible = true;
  bool _expanded = false;
  late final AnimationController _animationController;
  Timer? closeTimer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0,
      upperBound: 1,
      value: 0,
    )..addListener(
        () {
          setState(() {});
        },
      );
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
    closeTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: !visible
          ? const SizedBox()
          : CustomCard(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: InkWell(
                  onTap: _expanded
                      ? null
                      : () {
                          _expanded = true;
                          _animationController.forward();
                          setState(() {});
                          closeTimer = Timer(
                            const Duration(seconds: 10),
                            () {
                              _expanded = false;
                              _animationController.reverse();
                            },
                          );
                        },
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info),
                          horizontalSmallSpacer,
                          Text(
                            LocaleKeys.common.experimental().translate(context),
                          ),
                          Spacer(),
                          IconButton(
                            onPressed: () {
                              closeTimer?.cancel();
                              visible = false;
                              setState(() {});
                            },
                            icon: Icon(Icons.close),
                          ),
                        ],
                      ),
                      SizeTransition(
                        sizeFactor: _animationController,
                        axisAlignment: -1,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            LocaleKeys.common
                                .experimental_text()
                                .translate(context),
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
