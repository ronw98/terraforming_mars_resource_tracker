import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tm_ressource_tracker/constants.dart';
import 'package:tm_ressource_tracker/core/widgets/credit_cost_widget.dart';
import 'package:tm_ressource_tracker/core/widgets/project_widget.dart';
import 'package:tm_ressource_tracker/features/home/bloc/bloc_bindings.dart';
import 'package:tm_ressource_tracker/features/resource/bloc/resource_bloc.dart';

class ProjectList extends StatelessWidget {
  const ProjectList({Key? key, required this.showLobbyProject})
      : super(key: key);

  final bool showLobbyProject;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ProjectWidget(
          name: 'Greenery',
          price: 23,
          resource: Resource.CREDITS,
          onTap: () =>
              BlocProvider.of<CreditsBloc>(context).add(StockAdded(-23)),
          reward: [
            Image.asset(
              'assets/images/greenery.png',
              height: screenWidth / AppConstants.project_resource_divider,
            ),
          ],
        ),
        ProjectWidget(
          name: 'City',
          price: 25,
          resource: Resource.CREDITS,
          onTap: () {
            BlocProvider.of<CreditsBloc>(context).add(ProductionAdded(1));
            BlocProvider.of<CreditsBloc>(context).add(StockAdded(-25));
          },
          reward: [
            Row(
              children: [
                Image.asset(
                  'assets/images/city.png',
                  height: screenWidth /
                      AppConstants
                          .project_resource_divider /*(AppConstants
                                                .image_numbered_resource_size +
                                            10)/1.5*/
                  ,
                ),
                const SizedBox(
                  width: 10,
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset('assets/images/production.png',
                        height: screenWidth /
                            AppConstants.project_resource_prod_divider),
                    CreditCostWidget(
                        value: 1,
                        size: screenWidth /
                            AppConstants.project_resource_divider),
                  ],
                ),
              ],
            ),
          ],
        ),
        ProjectWidget(
          name: 'Aquifer',
          price: 18,
          resource: Resource.CREDITS,
          onTap: () {
            BlocProvider.of<CreditsBloc>(context).add(StockAdded(-18));
          },
          reward: [
            Image.asset('assets/images/ocean.png',
                height: screenWidth / AppConstants.project_resource_divider),
          ],
        ),
        ProjectWidget(
          name: 'Power plant',
          price: 11,
          resource: Resource.CREDITS,
          onTap: () {
            BlocProvider.of<EnergyBloc>(context).add(ProductionAdded(1));
            BlocProvider.of<CreditsBloc>(context).add(StockAdded(-11));
          },
          reward: [
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/images/production.png',
                  height:
                      screenWidth / AppConstants.project_resource_prod_divider,
                ),
                Image.asset(
                  'assets/images/energy.png',
                  height: screenWidth / AppConstants.project_resource_divider,
                ),
              ],
            ),
          ],
        ),
        ProjectWidget(
          name: 'Asteroid',
          price: 14,
          resource: Resource.CREDITS,
          onTap: () {
            BlocProvider.of<CreditsBloc>(context).add(StockAdded(-14));
          },
          reward: [
            Image.asset(
              'assets/images/temperature.png',
              height: screenWidth / AppConstants.project_resource_divider,
            ),
          ],
        ),
        Visibility(
          visible: showLobbyProject,
          child: ProjectWidget(
            name: 'Lobby',
            price: 5,
            resource: Resource.CREDITS,
            reward: [
              Image.asset(
                'assets/images/delegate.png',
                height: screenWidth / AppConstants.project_resource_divider,
              ),
            ],
            onTap: () =>
                BlocProvider.of<CreditsBloc>(context).add(StockAdded(-5)),
          ),
        ),
        ProjectWidget(
          name: 'Heat',
          price: 8,
          resource: Resource.HEAT,
          onTap: () => BlocProvider.of<HeatBloc>(context).add(StockAdded(-8)),
          reward: [
            Image.asset(
              'assets/images/temperature.png',
              height: screenWidth / AppConstants.project_resource_divider,
            ),
          ],
        ),
        ProjectWidget(
          name: 'Plants',
          price: 8,
          resource: Resource.PLANT,
          onTap: () {
            BlocProvider.of<PlantBloc>(context).add(StockAdded(-8));
          },
          reward: [
            Image.asset(
              'assets/images/greenery.png',
              height: screenWidth / AppConstants.project_resource_divider,
            ),
          ],
        ),
      ],
    );
  }
}
