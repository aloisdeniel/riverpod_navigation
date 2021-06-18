import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_navigation/riverpod_navigation.dart';

class ArticleLayout extends StatelessWidget {
  const ArticleLayout({
    Key? key,
    required this.id,
  }) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
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
            context.navigation.navigate(Uri.parse('/articles/1/share')),
        child: Text('Share'),
      ),
    );
  }
}
