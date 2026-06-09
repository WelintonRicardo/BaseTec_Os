import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    Size size,
    double widthPercent,
    double heightPercent,
    bool isMobile,
    bool isTablet,
    bool isDesktop,
  ) builder;

  const ResponsiveLayout({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    final bool isMobile = size.width < 600;
    final bool isTablet = size.width >= 600 && size.width < 1024;
    final bool isDesktop = size.width >= 1024;

    // porcentagens calculadas automaticamente
    final double widthPercent = size.width / 100;
    final double heightPercent = size.height / 100;

    return builder(context, size, widthPercent, heightPercent, isMobile, isTablet, isDesktop);
  }
}
