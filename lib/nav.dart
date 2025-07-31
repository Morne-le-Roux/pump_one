import 'package:flutter/material.dart';

class Nav {
  static Future<void> push(BuildContext context, Widget screen) async {
    await Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 100),
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        settings: RouteSettings(name: screen.runtimeType.toString()),
      ),
    );
  }

  static void pushAndPop(BuildContext context, Widget screen) {
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 100),
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        settings: RouteSettings(name: screen.runtimeType.toString()),
      ),
      (route) => false,
    );
  }

  static void pop(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  static void popUntil(
    BuildContext context,
    Widget screen, {
    bool pushIfNotFound = true,
  }) {
    if (!Navigator.canPop(context)) {
      push(context, screen);
      return;
    }

    bool foundRoute = false;
    Navigator.popUntil(context, (route) {
      // Don't pop the last route (i.e., if this is the first route, stop popping)
      if (route.settings.name == screen.runtimeType.toString()) {
        foundRoute = true;
        return true;
      }
      if (route.isFirst) {
        // Stop at the first route, don't pop it
        return true;
      }
      return false;
    });

    if (!foundRoute && pushIfNotFound) {
      push(context, screen);
    }
  }
}
