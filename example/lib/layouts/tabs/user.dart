import 'package:flutter/widgets.dart';

class UserLayout extends StatelessWidget {
  const UserLayout({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('John Doe'),
      ),
    );
  }
}
