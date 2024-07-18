import 'package:flutter/material.dart';

class CustomTopIndicator extends Decoration {
  const CustomTopIndicator({this.color = Colors.cyan, this.width = 5.0});

  final Color color;
  final double width;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomTopIndicatorBox(color: color, width: width);
  }
}

class _CustomTopIndicatorBox extends BoxPainter {
  _CustomTopIndicatorBox({required this.color, required this.width});
  final Color color;
  final double width;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..isAntiAlias = true;

    canvas.drawLine(offset, Offset(cfg.size!.width + offset.dx, 0), paint);
  }
}