import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:riverpod_navigation/src/notifier.dart';
import 'package:riverpod_navigation/src/routing/route_definition.dart';

import '../state.dart';

class RiverpodRouterDelegate extends RouterDelegate<Uri> with ChangeNotifier {
  RiverpodRouterDelegate({
    required this.notifier,
    required this.routes,
  });

  final NavigationNotifier notifier;
  final RouteDefinition routes;
  RemoveListener? _removeListener;

  @override // From PopNavigatorRouterDelegateMixin.
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void addListener(VoidCallback listener) {
    if (!super.hasListeners) {
      _removeListener = notifier.addListener((state) {
        this.notifyListeners();
      });
    }
    super.addListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    super.removeListener(listener);
    if (!super.hasListeners) {
      _removeListener?.call();
    }
  }

  @override
  Uri? get currentConfiguration => notifier.state.current.toUri();

  @override
  Future<bool> popRoute() {
    return SynchronousFuture(notifier.pop());
  }

  @override
  Future<void> setNewRoutePath(Uri configuration) {
    notifier.navigate(configuration);
    return Future.value();
  }

  List<Page> _buildPages(BuildContext context, NavigationStack stack) {
    return [
      ...stack.history.map(
        (entry) => entry.route.builder(
          context,
          entry,
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return StateNotifierBuilder<NavigationState>(
      stateNotifier: notifier,
      builder: (BuildContext context, NavigationState state, Widget? child) {
        return Navigator(
          key: navigatorKey,
          pages: _buildPages(
            context,
            state.current,
          ),
          onPopPage: (route, result) {
            notifier.pop();
            return false;
          },
        );
      },
    );
  }
}
