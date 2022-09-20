import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tm_ressource_tracker/domain/entities/resource.dart';
import 'package:tm_ressource_tracker/presentation/extension/resource_type_extension.dart';
import 'package:tm_ressource_tracker/presentation/managers/resource_cubit.dart';
import 'package:tm_ressource_tracker/presentation/spacers.dart';
import 'package:tm_ressource_tracker/presentation/widgets/none_widget.dart';

class ResourceMinimalDisplay extends StatelessWidget {
  const ResourceMinimalDisplay({
    Key? key,
    required this.resourceType,
  }) : super(key: key);
  final ResourceType resourceType;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(fontSize: 15);
    return BlocSelector<ResourceCubit, ResourceState, Resource?>(
      selector: (state) => state.whenOrNull<Resource?>(
        loaded: (resources) => resources[resourceType],
      ),
      builder: (context, maybeResource) {
        if (maybeResource == null) {
          return const NoneWidget();
        }
        return maybeResource.map(
          terraformingLevel: (tr) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image(
                  image: resourceType.resourceImage,
                  height: 40,
                ),
                horizontalSmallSpacer,
                Text(tr.stock.toString(), style: style)
              ],
            );
          },
          primaryResource: (resource) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image(
                  image: resourceType.resourceImage, height: 40),
                horizontalSmallSpacer,
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      resource.stock.toString(),
                      style: style,
                    ),
                    Text(
                      resource.production.toString(),
                      style: style.copyWith(color: Colors.brown),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}
