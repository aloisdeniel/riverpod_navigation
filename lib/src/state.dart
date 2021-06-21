import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_navigation/src/routing/route_definition.dart';

class NavigationState extends Equatable {
  NavigationState({
    required this.current,
    required this.routes,
  }) : assert(
          !routes.template.isDynamic,
          'The root route must be static (no variable path segment)',
        );
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

  NavigationEntry? findEntrywithKey(Key key) {
    for (var child in history) {
      final childEntry = child.findEntrywithKey(key);
      if (childEntry != null) return childEntry;
    }

    return null;
  }

  RouteDefinition? get lastRoute {
    if (history.isEmpty) {
      return null;
    }
    final lastEntry = history.last;
    if (lastEntry.tabs.isNotEmpty) {
      final currentTab = lastEntry.tabs[lastEntry.activeTab];
      return currentTab.lastRoute;
    }

    return lastEntry.route;
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
    this.tabs = const <NavigationStack>[],
    this.activeTab = 0,
  }) : assert(
          (tabs.length == 0 && activeTab == 0) ||
              (activeTab >= 0 && activeTab < tabs.length),
          'activeTab should be in tabs range',
        );
  final Uri uri;
  final RouteDefinition route;
  final Map<String, String> parameters;
  final List<NavigationStack> tabs;
  final int activeTab;

  String parameter(String name) {
    final value = parameters[name];
    if (value == null)
      throw Exception(
        'Parameter $name not found (neither in path segments nor query parameters)',
      );
    return value;
  }

  NavigationEntry copyWith({
    Uri? uri,
    RouteDefinition? route,
    Map<String, String>? parameters,
    List<NavigationStack>? tabs,
    int? activeTab,
  }) =>
      NavigationEntry(
        uri: uri ?? this.uri,
        route: route ?? this.route,
        parameters: parameters ?? this.parameters,
        tabs: tabs ?? this.tabs,
        activeTab: activeTab ?? this.activeTab,
      );

  NavigationEntry? findEntrywithKey(Key key) {
    if (route.key == key) return this;

    for (var tab in tabs) {
      final tabEntry = tab.findEntrywithKey(key);
      if (tabEntry != null) return tabEntry;
    }

    return null;
  }

  @override
  List<Object?> get props => [
        uri,
        route,
        parameters,
        tabs,
        activeTab,
      ];
}
