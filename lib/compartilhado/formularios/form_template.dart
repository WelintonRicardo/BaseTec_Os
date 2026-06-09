// lib/compartilhado/formularios/form_template.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../layouts/responsive_layout.dart';

class FormTemplate extends StatelessWidget {
  final String title;

  final GlobalKey<FormState> formKey;

  final List<Widget> children;

  final VoidCallback onClear;

  final Future<void> Function()? onSubmit;

  final bool submitting;

  final String submitLabel;

  final double wideBreakpoint;

  final double centeredBreakpoint;

  final double maxWidth;

  final EdgeInsetsGeometry padding;

  const FormTemplate({
    Key? key,

    required this.title,

    required this.formKey,

    required this.children,

    required this.onClear,

    this.onSubmit,

    this.submitting = false,

    this.submitLabel = 'Salvar',

    this.wideBreakpoint = 900,

    this.centeredBreakpoint = 1400,

    this.maxWidth = 1200,

    this.padding = const EdgeInsets.all(16),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final titleStyle =
        Theme.of(context).textTheme.titleLarge ??
        const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

    return Scaffold(
      appBar: AppBar(title: Text(title, style: titleStyle), elevation: 0),

      body: ResponsiveLayout(
        wideBreakpoint: wideBreakpoint,

        centeredBreakpoint: centeredBreakpoint,

        maxWidth: maxWidth,

        padding: padding,

        builder: (context, isWide, isCentered) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,

              children: [
                Card(
                  elevation: 2,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),

                  color: Theme.of(context).cardColor,

                  child: Padding(
                    padding: const EdgeInsets.all(16),

                    child: Form(
                      key: formKey,

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,

                        children: [
                          ...children,

                          const SizedBox(height: 20),

                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: submitting ? null : onClear,

                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                  ),

                                  child: const Text('Limpar'),
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: ElevatedButton(
                                  onPressed: submitting
                                      ? null
                                      : () async {
                                          if (!formKey.currentState!
                                              .validate()) {
                                            return;
                                          }

                                          if (onSubmit != null) {
                                            await onSubmit!();
                                          }
                                        },

                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                  ),

                                  child: submitting
                                      ? const SizedBox(
                                          height: 18,

                                          width: 18,

                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,

                                            color: Colors.white,
                                          ),
                                        )
                                      : Text(submitLabel),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ===========================================================
// CABEÇALHO DE SEÇÃO
// ===========================================================

class SectionHeader extends StatelessWidget {
  final String label;

  final EdgeInsetsGeometry padding;

  const SectionHeader(
    this.label, {

    Key? key,

    this.padding = const EdgeInsets.only(top: 8, bottom: 8),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final style =
        Theme.of(context).textTheme.titleMedium ??
        const TextStyle(fontSize: 16, fontWeight: FontWeight.w600);

    return Padding(
      padding: padding,

      child: Text(label, style: style),
    );
  }
}

// ===========================================================
// CAMPO DE TEXTO PADRONIZADO
// ===========================================================

class LabeledField extends StatelessWidget {
  final TextEditingController controller;

  final String label;

  final String? hintText;

  final bool optional;

  final int maxLines;

  final TextInputType keyboardType;

  final List<TextInputFormatter>? inputFormatters;

  final String? Function(String?)? validator;

  final void Function(String)? onChanged;

  final bool enabled;

  const LabeledField({
    Key? key,

    required this.controller,

    required this.label,

    this.hintText,

    this.optional = false,

    this.maxLines = 1,

    this.keyboardType = TextInputType.text,

    this.inputFormatters,

    this.validator,

    this.onChanged,

    this.enabled = true,
  }) : super(key: key);

  String? _defaultValidator(String? v) {
    if (optional) {
      return null;
    }

    if (v == null || v.trim().isEmpty) {
      return 'Campo obrigatório';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,

      keyboardType: keyboardType,

      inputFormatters: inputFormatters,

      maxLines: maxLines,

      validator: validator ?? _defaultValidator,

      onChanged: onChanged,

      enabled: enabled,

      decoration: InputDecoration(
        labelText: optional ? '$label (opcional)' : label,

        hintText: hintText,

        filled: true,

        fillColor:
            Theme.of(context).inputDecorationTheme.fillColor ??
            Colors.transparent,

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),

          borderSide: BorderSide(
            width: 2,

            color: Theme.of(context).primaryColor,
          ),
        ),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,

          vertical: 16,
        ),
      ),
    );
  }
}

// ===========================================================
// DROPDOWN PADRONIZADO
// ===========================================================

class DropdownField<T> extends StatelessWidget {
  final T? value;

  final List<DropdownMenuItem<T>> items;

  final void Function(T?) onChanged;

  final String label;

  final String? Function(T?)? validator;

  const DropdownField({
    Key? key,

    required this.value,

    required this.items,

    required this.onChanged,

    required this.label,

    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,

      items: items,

      onChanged: onChanged,

      decoration: InputDecoration(
        labelText: label,

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,

          vertical: 16,
        ),

        filled: true,

        fillColor:
            Theme.of(context).inputDecorationTheme.fillColor ??
            Colors.transparent,
      ),

      validator: validator == null
          ? (v) {
              if (v == null) {
                return 'Selecione $label';
              }

              return null;
            }
          : (v) => validator!(v),
    );
  }
}

// ===========================================================
// CAMPO DATA/HORA
// ===========================================================

class DateTimeField extends StatelessWidget {
  final DateTime? data;

  final TimeOfDay? hora;

  final VoidCallback onSelectDate;

  final VoidCallback onSelectTime;

  final String label;

  const DateTimeField({
    Key? key,

    required this.data,

    required this.hora,

    required this.onSelectDate,

    required this.onSelectTime,

    this.label = 'Agendamento',
  }) : super(key: key);

  String _format(DateTime? d, TimeOfDay? t) {
    if (d == null || t == null) {
      return 'Não selecionado';
    }

    final dt = DateTime(d.year, d.month, d.day, t.hour, t.minute);

    return DateFormat('dd/MM/yyyy HH:mm').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        SectionHeader(label),

        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onSelectDate,

                child: Text(
                  data == null
                      ? 'Selecionar data'
                      : DateFormat('dd/MM/yyyy').format(data!),
                ),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: OutlinedButton(
                onPressed: onSelectTime,

                child: Text(
                  hora == null ? 'Selecionar hora' : hora!.format(context),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        Text('Selecionado: ${_format(data, hora)}'),
      ],
    );
  }
}