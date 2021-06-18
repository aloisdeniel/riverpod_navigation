import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_navigation/src/providers.dart';
import 'package:riverpod_navigation/src/routing/route_definition.dart';
import 'package:riverpod_navigation/src/routing/router_delegate.dart';

import '../parsing/parser.dart';

typedef Widget RiverpodNavigationWidgetBuilder(
  BuildContext context,
  RiverpodRouterDelegate delegate,
  RiverpodRouteParser parser,
);

class RiverpodNavigation extends StatelessWidget {
  const RiverpodNavigation({
    Key? key,
    required this.builder,
    required this.routes,
  }) : super(key: key);

  final RouteDefinition routes;
  final RiverpodNavigationWidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        routesProvider.overrideWithValue(routes),
      ],
      child: Consumer(
        builder: (context, watch, child) {
          final notifier = watch(navigationProvider.notifier);
          return builder(
            context,
            RiverpodRouterDelegate(
              notifier: notifier,
              routes: routes,
            ),
            RiverpodRouteParser(),
          );
        },
      ),
    );
  }
}
