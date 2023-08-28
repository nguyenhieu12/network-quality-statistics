import 'package:flutter/material.dart';

class ChangePage {
  static PageRouteBuilder changePage(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        const duration = Duration(seconds: 2);

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        var offsetAnimation = tween.animate(
          CurvedAnimation(
            parent: animation,
            curve: Interval(0, 1, curve: curve),
          ),
        );

        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
          child: child,
        );
      },
    );
  }
}