import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_navigation/riverpod_navigation.dart';

class UserLayout extends StatelessWidget {
  const UserLayout({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('John Doe'),
            TextButton(
              onPressed: () => context.navigation
                  .navigate(Uri.parse('/user/update-profile')),
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
