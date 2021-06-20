import 'package:flutter/material.dart';
import 'package:riverpod_navigation/riverpod_navigation.dart';

class AllArticlesLayout extends StatelessWidget {
  const AllArticlesLayout({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          ListTile(
            title: Text('Article 1'),
            onTap: () => context.navigation.navigate(Uri.parse('/articles/1')),
          ),
          ListTile(
            title: Text('Article 2'),
            onTap: () => context.navigation.navigate(Uri.parse('/articles/2')),
          ),
        ],
      ),
    );
  }
}
