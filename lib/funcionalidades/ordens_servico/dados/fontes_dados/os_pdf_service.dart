import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../modelos/ordem_servico_modelo.dart';

class OSPdfService {
  Future<Uint8List> gerarRelatorio(OrdemServicoModelo os, String nomeRecebedor, Uint8List assinatura) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          // Cabeçalho
          pw.Header(
            level: 0, 
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("RELATORIO DE SERVICO", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text("OS: ${os.numeroAssistencia}"),
              ]
            )
          ),
          pw.SizedBox(height: 20),

          // Informações do Segurado
          pw.Text("Segurado: ${os.nomeSegurado}"),
          pw.Text("Endereco: ${os.endereco}, ${os.numeroResidencia}"),
          pw.Text("Recebido por: $nomeRecebedor"),
          
          pw.SizedBox(height: 20),
          pw.Divider(thickness: 1, color: PdfColors.grey300),
          pw.SizedBox(height: 10),

          // Espaço para o Checklist (Modular)
          pw.Text("ITENS DO CHECKLIST:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          // Aqui no futuro mapearemos os itens do checklist dinâmico
          
          pw.Spacer(), // Empurra as assinaturas para o final da página

          // Seção de Assinaturas
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              pw.Column(
                children: [
                  pw.Image(pw.MemoryImage(assinatura), width: 120, height: 60),
                  // AJUSTE AQUI: Usando SizedBox para definir a largura da linha
                  pw.SizedBox(
                    width: 150, 
                    child: pw.Divider(thickness: 1)
                  ),
                  pw.Text("Assinatura do Cliente", style: pw.TextStyle(fontSize: 10)),
                  pw.Text(nomeRecebedor, style: pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
                ]
              ),
              pw.Column(
                children: [
                  pw.SizedBox(width: 120, height: 60), // Espaço para assinatura do técnico
                  pw.SizedBox(
                    width: 150, 
                    child: pw.Divider(thickness: 1)
                  ),
                  pw.Text("Assinatura do Tecnico", style: pw.TextStyle(fontSize: 10)),
                ]
              ),
            ],
          ),
        ],
      ),
    );
    return pdf.save();
  }
}
