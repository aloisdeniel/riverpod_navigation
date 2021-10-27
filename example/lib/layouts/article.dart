import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_navigation/riverpod_navigation.dart';

class ArticleLayout extends ConsumerWidget {
  const ArticleLayout({
    Key? key,
    required this.id,
  }) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Article $id',
          ),
        ),
      ),
      body: TextButton(
        onPressed: () =>
            ref.navigation.navigate(Uri.parse('/articles/1/share')),
        child: Text('Share'),
      ),
    );
  }
}
