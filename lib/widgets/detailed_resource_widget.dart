import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tm_ressource_tracker/bloc/resource_detail_bloc.dart';
import 'package:tm_ressource_tracker/constants.dart';
import 'package:tm_ressource_tracker/entities/resource_entity.dart';
import 'package:tm_ressource_tracker/widgets/custom_card.dart';
import 'package:tm_ressource_tracker/widgets/editable_field_big.dart';

class DetailedResourceWidget extends StatelessWidget {
  DetailedResourceWidget({
    required this.iconPath,
    required this.entity,
  });

  final String iconPath;
  final ResourceEntity entity;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResourceDetailBloc, ResourceDetailState>(
      builder: (BuildContext context, ResourceDetailState state) {
        return CustomCard(
          backgroundColor: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                    onPressed: () => Navigator.pop(
                          context,
                          entity,
                        ),
                    icon: Icon(Icons.close)),
              ),
              Image.asset(
                iconPath,
                height: AppConstants.image_big_size,
                width: AppConstants.image_big_size,
              ),
              const SizedBox(
                height: 10,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: Column(
                    children: [
                      EditableFieldBig(
                        onValueChanged: (newValue) =>
                            BlocProvider.of<ResourceDetailBloc>(context)
                                .add(StockChangedEvent(newValue)),
                        value: state.stock,
                        valueTextStyle: TextStyle(
                          fontSize: AppConstants.stock_font_size,
                        ),
                      ),
                      EditableFieldBig(
                        onValueChanged: (newValue) =>
                            BlocProvider.of<ResourceDetailBloc>(context)
                                .add(ProductionChangedEvent(newValue)),
                        value: state.production,
                        valueTextStyle: TextStyle(
                          color: Colors.brown,
                          fontSize: AppConstants.production_font_size,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                reverse: true,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    for (HistoryElement element in entity.history)
                      element.modificationType ==
                              HistoryElementType.HISTORY_PROD
                          ? _buildProdHistoryElement(element.value)
                          : _buildStockHistoryElement(element.value),
                  ],
                ),
              ),
              IconButton(
                iconSize: 40,
                onPressed: () => Navigator.pop(
                  context,
                  entity.copyWith(
                    stock: state.stock,
                    production: state.production,
                    history: _buildHistory(
                      entity,
                      state.stock,
                      state.production,
                    ),
                  ),
                ),
                icon: Icon(
                  Icons.check_box_sharp,
                  color: Colors.black,
                ),
              )
            ],
          ),
        );
      },
    );
  }

  List<HistoryElement> _buildHistory(
    ResourceEntity entity,
    int stock,
    int prod,
  ) {
    if (entity.stock != stock) {
      entity.history.add(HistoryElement(
        modificationType: HistoryElementType.HISTORY_STOCK,
        value: stock - entity.stock,
      ));
    }
    if (entity.production != prod) {
      entity.history.add(HistoryElement(
        modificationType: HistoryElementType.HISTORY_PROD,
        value: prod - entity.production,
      ));
    }
    return entity.history;
  }

  Widget _buildProdHistoryElement(int value) {
    return CustomCard(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(1),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/production.png',
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: Text('$value'),
      ),
    );
  }

  Widget _buildStockHistoryElement(int value) {
    return CustomCard(
      backgroundColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: Text('$value'),
      ),
    );
  }
}
