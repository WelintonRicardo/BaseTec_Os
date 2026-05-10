import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class OSStorageService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<String> uploadFoto(File file, String osId) async {
    final fileName = '${osId}/${const Uuid().v4()}.jpg';
    
    // Faz o upload para o bucket 'os_fotos' (Crie este bucket no painel do Supabase!)
    await _supabase.storage.from('os_fotos').upload(
          fileName,
          file,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
        );

    // Retorna a URL pública do arquivo
    return _supabase.storage.from('os_fotos').getPublicUrl(fileName);
  }
}
