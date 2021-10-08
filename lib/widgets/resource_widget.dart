import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tm_ressource_tracker/bloc/resource_bloc.dart';
import 'package:tm_ressource_tracker/bloc/resource_detail_bloc.dart';
import 'package:tm_ressource_tracker/constants.dart';
import 'package:tm_ressource_tracker/entities/resource_entity.dart';
import 'package:tm_ressource_tracker/widgets/custom_card.dart';

import 'detailed_resource_widget.dart';

class ResourceWidget extends StatefulWidget {
  ResourceWidget({
    required this.iconPath,
    required this.entity,
    this.stockThreshold = 0,
    this.prodThreshold = 0,
  });

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
                width: AppConstants.image_big_size,
                height: AppConstants.image_big_size,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                '${widget.entity.stock}',
                style: TextStyle(fontSize: AppConstants.stock_font_size),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                '${widget.entity.production}',
                style: TextStyle(
                  color: Colors.brown,
                  fontSize: AppConstants.production_font_size,
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
      stock: newResource.stock,
      production: newResource.production,
      history: newResource.history,
    ));
  }
}
