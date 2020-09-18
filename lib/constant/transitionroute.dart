import 'package:flutter/material.dart';

class TransitionPageRoute extends PageRouteBuilder {
  final Widget widget;

  TransitionPageRoute({this.widget})
      : super(
            transitionDuration: Duration(seconds: 1),
            transitionsBuilder: (BuildContext context, Animation animation,
                Animation secondaryAnimation, Widget child) {
              animation = CurvedAnimation(
                parent: animation,
                curve: Curves.elasticInOut,
              );
              return ScaleTransition(
                scale: animation,
                child: child,
                alignment: Alignment.center,
              );
            },
            // ignore: missing_return
            pageBuilder: (BuildContext context, Animation animation,
                Animation secondaryAnimation) {
              return widget;
            });
}
