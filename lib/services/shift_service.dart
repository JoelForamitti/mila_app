import 'package:supabase/supabase.dart';
import 'package:mila_app/models/shift.dart';
import 'dart:developer';  // For log

class ShiftService {
  static const shifts = 'shifts';
  static const shift_registrations = 'shift_registrations';
  final SupabaseClient _client;
  ShiftService(this._client);

  String _cleanFilterArray(List filter) {
    // For passing of lists to database
    return filter.map((s) => '"$s"').join(',');
  }

  Future<List<Shift>> getShifts() async {
    final response = await _client.from(shifts).select().execute();
    if (response.error == null) {
      final results = response.data as List<dynamic>;
      return results.map((e) => Shift.fromMap(e)).toList();
    }
    log('Error fetching shifts: ${response.error!.message}');
    return [];
  }

  Future<List<Shift>> getShiftsById(List<int> shiftIds) async {
    final response = await _client
        .from(shifts)
        .select()
        .in_('id', shiftIds)
        .execute();
    if (response.error == null) {
      final results = response.data as List<dynamic>;
      return results.map((e) => Shift.fromMap(e)).toList();
    }
    log('Error fetching shifts: ${response.error!.message}');
    return [];
  }

  Future<List<Shift>> getAvailableShifts() async {
      final userShiftIds = await getShiftIdsOfUser();
      final response = await _client
          .from(shifts)
          .select()
          .eq('available', true)
          .not('id', 'in', '(${_cleanFilterArray(userShiftIds)})')
          .execute();
      if (response.error == null) {
        final results = response.data as List<dynamic>;
        return results.map((e) => Shift.fromMap(e)).toList();
      }
      log('Error fetching shifts: ${response.error!.message}');
      return [];
  }

  // Handle User Shift Registrations (Table: shift_registrations) ----------- //

  Future<List<int>> getUserIdsOfShift(Shift shift) async {
    final response = await _client
      .from(shift_registrations)
      .select()  // 'user_id'
      .eq('shift_id', shift.id)
      .execute();
    if (response.error == null) {
      final results = response.data as List<dynamic>;
      return results.map((e) => e['id'] as int).toList();
    }
    log('Error fetching shift registrations: ${response.error!.message}');
    return [];
  }
  
  Future<List<int>> getShiftIdsOfUser() async {
    final response = await _client
        .from(shift_registrations)
        .select('shift_id').execute();
    if (response.error == null) {
      final results = response.data as List<dynamic>;
      return results.map((e) => e['shift_id'] as int).toList();
    }
    log('Error fetching shift registrations: ${response.error!.message}');
    return [];
  }

  Future<List<Shift>> getShiftsOfUser() async {
    final shiftIds = await getShiftIdsOfUser();
    return getShiftsById(shiftIds);
  }

  Future<void> updateShiftRegistrations(Shift shift) async {
    final userIds = await getUserIdsOfShift(shift);
    final response = await _client
        .from(shifts)
        .update({'registrations': userIds.length})
        .eq('id', shift.id)
        .execute();
    if (response.error == null){
      return;
    }
    log('Error updating registrations for shift ${shift.id}: '
        '${response.error!.message}');
    return;
  }

  Future<bool> removeUserShift(Shift shift) async {
    final response = await _client
        .from(shift_registrations)
        .delete()
        .match({'shift_id': shift.id})
        .execute();
    await updateShiftRegistrations(shift);
    if (response.error == null){
      return true;
    }
    log('Error removing registration for shift ${shift.id}: ${response.error!.message}');
    return false;
  }

  Future<bool> createUserShift(Shift shift) async {
    final response = await _client
        .from(shift_registrations)
        .insert({'shift_id': shift.id}).execute();

    await updateShiftRegistrations(shift);

    if (response.error == null){
      log('Adding registration for shift ${shift.id}');
      return true;
    }
    log('Error registering shift: ${response.error!.message}');
    return false;
  }

}
