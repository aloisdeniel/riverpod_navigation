import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_navigation/riverpod_navigation.dart';
import 'package:riverpod_navigation/src/parsing/template.dart';
import 'package:riverpod_navigation/src/state.dart';

typedef Page RiverpodPageBuilder(
  BuildContext context,
  NavigationEntry entry,
  List<Navigator> tabs,
  int activeTab,
);

class RouteDefinition extends Equatable {
  RouteDefinition({
    this.key,
    required this.template,
    required this.builder,
    this.next = const <RouteDefinition>[],
    this.tabs = const <RouteDefinition>[],
  }) : assert(
          tabs.every((x) => !x.template.isDynamic),
          'All root routes from `tabs` must be static (no variable path segment)',
        );

  final UriTemplate template;
  final Key? key;
  final RiverpodPageBuilder builder;
  final List<RouteDefinition> next;
  final List<RouteDefinition> tabs;

  @override
  List<Object?> get props => [
        key,
        template,
        builder,
        next,
        tabs,
      ];

  NavigationStack? evaluate(NavigationStack? previous, Uri uri) {
    return _evaluate(
      previous,
      null,
      uri,
    );
  }

  List<NavigationStack> _buildDefaultTabs(
    UriTemplate parent,
    Uri uri,
  ) =>
      [
        ...tabs.map(
          (t) => NavigationStack(
            history: [
              NavigationEntry(
                uri: uri,
                route: t,
                tabs: t
                    ._buildTabs(
                      null,
                      parent + t.template,
                      uri,
                    )
                    .toList(),
              ),
            ],
          ),
        )
      ];

  Iterable<NavigationStack> _buildTabs(
    List<NavigationStack>? previous,
    UriTemplate parent,
    Uri uri,
  ) sync* {
    previous = previous ?? _buildDefaultTabs(parent, uri);

    for (var i = 0; i < tabs.length; i++) {
      final tabRoute = tabs[i];
      final previousTabStack = previous[i];
      yield tabRoute._evaluate(
            previousTabStack,
            parent,
            uri,
          ) ??
          previousTabStack;
    }
  }

  NavigationStack? _evaluate(
    NavigationStack? previous,
    UriTemplate? parent,
    Uri uri,
  ) {
    var template = this.template;

    if (parent != null) {
      template = parent + template;
    }

    var activeTab = (previous?.history.isEmpty ?? true
        ? 0
        : previous!.history.first.activeTab);

    final tabs = _buildTabs(
      (previous?.history.isEmpty ?? true ? null : previous!.history.first.tabs),
      template,
      uri,
    ).toList();

    final currentMatch = template.match(uri);
    if (currentMatch is SuccessTemplateMatch) {
      return NavigationStack(
        history: [
          NavigationEntry(
            uri: uri,
            route: this,
            parameters: currentMatch.parameters,
            tabs: tabs,
            activeTab: activeTab,
          ),
        ],
      );
    }

    for (var nextRoute in next) {
      final nextResult = nextRoute._evaluate(
        previous == null
            ? null
            : (previous.history.isEmpty
                ? null
                : NavigationStack(
                    history: [
                      ...previous.history.skip(1),
                    ],
                  )),
        template,
        uri,
      );
      if (nextResult != null) {
        return NavigationStack(
          history: [
            NavigationEntry(
              uri: uri,
              route: this,
              tabs: tabs,
              activeTab: activeTab,
              parameters: nextResult.history.isEmpty
                  ? const <String, String>{}
                  : nextResult.history.first.parameters,
            ),
            ...nextResult.history
          ],
        );
      }
    }

    return null;
  }
}
