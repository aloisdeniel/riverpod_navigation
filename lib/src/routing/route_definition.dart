import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_navigation/riverpod_navigation.dart';
import 'package:riverpod_navigation/src/parsing/template.dart';
import 'package:riverpod_navigation/src/state.dart';

typedef Page RiverpodPageBuilder(
  BuildContext context,
  NavigationEntry entry,
);

class RouteDefinition extends Equatable {
  RouteDefinition({
    required this.template,
    required this.builder,
    this.next = const <RouteDefinition>[],
  });

  final UriTemplate template;
  final RiverpodPageBuilder builder;
  final List<RouteDefinition> next;

  @override
  List<Object?> get props => [
        template,
        builder,
        next,
      ];

  NavigationStack? evaluate(Uri uri) {
    return _evaluate(null, uri);
  }

  NavigationStack? _evaluate(UriTemplate? parent, Uri uri) {
    var template = this.template;

    if (parent != null) {
      template = parent + template;
    }

    final currentMatch = template.match(uri);
    if (currentMatch is SuccessTemplateMatch) {
      return NavigationStack(
        history: [
          NavigationEntry(
            uri: uri,
            route: this,
            parameters: currentMatch.parameters,
          ),
        ],
      );
    }

    for (var nextRoute in next) {
      final nextResult = nextRoute._evaluate(template, uri);
      if (nextResult != null) {
        return NavigationStack(
          history: [
            NavigationEntry(
              uri: uri,
              route: this,
              parameters: nextResult.history.first.parameters,
            ),
            ...nextResult.history
          ],
        );
      }
    }

    return null;
  }
}
