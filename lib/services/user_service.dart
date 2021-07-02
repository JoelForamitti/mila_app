import 'package:supabase/supabase.dart';
import 'dart:developer';  // For log

class UserService {
  final SupabaseClient _client;

  UserService(this._client);

  Future<Map<String, dynamic>> getUserData() async {
    final id = _client.auth.currentUser!.id;
    final response = await _client
        .from('users')
        .select() // 'user_id'
        .eq('id', id)
        .execute();
    if (response.error == null) {
      final results = response.data;
      return results.first;
    }
    log('Error fetching username: ${response.error!.message}');
    return {};
  }

}