import 'package:flutter/cupertino.dart';

class CircularScannerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    double topSpace = size.height * 0.17; // Adjust top space as needed
    double bottomSpace = size.height * 0.17; // Adjust bottom space as needed

    // Top left corner
    path.moveTo(0, topSpace);
    path.lineTo(0, 0);
    path.lineTo(size.width * 0.17, 0);

    // Top right corner
    path.moveTo(size.width * 0.8, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, topSpace);

    // Bottom right corner
    path.moveTo(size.width, size.height - bottomSpace);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width * 0.8, size.height);

    // Bottom left corner
    path.moveTo(size.width * 0.17, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, size.height - bottomSpace);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
