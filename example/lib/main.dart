import 'package:example/layouts/about.dart';
import 'package:example/layouts/article.dart';
import 'package:example/layouts/home.dart';
import 'package:example/layouts/tabs/all_articles.dart';
import 'package:example/layouts/tabs/shop.dart';
import 'package:example/layouts/tabs/user.dart';
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
      key: Key('Home'),
      template: UriTemplate.parse('/'),
      builder: (context, entry, tabs, activeTab) => MaterialPage(
        child: HomeLayout(
          activeTab: activeTab,
          tabs: tabs,
        ),
      ),
      tabs: [
        RouteDefinition(
          template: UriTemplate.parse('/all-articles'),
          builder: (context, entry, tabs, activeTab) => MaterialPage(
            child: AllArticlesLayout(),
          ),
        ),
        RouteDefinition(
          template: UriTemplate.parse('/shop'),
          builder: (context, entry, tabs, activeTab) => MaterialPage(
            child: ShopLayout(),
          ),
        ),
        RouteDefinition(
          template: UriTemplate.parse('/user'),
          builder: (context, entry, tabs, activeTab) => MaterialPage(
            child: UserLayout(),
          ),
        ),
      ],
      next: [
        RouteDefinition(
          template: UriTemplate.parse('/articles/:id'),
          builder: (context, entry, tabs, activeTab) => MaterialPage(
            child: ArticleLayout(
              id: entry.parameter('id'),
            ),
          ),
          next: [
            RouteDefinition(
              template: UriTemplate.parse('/share'),
              key: Key('share'),
              builder: (context, entry, tabs, activeTab) => MaterialPage(
                child: ShareLayout(
                  articleId: entry.parameter('id'),
                ),
              ),
            ),
          ],
        ),
        RouteDefinition(
          template: UriTemplate.parse('/about'),
          builder: (context, entry, tabs, activeTab) => MaterialPage(
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
