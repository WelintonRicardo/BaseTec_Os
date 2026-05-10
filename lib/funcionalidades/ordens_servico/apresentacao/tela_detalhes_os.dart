import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart'; // Para ligar e abrir mapa
import '../controle/controle_os_cubit.dart';
import '../modelos/ordem_servico_modelo.dart';

class TelaDetalhesOS extends StatelessWidget {
  final OrdemServicoModelo os;

  const TelaDetalhesOS({super.key, required this.os});

  // Função para abrir o Google Maps/Waze
  Future<void> _abrirMapa() async {
    final endereco = "${os.endereco}, ${os.numeroResidencia}, ${os.cidade}";
    final url = Uri.parse("https://google.com");
    if (await canLaunchUrl(url)) await launchUrl(url);
  }

  // Função para ligar para o cliente
  Future<void> _ligarCliente() async {
    final url = Uri.parse("tel:${os.telefoneSegurado}"); // Certifique-se que o modelo tem esse campo
    if (await canLaunchUrl(url)) await launchUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    final String horaInicio = os.janelaInicioAgendada?.hour.toString().padLeft(2, '0') ?? "00";
    final String horaFim = os.janelaFimAgendada?.hour.toString().padLeft(2, '0') ?? "00";

    return Scaffold(
      appBar: AppBar(
        title: Text('O.S: ${os.numeroAssistencia}'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCardStatus(),
            const SizedBox(height: 24),
            
            // --- SEÇÃO: DADOS DO SEGURADO E SERVIÇO ---
            _sessaoTitulo('DADOS DO ATENDIMENTO'),
            const Divider(),
            _infoLinha(Icons.business, "Seguradora", os.seguradora ?? "Não informada"),
            _infoLinha(Icons.person, "Segurado", os.nomeSegurado),
            _infoLinha(Icons.build, "Serviço", os.servicoExecutar ?? "Reparo Geral"),
            
            const SizedBox(height: 24),
            
            // --- SEÇÃO: LOCALIZAÇÃO ---
            _sessaoTitulo('LOCALIZAÇÃO E HORÁRIO'),
            const Divider(),
            _infoLinha(Icons.location_on, "Endereço", "${os.endereco}, ${os.numeroResidencia}"),
            if (os.complemento != null && os.complemento!.isNotEmpty)
              _infoLinha(Icons.maps_home_work, "Complemento", os.complemento!),
            _infoLinha(Icons.location_city, "Cidade", os.cidade),
            _infoLinha(Icons.access_time, "Janela", "$horaInicio:00 às $horaFim:00"),
            
            const SizedBox(height: 32),

            // --- BARRA DE AÇÕES RÁPIDAS ---
            Row(
              children: [
                Expanded(child: _botaoAcaoRapida(Icons.phone, "Ligar", Colors.blue, _ligarCliente)),
                const SizedBox(width: 10),
                Expanded(child: _botaoAcaoRapida(Icons.map, "Rota", Colors.green, _abrirMapa)),
                const SizedBox(width: 10),
                Expanded(child: _botaoAcaoRapida(Icons.person_off, "Ausente", Colors.orange, () {})),
              ],
            ),

            const SizedBox(height: 24),
            
            // --- LÓGICA DE STATUS / FLUXO ---
            if (os.status == 'pendente')
              _botaoPrincipal(
                label: 'INICIAR SERVIÇO (CHECK-IN)',
                cor: Colors.green,
                icone: Icons.play_arrow,
                onPressed: () => _executarCheckIn(context),
              )
            else if (os.status == 'em_atendimento')
              Column(
                children: [
                  _statusEmAndamento(),
                  const SizedBox(height: 16),
                  _botaoPrincipal(
                    label: 'FOTOS E CHECKLIST',
                    cor: Colors.blue,
                    icone: Icons.camera_alt,
                    onPressed: () {
                      // Aqui navegamos para a tela de fotos que criamos antes
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _sessaoTitulo(String texto) {
    return Text(texto, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 11, letterSpacing: 1.2));
  }

  Widget _infoLinha(IconData icone, String label, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icone, size: 20, color: Colors.blueGrey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                Text(valor, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _botaoAcaoRapida(IconData icone, String label, Color cor, VoidCallback onTap) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        foregroundColor: cor,
        side: BorderSide(color: cor),
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onTap,
      icon: Icon(icone, size: 18),
      label: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _botaoPrincipal({required String label, required Color cor, required IconData icone, required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: cor,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onPressed,
        icon: Icon(icone),
        label: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  // Restante dos métodos (_buildCardStatus, _statusEmAndamento, _executarCheckIn) seguem a mesma lógica anterior...
  // [Cortei para brevidade, mas devem ser mantidos conforme o original]
  
  Widget _buildCardStatus() {
    final bool isPendente = os.status == 'pendente';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isPendente ? Colors.orange.withOpacity(0.1) : Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isPendente ? Colors.orange : Colors.green),
      ),
      child: Row(
        children: [
          Icon(isPendente ? Icons.timer : Icons.verified, color: isPendente ? Colors.orange : Colors.green),
          const SizedBox(width: 12),
          Text(
            isPendente ? 'AGUARDANDO INÍCIO' : 'EM ATENDIMENTO AGORA',
            style: TextStyle(fontWeight: FontWeight.bold, color: isPendente ? Colors.orange.shade900 : Colors.green.shade900),
          ),
        ],
      ),
    );
  }

  Widget _statusEmAndamento() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12)),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, color: Colors.blue),
          SizedBox(width: 8),
          Text('Check-in realizado!', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _executarCheckIn(BuildContext context) {
    context.read<ControleOSCubit>().realizarCheckIn(os.id);
  }
}
