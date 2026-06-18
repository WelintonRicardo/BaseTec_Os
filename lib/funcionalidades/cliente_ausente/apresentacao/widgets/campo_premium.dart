import 'package:flutter/material.dart';
import '../../../../../compartilhado/tema_cores.dart';

class CampoPremium extends StatelessWidget {
  final Widget child;

  const CampoPremium({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: AppCores.cardEscuro,

        borderRadius: BorderRadius.circular(18),

        border: Border.all(
          color: Colors.white10,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.25),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: child,
    );
  }
}