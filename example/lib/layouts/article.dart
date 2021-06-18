import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
        title: Text(
          'Article $id',
        ),
      ),
    );
  }
}
