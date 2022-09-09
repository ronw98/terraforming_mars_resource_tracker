import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tm_ressource_tracker/domain/entities/resource.dart';
import 'package:tm_ressource_tracker/jsons.dart';
import 'package:tm_ressource_tracker/presentation/dialogs/confirm_dialog.dart';
import 'package:tm_ressource_tracker/presentation/extension/string_extension.dart';
import 'package:tm_ressource_tracker/presentation/managers/resource_cubit.dart';
import 'package:tm_ressource_tracker/presentation/views/resource_edition_bottom_sheet.dart';
import 'package:tm_ressource_tracker/presentation/widgets/resource_widget.dart';
import 'package:tm_ressource_tracker/presentation/widgets/tm_text_button.dart';

class ResourcesTab extends StatelessWidget {
  const ResourcesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: ResourceWidget(resourceType: ResourceType.terraformingRating),
        ),
        SliverGrid(
          delegate: SliverChildListDelegate(
            ResourceType.values
                .where((type) => type != ResourceType.terraformingRating)
                .map((type) => GestureDetector(
                    onTap: () => _onResourceWidgetTapped(context, type),
                    child: ResourceWidget(resourceType: type)))
                .toList(),
          ),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 175,
            childAspectRatio: 0.9,
          ),
        ),
        SliverToBoxAdapter(
          child: TMTextButton(
            onTap: BlocProvider.of<ResourceCubit>(context).produce,
            child: Text(
              LocaleKeys.resources.produce.translate(context),
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: TMTextButton(
            onTap: () => _onReset(context),
            child: Text(
              LocaleKeys.resources.reset.button_text.translate(context),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        )
      ],
    );
  }

  void _onResourceWidgetTapped(
      BuildContext context, ResourceType resourceType) {
    if (resourceType != ResourceType.terraformingRating) ;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => ResourceEditionBottomSheet(
        resourceType: resourceType,
      ),
    );
  }

  void _onReset(BuildContext context) async {
    final reset = await showDialog(
      context: context,
      builder: (_) => ConfirmDialog(
        text: LocaleKeys.resources.reset.dialog.text.translate(context),
        confirm: LocaleKeys.resources.reset.dialog.reset.translate(context),
        cancel: LocaleKeys.common.cancel.translate(context),
      ),
    );
    if (reset) {
      BlocProvider.of<ResourceCubit>(context).reset();
    }
  }
}
