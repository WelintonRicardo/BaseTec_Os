# Changelog

## v0.1.0 - 2026-05-30

**Resumo**
- Versão inicial do módulo de Cadastro de OS (ponto 0 do projeto).
- Separação clara entre UI, controller, modelo e regras de negócio.
- Template de formulário responsivo e melhorias visuais.
- Regra de serviço *Emergencial* (início = agora; fim = agora + 70 minutos).
- Novos campos: `servico`, `informacoes_adicionais`, `valor_mao_obra`, `valor_deslocamento_km`, `valor_pecas`, `agendamento_fim`.

**Arquivos principais adicionados/alterados**
- `lib/funcionalidades/cadastro/dominio/cadastro_os_model.dart` *(novo)*  
- `lib/funcionalidades/cadastro/controle/cadastro_os_controller.dart` *(novo/atualizado)*  
- `lib/funcionalidades/cadastro/regras/service_rules.dart` *(novo)*  
- `lib/funcionalidades/cadastro/apresentacao/telas/tela_cadastro_os.dart` *(atualizado)*  
- `lib/compartilhado/formularios/form_template.dart` *(atualizado)*  
- `lib/compartilhado/layouts/responsive_layout.dart` *(novo, utilitário responsivo)*

**Funcionalidades**
- **Separação de responsabilidades**: UI apenas monta widgets; controller centraliza validações, parsing e envio.
- **Regra Emergencial**: ao selecionar `Emergencial`, `dataAgendamento` = hoje, `horaInicio` = agora, `horaFim` = agora + 70 minutos.
- **UX**: `FormTemplate` com card, espaçamento, campos padronizados e responsividade centralizada.
- **Validações**: campos obrigatórios, parsing de valores numéricos (aceita vírgula/ponto), validação de horário fim ≥ início.

**Como testar rapidamente**
1. `flutter pub get`  
2. `flutter run` (ou abrir a tela no emulador)  
3. Abrir **Cadastro de OS**, preencher campos obrigatórios.  
4. Selecionar **Tipo de serviço → Emergencial** e verificar preenchimento automático de data/hora.  
5. Testar envio simulado e mensagens de erro.

**Notas**
- Envio real para repositório/Supabase não implementado (marcado com `TODO` no controller).  
- Regras centralizadas em `ServiceRules` para facilitar alterações futuras.  
- Recomenda-se criar branch de feature e abrir PR com este changelog como descrição inicial.

