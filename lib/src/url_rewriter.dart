import 'package:riverpod_navigation/riverpod_navigation.dart';

typedef Uri UriRewriter(NavigationNotifier notifier, Uri uri);

Uri defaultUriRewriter(NavigationNotifier notifier, Uri uri) => uri;
