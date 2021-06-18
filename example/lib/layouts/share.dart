import 'package:flutter/material.dart';

class ShareLayout extends StatelessWidget {
  const ShareLayout({
    Key? key,
    required this.articleId,
  }) : super(key: key);

  final String articleId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sharing',
        ),
      ),
      body: Container(
        child: Text('Article $articleId'),
      ),
    );
  }
}
