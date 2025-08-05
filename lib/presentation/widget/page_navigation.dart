import 'package:flutter/material.dart';

class Screen {
  static Future<dynamic> open(
    BuildContext context,
    Widget target, {
    bool isAnimate = false,
    Offset? begin,
    Curve? curve,
  }) => isAnimate
      ? Navigator.push(
          context,
          _createRoute(
            target,
            begin ?? const Offset(0, 0),
            curve ?? Curves.ease,
          ),
        )
      : Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => target),
        );

  static close(BuildContext context, {dynamic result}) =>
      Navigator.pop(context, result);

  static closeDialog(BuildContext context, {dynamic result}) =>
      Navigator.of(context, rootNavigator: true).pop(result);

  static closePopupOpenPage(
    BuildContext context,
    Widget target, {
    bool isAnimate = true,
    Offset? begin,
    Cubic? curve,
  }) {
    closeDialog(context);
    isAnimate
        ? Navigator.pushReplacement(
            context,
            _createRoute(
              target,
              begin ?? const Offset(0, 0),
              curve ?? Curves.ease,
            ),
          )
        : Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => target),
          );
  }

  ///Current page from stack get removed and the new page is opened
  static openClosingCurrentPage(
    BuildContext context,
    Widget target, {
    bool isAnimate = true,
    Offset? begin,
    Cubic? curve,
  }) => isAnimate
      ? Navigator.pushReplacement(
          context,
          _createRoute(
            target,
            begin ?? const Offset(0, 0),
            curve ?? Curves.ease,
          ),
        )
      : Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => target),
        );

  ///All page under the stack will get removed and the new page is opened
  static openAsNewPage(
    BuildContext context,
    Widget target, {
    bool isAnimate = true,
    Offset? begin,
    Cubic? curve,
  }) => isAnimate
      ? Navigator.pushAndRemoveUntil(
          context,
          _createRoute(
            target,
            begin ?? const Offset(0, 0),
            curve ?? Curves.ease,
          ),
          (route) => false,
        )
      : Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => target),
          (route) => false,
        );

  static Route _createRoute(Widget target, Offset begin, Curve curve) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => target,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        begin = begin;
        const end = Offset.zero;
        curve = curve;
        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }
}
