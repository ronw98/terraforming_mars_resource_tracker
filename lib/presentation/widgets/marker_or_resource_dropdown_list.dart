import 'package:flutter/material.dart';
import 'package:tm_ressource_tracker/constants.dart';
import 'package:tm_ressource_tracker/domain/entities/cost_resource.dart';
import 'package:tm_ressource_tracker/domain/entities/marker_or_resource.dart';
import 'package:tm_ressource_tracker/domain/entities/resource.dart';
import 'package:tm_ressource_tracker/jsons.dart';
import 'package:tm_ressource_tracker/presentation/extension/marker_type_extension.dart';
import 'package:tm_ressource_tracker/presentation/extension/resource_type_extension.dart';
import 'package:tm_ressource_tracker/presentation/spacers.dart';
import 'package:tm_ressource_tracker/presentation/widgets/custom_card.dart';
import 'package:tm_ressource_tracker/presentation/widgets/production_widget.dart';
import 'package:tm_ressource_tracker/presentation/widgets/switch_widget.dart';

class MarkerOrResourceDropdownList extends StatefulWidget {
  const MarkerOrResourceDropdownList({
    Key? key,
    required this.onItemTap,
  }) : super(key: key);
  final void Function(MarkerOrResource markerOrResource) onItemTap;

  @override
  State<MarkerOrResourceDropdownList> createState() =>
      _MarkerOrResourceDropdownListState();
}

class _MarkerOrResourceDropdownListState
    extends State<MarkerOrResourceDropdownList>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late bool production;

  @override
  void initState() {
    production = false;
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppConstants.defaultDuration,
    );
    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: _scaleAnimation.value,
      child: CustomCard(
        backgroundColor: const Color.fromRGBO(187, 182, 179, 1),
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SwitchWidget(
                  title: LocaleKeys.settings.standard_projects.edit.production,
                  value: production,
                  onChanged: (value) => setState(() {
                    production = value;
                  }),
                ),
                Wrap(
                  spacing: smallPadding,
                  runSpacing: defaultPadding,
                  children: [
                    ...ResourceType.values
                        .where(
                          (type) =>
                              !production ||
                              type != ResourceType.terraformingRating,
                        )
                        .map(
                          (type) => InkWell(
                            onTap: () {
                              widget.onItemTap(
                                MarkerOrResource.resource(
                                  type: type,
                                  production: production,
                                ),
                              );
                              Navigator.pop(context);
                            },
                            child: production
                                ? SizedBox(
                                    height: AppConstants.standardProjectItemSize,
                                    child: ProductionWidget(type: type),
                                  )
                                : Image(
                                    image: type.resourceImage,
                                    height: AppConstants.standardProjectItemSize,
                                  ),
                          ),
                        ),
                    if (!production)
                      ...MarkerType.values.map(
                        (type) => InkWell(
                          onTap: () {
                            widget.onItemTap(
                              MarkerOrResource.marker(type: type),
                            );
                            Navigator.pop(context);
                          },
                          child: Image(
                            image: type.markerImage,
                            height: AppConstants.standardProjectItemSize,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
