// lib/compartilhado/dados/supabase_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final client = Supabase.instance.client;

  Future<List<dynamic>> select(String table,
      {String? filterColumn, dynamic filterValue}) async {
    var query = client.from(table).select();
    if (filterColumn != null && filterValue != null) {
      query = query.eq(filterColumn, filterValue);
    }
    return await query;
  }

  Future<void> insert(String table, Map<String, dynamic> data) async {
    await client.from(table).insert(data);
  }

  Future<void> update(
      String table, Map<String, dynamic> data, String filterColumn, dynamic filterValue) async {
    await client.from(table).update(data).eq(filterColumn, filterValue);
  }

  Future<void> delete(String table, String filterColumn, dynamic filterValue) async {
    await client.from(table).delete().eq(filterColumn, filterValue);
  }
}
