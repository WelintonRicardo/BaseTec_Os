import 'package:flutter/material.dart';

/// Widget responsável por exibir uma lista horizontal de fotos e um botão para captura.
/// Segue o padrão de componente reutilizável para a Fase 1 do projeto.
class SecaoFotosWidget extends StatelessWidget {
  final String titulo;
  final List<String> fotos; // Lista de URLs vindas do Supabase
  final VoidCallback aoClicarCapturar;
  final bool carregando; // Adicionado para dar feedback durante o upload

  const SecaoFotosWidget({
    super.key,
    required this.titulo,
    required this.fotos,
    required this.aoClicarCapturar,
    this.carregando = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título da seção (Ex: "Fotos Antes")
        Text(
          titulo.toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            letterSpacing: 1.1,
            color: Colors.blueGrey,
          ),
        ),
        const SizedBox(height: 12),
        
        SizedBox(
          height: 110, // Aumentado levemente para não cortar sombras
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            // O tamanho da lista é o total de fotos + o botão de "Adicionar"
            itemCount: fotos.length + 1,
            itemBuilder: (context, index) {
              // Se for o último item da lista, mostra o botão de captura
              if (index == fotos.length) {
                return _BotaoAdicionarFoto(
                  onTap: aoClicarCapturar,
                  estaCarregando: carregando,
                );
              }

              // Se não, mostra a miniatura da foto
              return _ThumbnailFoto(url: fotos[index]);
            },
          ),
        ),
      ],
    );
  }
}

/// Sub-widget para o botão de captura (UI interna)
class _BotaoAdicionarFoto extends StatelessWidget {
  final VoidCallback onTap;
  final bool estaCarregando;

  const _BotaoAdicionarFoto({required this.onTap, required this.estaCarregando});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: estaCarregando ? null : onTap,
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!, width: 2),
        ),
        child: estaCarregando
            ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
            : Icon(Icons.camera_enhance_rounded, color: Colors.blueGrey[400], size: 30),
      ),
    );
  }
}

/// Sub-widget para exibir a imagem com tratamento de erro
class _ThumbnailFoto extends StatelessWidget {
  final String url;

  const _ThumbnailFoto({required this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          url,
          fit: BoxFit.cover,
          // Placeholder enquanto a imagem baixa
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return const Center(child: Icon(Icons.image, color: Colors.grey));
          },
          // Caso o link do Supabase quebre ou o DNS falhe
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Icon(Icons.broken_image, color: Colors.redAccent),
            );
          },
        ),
      ),
    );
  }
}
    