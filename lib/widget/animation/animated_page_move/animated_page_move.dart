import 'package:flutter/material.dart';

class AnimatedPageMove {
  AnimatedPageMove(this.view);

  final Widget view;

  Route fadeIn() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return view;
      },
      transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
      ) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  Route slideRightToLeft() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return view;
      },
      transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
      ) {
        var begin = const Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Route slideLeftToRight() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return view;
      },
      transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
      ) {
        var begin = const Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
