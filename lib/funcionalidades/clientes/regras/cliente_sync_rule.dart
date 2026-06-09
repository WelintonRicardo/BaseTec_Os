import '../models/cliente_model.dart';
import '../repository/cliente_repository.dart';

class ClienteSyncRule {
  final ClienteRepository repository;

  ClienteSyncRule(this.repository);

  // =========================================================
  // SINCRONIZAR CLIENTE
  // =========================================================

  Future<void> sincronizar(ClienteModel novoCliente) async {
    final existente = await repository.buscarPorNome(
      empresaId: novoCliente.empresaId,
      nome: novoCliente.nome,
    );

    // =====================================================
    // NÃO EXISTE
    // =====================================================

    if (existente == null) {
      await repository.inserir(novoCliente);

      return;
    }

    // =====================================================
    // COMPARAR ALTERAÇÕES
    // =====================================================

    final houveAlteracao =
        existente.telefone != novoCliente.telefone ||
        existente.cep != novoCliente.cep ||
        existente.estado != novoCliente.estado ||
        existente.cidade != novoCliente.cidade ||
        existente.bairro != novoCliente.bairro ||
        existente.rua != novoCliente.rua ||
        existente.numero != novoCliente.numero ||
        existente.complemento != novoCliente.complemento;

    // =====================================================
    // SEM ALTERAÇÃO
    // =====================================================

    if (!houveAlteracao) {
      return;
    }

    // =====================================================
    // ATUALIZAR
    // =====================================================

    await repository.atualizar(
      id: existente.id!,
      cliente: novoCliente,
    );
  }
}