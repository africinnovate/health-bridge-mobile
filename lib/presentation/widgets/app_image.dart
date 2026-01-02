import 'package:flutter/material.dart';

class AppImage extends StatelessWidget {
  final String path;
  final double width;
  final double height;
  final BoxFit fit;
  final Color? tint;

  const AppImage(
    this.path, {
    super.key,
    this.width = 24,
    this.height = 24,
    this.fit = BoxFit.contain,
    this.tint,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      width: width,
      height: height,
      fit: fit,
      color: tint,
      colorBlendMode: tint != null ? BlendMode.srcIn : null,
    );
  }
}
