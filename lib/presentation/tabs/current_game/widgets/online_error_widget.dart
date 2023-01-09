import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tm_ressource_tracker/presentation/managers/online_game_cubit.dart';
import 'package:tm_ressource_tracker/presentation/widgets/none_widget.dart';

class OnlineErrorWidget extends StatefulWidget {
  const OnlineErrorWidget({Key? key}) : super(key: key);

  @override
  State<OnlineErrorWidget> createState() => _OnlineErrorWidgetState();
}

class _OnlineErrorWidgetState extends State<OnlineErrorWidget> {
  Timer? currentTimer;
  String? _displayText;

  void _onTimerEnd() {
    if (mounted) {
      _displayText = null;
      setState(() {});
    }
  }

  @override
  void dispose() {
    currentTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = _displayText;
    return BlocListener<OnlineGameCubit, OnlineGameState>(
      listenWhen: (previous, current) => current.maybeMap(
        error: (_) => true,
        orElse: () => false,
      ),
      listener: (context, state) {
        state.whenOrNull(
          error: (failure) {
            _displayText = failure.reason;
            if (_displayText?.isNotEmpty ?? false) {
              currentTimer = Timer(const Duration(seconds: 3), _onTimerEnd);
              setState(() {});
            }
          },
        );
      },
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: text?.isEmpty ?? true
              ? const NoneWidget()
              : FractionallySizedBox(
                  widthFactor: 1,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.error,
                      ),
                      color: Theme.of(context).colorScheme.errorContainer,
                    ),
                    child: Text(text!),
                  ),
                ),
        ),
      ),
    );
  }
}
