import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_navigation/riverpod_navigation.dart';
import 'package:riverpod_navigation/src/providers.dart';
import 'package:riverpod_navigation/src/routing/pop_behaviour.dart';
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
    this.popBehaviour = defaultPopBehaviour,
    this.uriRewriter = defaultUriRewriter,
  }) : super(key: key);

  final RouteDefinition routes;
  final PopBehaviour popBehaviour;
  final UriRewriter uriRewriter;
  final RiverpodNavigationWidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        routesProvider.overrideWithValue(routes),
        popBehaviourProvider.overrideWithValue(popBehaviour),
        uriRewriterProvider.overrideWithValue(uriRewriter)
      ],
      child: Consumer(
        builder: (context, ref, child) {
          final notifier = ref.watch(navigationProvider.notifier);
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
