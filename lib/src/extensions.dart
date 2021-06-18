import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_navigation/riverpod_navigation.dart';

extension BuildContextRiverpodNavigationExtensions on BuildContext {
  NavigationNotifier get navigation {
    return read(navigationProvider.notifier);
  }
}
