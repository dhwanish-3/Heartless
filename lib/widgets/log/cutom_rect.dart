import 'dart:ui';

import 'package:flutter/widgets.dart';

class CustomRectTween extends RectTween {
  /// {@macro custom_rect_tween}
  CustomRectTween({
    required Rect begin,
    required Rect end,
  }) : super(begin: begin, end: end);

  @override
  Rect lerp(double t) {
    final elasticCurveValue = Curves.easeOut.transform(t);
    return Rect.fromLTRB(
      lerpDouble(begin!.left, end!.left, elasticCurveValue) ?? 1.0,
      lerpDouble(begin!.top, end!.top, elasticCurveValue) ?? 1.0,
      lerpDouble(begin!.right, end!.right, elasticCurveValue) ?? 1.0,
      lerpDouble(begin!.bottom, end!.bottom, elasticCurveValue) ?? 1.0,
    );
  }
}
