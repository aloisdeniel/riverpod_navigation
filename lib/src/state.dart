import 'package:equatable/equatable.dart';
import 'package:riverpod_navigation/src/routing/route_definition.dart';

class NavigationState extends Equatable {
  NavigationState({
    required this.current,
    required this.routes,
  });
  final NavigationStack current;
  final RouteDefinition routes;

  @override
  List<Object?> get props => [
        current,
        routes,
      ];
}

class NavigationStack extends Equatable {
  const NavigationStack({
    required this.history,
  });

  final List<NavigationEntry> history;

  RouteDefinition? get lastRoute {
    if (history.isEmpty) return null;
    return history.last.route;
  }

  @override
  List<Object?> get props => [
        history,
      ];

  Uri toUri() {
    if (history.isEmpty) {
      return Uri.parse('/');
    }
    final uris = [
      ...history.asMap().entries.map(
            (entry) => entry.value.route.template.buildUri(
              entry.value.parameters,
            ),
          ),
    ];

    return Uri(
      path: '/${uris.expand((x) => x.pathSegments).join('/')}',
      queryParameters:
          uris.last.queryParameters.isEmpty ? null : uris.last.queryParameters,
    );
  }
}

class NavigationEntry extends Equatable {
  const NavigationEntry({
    required this.uri,
    required this.route,
    this.parameters = const <String, String>{},
  });
  final Uri uri;
  final RouteDefinition route;
  final Map<String, String> parameters;

  @override
  List<Object?> get props => [
        uri,
        route,
        parameters,
      ];
}
