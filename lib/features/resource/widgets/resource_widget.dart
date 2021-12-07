import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tm_ressource_tracker/constants.dart';
import 'package:tm_ressource_tracker/core/widgets/custom_card.dart';
import 'package:tm_ressource_tracker/entities/resource_entity.dart';
import 'package:tm_ressource_tracker/features/resource/bloc/resource_bloc.dart';
import 'package:tm_ressource_tracker/features/resource_modif/bloc/resource_detail_bloc.dart';

import '../../resource_modif/widgets/detailed_resource_widget.dart';

class ResourceWidget extends StatefulWidget {
  ResourceWidget({
    required this.iconPath,
    required this.entity,
    required this.resource,
    this.stockThreshold = 0,
    this.prodThreshold = 0,
  });

  final Resource resource;
  final String iconPath;
  final ResourceEntity entity;
  final int stockThreshold;
  final int prodThreshold;

  @override
  State<StatefulWidget> createState() => _ResourceWidgetState();
}

class _ResourceWidgetState extends State<ResourceWidget> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () => _showResourceDetails(context, widget.entity),
      child: CustomCard(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                widget.iconPath,
                width: screenWidth / AppConstants.image_big_size_divider,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                '${widget.entity.stock}',
                style: TextStyle(fontSize:  screenWidth / AppConstants.stock_font_size_divider),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                '${widget.entity.production}',
                style: TextStyle(
                  color: Colors.brown,
                  fontSize: screenWidth / AppConstants.production_font_size_divider,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showResourceDetails(BuildContext context, ResourceEntity entity) async {
    final ResourceEntity? newResource = await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        insetPadding: EdgeInsets.all(10),
        titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        content: BlocProvider<ResourceDetailBloc>(
          create: (context) => ResourceDetailBloc(
            resource: widget.entity,
            prodThreshold: widget.prodThreshold,
            stockThreshold: widget.stockThreshold,
          ),
          child: DetailedResourceWidget(
            iconPath: widget.iconPath,
            entity: entity,
          ),
        ),
      ),
    );
    if (newResource == null) {
      return;
    }
    BlocProvider.of<ResourceBloc>(context).add(ResourceChanged(
      resource: widget.resource,
      stock: newResource.stock,
      production: newResource.production,
      history: newResource.history,
    ));
  }
}
