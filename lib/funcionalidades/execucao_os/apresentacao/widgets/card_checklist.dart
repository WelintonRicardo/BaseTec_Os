import 'package:flutter/material.dart';

class CardChecklist extends StatefulWidget {
  final List<Map<String, dynamic>> itens;
  final Function(List<Map<String, dynamic>>) onChanged;

  const CardChecklist({
    super.key,
    required this.itens,
    required this.onChanged,
  });

  @override
  State<CardChecklist> createState() => _CardChecklistState();
}

class _CardChecklistState extends State<CardChecklist> {
  late List<Map<String, dynamic>> itensLocal;

  @override
  void initState() {
    super.initState();
    itensLocal = List<Map<String, dynamic>>.from(widget.itens);
  }

  void atualizarItem(int index, bool checked) {
    setState(() {
      itensLocal[index]['checked'] = checked;
    });
    widget.onChanged(itensLocal);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Checklist',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...itensLocal.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return CheckboxListTile(
                title: Text(
                  item['titulo'],
                  style: const TextStyle(color: Colors.white),
                ),
                value: item['checked'] ?? false,
                onChanged: (value) {
                  atualizarItem(index, value ?? false);
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
