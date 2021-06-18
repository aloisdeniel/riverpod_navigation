# Navigation for Riverpod

Managing Flutter navigation with [riverpod](https://riverpod.dev/).

## Usage

### Bootstrap

Replace your root `ProviderScope` with a `RiverpodNavigation` widget with your routing hierarchy and give the provided `delegate` and `parser` to your `MaterialApp.router` factory.

```dart
  final routes = RouteDefinition(
      template: UriTemplate.parse('/'),
      builder: (context, entry) => MaterialPage(
        child: HomeLayout(),
      ),
      next: [
        RouteDefinition(
          template: UriTemplate.parse('/articles/:id'),
          builder: (context, entry) => MaterialPage(
            child: ArticleLayout(
              id: entry.parameters['id']!,
            ),
          ),
        ),
      ],
    );
    return RiverpodNavigation( // Replaces your root ProviderScope
      routes: routes,
      builder: (context, delegate, parser) => MaterialApp.router(
        title: 'Flutter Demo',
        routerDelegate: delegate,
        routeInformationParser: parser,
      ),
    );
```

### Navigate 

#### From a provider

A `navigationProvider` is exposed and can be used to read the current navigation state.

To access the underlying notifier that allows various actions, use the `navigationProvider.notifier` provider.

```dart
final myProvider = Provider<MyState>((ref) {
        final navigation = ref.watch(navigationProvider.notifier);
        return MyState(
            navigateToArticles: () {
                navigation.navigate(Uri.parse('/articles'))
            },
            pop: () {
                navigation.pop();
            }
        );
    },
);
```

#### From a BuildContext

The notifier can be accessed with the `navigation` extension method from the `BuildContext`.

```dart
@override
Widget build(BuildContext context) {
    return TextButton(
        child: Text('Articles'),
        onPressed: () {
            context.navigation.navigate(Uri.parse('/articles'))
        }
    );
}
```

### Pop behaviour

To customize the behaviour of pops when navigating back, a `PopBehavior` callback can be provided to the `RiverpodNavigation` instance. The result indicates whether the current pop action should be updated, cancelled or auto (*default behavior which simply replace the route with the parent one*).

```dart
 RiverpodNavigation(
    popBehaviour: (notifier, stack) {
        if (stack.lastRoute?.key == Key('share-article')) {
          return PopResult.update(Uri.parse('/'));
        }
        return PopResult.auto();
      },
    // ...
 )
```

### URI rewriting

The uri can be modified before they are processed by the router with the `uriRewriter` property. This can be useful for redirecting or normalizing uris.

```dart
 RiverpodNavigation(
    uriRewriter: (notifier, uri) {
        if (uri == Uri.parse('/home')) {
            return Uri.parse('/');
        }
        const publicPrefix = 'https://example.com';
        final stringUri = uri.toString();
        if (stringUri.startsWith(publicPrefix)) {
            return Uri.parse(stringUri.substring(publicPrefix.length);
        }
        return uri;
    },
    // ...
);