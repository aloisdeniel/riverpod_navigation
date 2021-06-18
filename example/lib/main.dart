import 'package:example/layouts/article.dart';
import 'package:example/layouts/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_navigation/riverpod_navigation.dart';

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
        ),
      ],
    );
    return RiverpodNavigation(
      routes: routes,
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
