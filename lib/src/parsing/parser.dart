import 'package:flutter/widgets.dart';

class RiverpodRouteParser extends RouteInformationParser<Uri> {
  @override
  Future<Uri> parseRouteInformation(RouteInformation routeInformation) async {
    return Uri.parse(routeInformation.location ?? '/');
  }

  @override
  RouteInformation restoreRouteInformation(Uri state) {
    return RouteInformation(location: state.toString());
  }
}
