import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_navigation/riverpod_navigation.dart';

class UserLayout extends ConsumerWidget {
  const UserLayout({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('John Doe'),
            TextButton(
              onPressed: () => ref.navigation
                  .navigate(Uri.parse('/user/update-profile')),
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
