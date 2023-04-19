import 'package:flutter/material.dart';

class CustomBookmarkIcon extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool>? onChanged;

  const CustomBookmarkIcon({Key? key, this.initialValue = false, this.onChanged}) : super(key: key);

  @override
  State<CustomBookmarkIcon> createState() => _CustomBookmarkIcon();
}

class _CustomBookmarkIcon extends State<CustomBookmarkIcon> {
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
        });
        if (widget.onChanged != null) {
          widget.onChanged!(_isSelected);
        }
      },
      child: Container(
        width: 24,
        height: 38,
        child: CustomPaint(
          painter: _BookmarkIconPainter(_isSelected),
        ),
      ),
    );
  }
}

class _BookmarkIconPainter extends CustomPainter {
  final bool isSelected;

  _BookmarkIconPainter(this.isSelected);

    @override
  void paint(Canvas canvas, Size size) {
    final borderPaint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final fillPaint = Paint()
      ..color = isSelected ? Colors.orange : Colors.white
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height - 6)
      ..quadraticBezierTo(size.width, size.height, size.width / 2, size.height * 0.7)
      ..quadraticBezierTo(0, size.height, 0, size.height - 6)
      ..close();

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _BookmarkIconPainter oldDelegate) {
    return oldDelegate.isSelected != isSelected;
  }
}