import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_navigation/riverpod_navigation.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
        ),
      ),
      body: Container(
        child: ListView(
          children: [
            ListTile(
              title: Text('Article 1'),
              onTap: () => context.navigate(Uri.parse('/articles/1')),
            ),
            ListTile(
              title: Text('Article 2'),
              onTap: () => context.navigate(Uri.parse('/articles/2')),
            ),
          ],
        ),
      ),
    );
  }
}
