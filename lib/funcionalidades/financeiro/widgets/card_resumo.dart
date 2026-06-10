import 'package:flutter/material.dart';
import '../../../compartilhado/tema_cores.dart';

class CardResumo extends StatefulWidget {
  final String titulo;
  final String valor;
  final Color cor;

  const CardResumo({
    super.key,
    required this.titulo,
    required this.valor,
    required this.cor,
  });

  @override
  State<CardResumo> createState() => _CardResumoState();
}

class _CardResumoState extends State<CardResumo> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHover = true),
      onExit: (_) => setState(() => isHover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              widget.cor.withOpacity(0.22),
              AppCores.cardEscuro,
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: widget.cor.withOpacity(0.25),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.cor.withOpacity(isHover ? 0.35 : 0.18),
              blurRadius: isHover ? 30 : 18,
              spreadRadius: isHover ? 2 : 0,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        transform: Matrix4.identity()
          ..scale(isHover ? 1.02 : 1.0),
        child: Row(
          children: [
            // Ícone
            Container(
              height: 62,
              width: 62,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.cor.withOpacity(0.12),
                border: Border.all(
                  color: widget.cor.withOpacity(0.25),
                ),
              ),
              child: Icon(
                widget.titulo.toLowerCase().contains('receita')
                    ? Icons.trending_up_rounded
                    : Icons.trending_down_rounded,
                color: widget.cor,
                size: 32,
              ),
            ),

            const SizedBox(width: 18),

            // Textos
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.titulo,
                    style: const TextStyle(
                      color: AppCores.textoSecundario,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    widget.valor,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: widget.cor,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: widget.cor.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      'Este mês',
                      style: TextStyle(
                        color: widget.cor.withOpacity(0.9),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}