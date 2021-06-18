import 'package:flutter_test/flutter_test.dart';

import 'package:riverpod_navigation/riverpod_navigation.dart';

void main() {
  test('Root template is matching a root uri', () {
    final template = UriTemplate.parse('/');
    final uri = Uri.parse('/');
    final match = template.match(uri);
    expect(match.isSuccess, isTrue);
  });

  test('Parsing a valid uri template succeeds', () {
    final template = UriTemplate.parse('/articles/:id/detail?selected&dark');

    expect(template.pathSegments.length, equals(3));
    final firstSegment =
        template.pathSegments.first as StaticPathSegmentTemplate;
    expect(firstSegment.value, equals('articles'));
    final secondSegment =
        template.pathSegments[1] as DynamicPathSegmentTemplate;
    expect(secondSegment.name, equals('id'));
    final thirdSegment = template.pathSegments[2] as StaticPathSegmentTemplate;
    expect(thirdSegment.value, equals('detail'));

    expect(template.queryParameters.length, equals(2));
    expect(template.queryParameters.any((q) => q.name == 'selected'), isTrue);
    expect(template.queryParameters.any((q) => q.name == 'dark'), isTrue);
  });

  test('Matching a corresponding uri succeeds with extracted parameters', () {
    final template = UriTemplate.parse('/articles/:id/detail?selected&dark');

    // 1
    var uri = Uri.parse('/articles/56/detail');
    var match = template.match(uri);

    expect(match.isSuccess, isTrue);
    var success = match as SuccessTemplateMatch;
    expect(success.get('id'), equals('56'));
    expect(success.get('selected'), isNull);
    expect(success.get('dark'), isNull);

    // 2
    uri = Uri.parse('/articles/56/detail?selected=true');
    match = template.match(uri);

    expect(match.isSuccess, isTrue);
    success = match as SuccessTemplateMatch;
    expect(success.get('id'), equals('56'));
    expect(success.get('selected'), equals('true'));
    expect(success.get('dark'), isNull);

    // 3
    uri = Uri.parse('/articles/56/detail?selected=true&dark=false');
    match = template.match(uri);

    expect(match.isSuccess, isTrue);
    success = match as SuccessTemplateMatch;
    expect(success.get('id'), equals('56'));
    expect(success.get('selected'), equals('true'));
    expect(success.get('dark'), equals('false'));
  });

  test('Append a child template also match the uri', () {
    final template = UriTemplate.parse('/articles/:id') +
        UriTemplate.parse('/detail?selected&dark');

    final uri = Uri.parse('/articles/56/detail?selected=true&dark=false');
    final match = template.match(uri);

    expect(match.isSuccess, isTrue);
    final success = match as SuccessTemplateMatch;
    expect(success.get('id'), equals('56'));
    expect(success.get('selected'), equals('true'));
    expect(success.get('dark'), equals('false'));
  });
}
