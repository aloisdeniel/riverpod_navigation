import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_navigation/src/routing/route_definition.dart';

import 'notifier.dart';
import 'state.dart';

final routesProvider = Provider<RouteDefinition>((ref) {
  throw Exception('Provider should be overriden');
});

final navigationProvider =
    StateNotifierProvider<NavigationNotifier, NavigationState>(
  (ref) {
    final routes = ref.watch(routesProvider);
    final initialUrl = Uri.parse('/');

    final entry = routes.evaluate(initialUrl);
    if (entry == null) {
      throw Exception('No route found for initial route "/"');
    }
    return NavigationNotifier(
      initial: entry,
      routes: routes,
    );
  },
);
