import 'package:riverpod_navigation/riverpod_navigation.dart';
import 'package:state_notifier/state_notifier.dart';

import 'routing/pop_behaviour.dart';
import 'state.dart';

class NavigationNotifier extends StateNotifier<NavigationState> {
  NavigationNotifier({
    required NavigationStack initial,
    required RouteDefinition routes,
    this.popBehaviour = defaultPopBehaviour,
    this.uriRewriter = defaultUriRewriter,
  }) : super(
          NavigationState(
            current: initial,
            routes: routes,
          ),
        );

  final PopBehaviour popBehaviour;
  final UriRewriter uriRewriter;

  bool get canPop {
    final popResult = popBehaviour(this, state.current);
    if (popResult is CancelPopResult) {
      return false;
    }
    if (popResult is UpdatePopResult) {
      return true;
    }
    return state.current.history.length > 1;
  }

  bool pop() {
    if (canPop) {
      final popResult = popBehaviour(this, state.current);
      if (popResult is CancelPopResult) {
        return false;
      } else if (popResult is UpdatePopResult) {
        final effectiveUri = uriRewriter(this, popResult.uri);
        final newState = state.routes.evaluate(popResult.uri);
        state = NavigationState(
          routes: state.routes,
          current: newState!,
        );
      } else {
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
    }

    return false;
  }

  void navigate(Uri uri) {
    final effectiveUri = uriRewriter(this, uri);
    final newState = state.routes.evaluate(effectiveUri);
    if (newState != null) {
      state = NavigationState(
        routes: state.routes,
        current: newState,
      );
    }
  }
}
