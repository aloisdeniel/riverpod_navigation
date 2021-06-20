import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:riverpod_navigation/riverpod_navigation.dart';

Page mockBuilder(
  BuildContext x,
  NavigationEntry y,
  List<Navigator> tabs,
  int activeTab,
) =>
    MaterialPage(
      child: SizedBox(),
    );

void main() {
  test('Next routes are matching uris', () {
    final route = RouteDefinition(
      template: UriTemplate.parse('/'),
      builder: mockBuilder,
      next: [
        RouteDefinition(
          template: UriTemplate.parse('/articles/:id'),
          builder: mockBuilder,
          next: [
            RouteDefinition(
              template: UriTemplate.parse('/share'),
              builder: mockBuilder,
            ),
          ],
        ),
        RouteDefinition(
          template: UriTemplate.parse('/about'),
          builder: mockBuilder,
        ),
      ],
    );

    final uri = Uri.parse('/articles/46/share');
    final result = route.evaluate(null, uri);
    expect(result == null, isFalse);
    expect(result!.history.length, equals(3));
    expect(result.history.last.parameters['id'], equals('46'));
  });

  test('toUris on a stack produces a valid URI', () {
    final route = RouteDefinition(
      template: UriTemplate.parse('/'),
      builder: mockBuilder,
      next: [
        RouteDefinition(
          template: UriTemplate.parse('/articles/:id'),
          builder: mockBuilder,
          next: [
            RouteDefinition(
              template: UriTemplate.parse('/share?email&body'),
              builder: mockBuilder,
            ),
          ],
        ),
        RouteDefinition(
          template: UriTemplate.parse('/about'),
          builder: mockBuilder,
        ),
      ],
    );

    var uri = Uri.parse('/');
    expect(route.evaluate(null, uri)!.toUri(), equals(uri));

    uri = Uri.parse('/about');
    expect(route.evaluate(null, uri)!.toUri(), equals(uri));

    uri = Uri.parse('/articles/46/share');
    expect(route.evaluate(null, uri)!.toUri(), equals(uri));

    uri = Uri.parse('/articles/46/share?email=a');
    expect(route.evaluate(null, uri)!.toUri(), equals(uri));

    uri = Uri.parse('/articles/46/share?email=a&body=b');
    expect(route.evaluate(null, uri)!.toUri(), equals(uri));
  });
}
