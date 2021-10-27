import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_navigation/riverpod_navigation.dart';

extension BuildContextRiverpodNavigationExtensions on WidgetRef {
  NavigationNotifier get navigation {
    return read(navigationProvider.notifier);
  }
}
