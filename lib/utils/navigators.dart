import 'package:afs_test/utils/constants.dart';
import 'package:flutter/material.dart';

Route<T> _createRoute<T>(Widget page,
    {Offset? startOffset, Offset? endOffset, String? routeName}) {
  return PageRouteBuilder<T>(
    settings: RouteSettings(name: routeName),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var tween = Tween(
        begin: startOffset ?? const Offset(1.0, 0.0),
        end: endOffset ?? Offset.zero,
      ).chain(
        CurveTween(curve: Curves.easeIn),
      );
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Future<T?> pushTo<T>(Widget page,
    {String? routeName, Offset? startOffset, Offset? endOffset}) async {
  return await navigatorKey.currentState?.push(_createRoute<T>(page,
      routeName: routeName, startOffset: startOffset, endOffset: endOffset));
}

Future<T?> pushReplacementTo<T>(Widget page,
    {String? routeName, Offset? startOffset, Offset? endOffset}) async {
  return await navigatorKey.currentState?.pushReplacement(_createRoute<T>(page,
      routeName: routeName, startOffset: startOffset, endOffset: endOffset));
}

void popUntil<T>({required String routeName, String? altRouteName}) {
  navigatorKey.currentState?.popUntil((route) {
    if (route.settings.name == routeName) {
      return true;
    } else if (altRouteName != null && route.settings.name == altRouteName) {
      return true;
    } else {
      return false;
    }
  });
}

Future<T?> pushToAndClearUntil<T>(Widget page,
    {String? routeName,
    RouteSettings? settings,
    Offset? startOffset,
    Offset? endOffset}) async {
  return await navigatorKey.currentState?.pushAndRemoveUntil(
    _createRoute<T>(page,
        routeName: routeName, startOffset: startOffset, endOffset: endOffset),
    (route) => route.settings.name == routeName,
  );
}

bool canPopPage() => navigatorKey.currentState?.canPop() ?? false;

Future<T?> pushToAndClearStack<T>(Widget page,
    {String? routeName, Offset? startOffset, Offset? endOffset}) async {
  return await navigatorKey.currentState?.pushAndRemoveUntil(
    _createRoute<T>(page,
        routeName: routeName, startOffset: startOffset, endOffset: endOffset),
    (route) => false,
  );
}
