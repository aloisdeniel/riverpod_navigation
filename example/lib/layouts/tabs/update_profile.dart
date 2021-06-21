import 'package:flutter/widgets.dart';

class UpdateProfileLayout extends StatelessWidget {
  const UpdateProfileLayout({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Update profile'),
          ],
        ),
      ),
    );
  }
}
