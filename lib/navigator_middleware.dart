import 'package:flutter/material.dart';

class NavigatorMiddleware<R extends Route<dynamic>> extends RouteObserver<R> {
  NavigatorMiddleware(this.onRouteChange);

  final Function(Route<dynamic> route) onRouteChange;

  @override
  void didPush(Route route, Route? previousRoute) {
    // print('{didPush} \n route: $route \n previousRoute: $previousRoute');

    super.didPush(route, previousRoute);
    onRouteChange(route);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    print('{didPop} \n route: $route \n previousRoute: $previousRoute');
    super.didPop(route, previousRoute);
    onRouteChange(previousRoute!);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    print('{didReplace} \n newRoute: $newRoute \n oldRoute: $oldRoute');
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    onRouteChange(newRoute!);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    print('{didRemove} \n route: $route \n previousRoute: $previousRoute');
    super.didRemove(route, previousRoute);
  }

  @override
  void didStartUserGesture(Route route, Route? previousRoute) {
    print(
        '{didStartUserGesture} \n route: $route \n previousRoute: $previousRoute');
    super.didStartUserGesture(route, previousRoute);
  }

  @override
  void didStopUserGesture() {
    print('{didStopUserGesture}');
    super.didStopUserGesture();
  }
}
