import 'package:riverpod_navigation/riverpod_navigation.dart';

typedef PopResult PopBehaviour(
  NavigationNotifier notifier,
  NavigationStack current,
);

PopResult defaultPopBehaviour(
  NavigationNotifier notifier,
  NavigationStack current,
) {
  return PopResult.auto();
}

abstract class PopResult {
  const PopResult();

  factory PopResult.cancel() => const CancelPopResult._();

  factory PopResult.auto() => const AutoPopResult._();

  const factory PopResult.update(Uri uri) = UpdatePopResult._;
}

/// The default pop behaviour which consists in poping to the parent route upon the current
/// route.
class AutoPopResult extends PopResult {
  const AutoPopResult._();
}

/// Cancels the pop.
class CancelPopResult extends PopResult {
  const CancelPopResult._();
}

/// Override the pop logic by replacing the current stack with [uri] when popped.
class UpdatePopResult extends PopResult {
  const UpdatePopResult._(this.uri);

  final Uri uri;
}
