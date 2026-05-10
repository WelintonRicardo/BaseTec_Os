import 'package:supabase_flutter/supabase_flutter.dart';
import '../../modelos/os_fotos_model.dart';

class OSRepository {
  final _supabase = Supabase.instance.client;

  Future<void> salvarDadosFoto(OSFotoModel foto) async {
    await _supabase.from('os_fotos').insert(foto.toMap());
  }
}
  