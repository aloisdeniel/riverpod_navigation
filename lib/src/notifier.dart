import 'package:riverpod_navigation/riverpod_navigation.dart';
import 'package:state_notifier/state_notifier.dart';

import 'state.dart';

class NavigationNotifier extends StateNotifier<NavigationState> {
  NavigationNotifier({
    required NavigationStack initial,
    required RouteDefinition routes,
  }) : super(
          NavigationState(
            current: initial,
            routes: routes,
          ),
        );

  bool get canPop => state.current.history.length > 1;

  bool pop() {
    if (canPop) {
      state = NavigationState(
        routes: state.routes,
        current: NavigationStack(
          history: [
            ...state.current.history.take(state.current.history.length - 1),
          ],
        ),
      );
      return true;
    }

    return false;
  }

  void navigate(Uri uri) {
    final newState = state.routes.evaluate(uri);
    if (newState != null) {
      state = NavigationState(
        routes: state.routes,
        current: newState,
      );
    }
  }
}
