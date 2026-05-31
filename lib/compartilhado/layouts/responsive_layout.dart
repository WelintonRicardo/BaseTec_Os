// lib/compartilhado/layouts/responsive_layout.dart

import 'package:flutter/material.dart';

/// ResponsiveLayout
/// - Centraliza breakpoints e padrões de layout responsivo.
/// - Fornece três modos principais:
///   * singleColumn: empilha tudo (mobile)
///   * twoColumn: divide em duas colunas com gap (desktop/tablet largo)
///   * centered: centraliza conteúdo com maxWidth (desktop muito largo)
///
/// Como usar:
/// - Passe um builder que recebe o contexto e o tipo de layout (isWide/isCentered)
/// - Ou use os helpers twoColumn/singleColumn para compor rapidamente.
class ResponsiveLayout extends StatelessWidget {
  final Widget Function(BuildContext context, bool isWide, bool isCentered) builder;
  final double wideBreakpoint;
  final double centeredBreakpoint;
  final double maxWidth;
  final EdgeInsetsGeometry padding;

  const ResponsiveLayout({
    Key? key,
    required this.builder,
    this.wideBreakpoint = 800,
    this.centeredBreakpoint = 1200,
    this.maxWidth = 1100,
    this.padding = const EdgeInsets.all(16),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isWide = width >= wideBreakpoint;
    final bool isCentered = width >= centeredBreakpoint;

    Widget child = builder(context, isWide, isCentered);

    // Se for centered, limitamos a largura e centralizamos
    if (isCentered) {
      child = Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: child,
        ),
      );
    }

    return Padding(
      padding: padding,
      child: child,
    );
  }

  /// Helper para construir duas colunas com gap e flex configuráveis
  static Widget twoColumn({
    required Widget left,
    required Widget right,
    double gap = 12,
    int leftFlex = 5,
    int rightFlex = 5,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: leftFlex, child: left),
        SizedBox(width: gap),
        Expanded(flex: rightFlex, child: right),
      ],
    );
  }

  /// Helper para empilhar em coluna (mobile)
  static Widget singleColumn({required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }
}
