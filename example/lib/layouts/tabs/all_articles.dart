import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_navigation/riverpod_navigation.dart';

class AllArticlesLayout extends ConsumerWidget {
  const AllArticlesLayout({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      child: ListView(
        children: [
          ListTile(
            title: Text('Article 1'),
            onTap: () => ref.navigation.navigate(Uri.parse('/articles/1')),
          ),
          ListTile(
            title: Text('Article 2'),
            onTap: () => ref.navigation.navigate(Uri.parse('/articles/2')),
          ),
        ],
      ),
    );
  }
}
