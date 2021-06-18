import 'package:flutter/material.dart';

class AboutLayout extends StatelessWidget {
  const AboutLayout({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About',
        ),
      ),
      body: Container(
        child: Text('About'),
      ),
    );
  }
}
