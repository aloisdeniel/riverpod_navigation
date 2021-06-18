import 'package:example/layouts/about.dart';
import 'package:example/layouts/article.dart';
import 'package:example/layouts/home.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_navigation/riverpod_navigation.dart';

import 'layouts/share.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final routes = RouteDefinition(
      template: UriTemplate.parse('/'),
      builder: (context, entry) => MaterialPage(
        child: HomeLayout(),
      ),
      next: [
        RouteDefinition(
          template: UriTemplate.parse('/articles/:id'),
          builder: (context, entry) => MaterialPage(
            child: ArticleLayout(
              id: entry.parameters['id']!,
            ),
          ),
          next: [
            RouteDefinition(
              template: UriTemplate.parse('/share'),
              key: Key('share'),
              builder: (context, entry) => MaterialPage(
                child: ShareLayout(
                  articleId: entry.parameters['id']!,
                ),
              ),
            ),
          ],
        ),
        RouteDefinition(
          template: UriTemplate.parse('/about'),
          builder: (context, entry) => MaterialPage(
            child: AboutLayout(),
          ),
        ),
      ],
    );
    return RiverpodNavigation(
      routes: routes,
      uriRewriter: (notifier, uri) {
        const publicPrefix = 'https://example.com';
        final stringUri = uri.toString();
        if (stringUri.startsWith(publicPrefix)) {
          return Uri.parse(stringUri.substring(publicPrefix.length));
        }
        return uri;
      },
      popBehaviour: (notifier, stack) {
        if (stack.lastRoute?.key == Key('share')) {
          return PopResult.update(Uri.parse('/'));
        }
        return PopResult.auto();
      },
      builder: (context, delegate, parser) => MaterialApp.router(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routerDelegate: delegate,
        routeInformationParser: parser,
      ),
    );
  }
}
