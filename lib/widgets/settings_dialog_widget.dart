import 'package:flutter/material.dart';
import 'package:tm_ressource_tracker/widgets/custom_card.dart';

class SettingsDialog extends StatefulWidget {
  SettingsDialog({
    required this.onTurmoilChanged,
    required this.onResetTap,
    this.initialValue = false,
  });

  final Function(bool) onTurmoilChanged;
  final Function() onResetTap;
  final bool initialValue;

  @override
  State<StatefulWidget> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  bool _turmoilSelected = false;

  @override
  void initState() {
    _turmoilSelected = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(10),
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      content: CustomCard(
        backgroundColor: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () => setState(() {
                _turmoilSelected = !_turmoilSelected;
                widget.onTurmoilChanged(_turmoilSelected);
              }),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                'Use Turmoil',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 17),
                              ),
                              Transform.scale(
                                scale: 0.75,
                                child: Switch(
                                  activeColor: Colors.black,
                                  value: _turmoilSelected,
                                  onChanged: (_) => setState(() {
                                    _turmoilSelected = !_turmoilSelected;
                                    widget.onTurmoilChanged(_turmoilSelected);
                                  }),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('(-1 '),
                              Image.asset(
                                'assets/images/terraformRating.png',
                                width: 40,
                              ),
                              Text(' each turn)'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                widget.onResetTap();
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Reset",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
