import 'package:intl/intl.dart';

class Shift {
  final int id;
  final String type;
  final DateTime start;
  final DateTime end;
  final int registrationsWanted;
  final int registrations;
  final bool available;

  Shift({
    required this.id,
    required this.type,
    required this.start,
    required this.end,
    required this.registrationsWanted,
    required this.registrations,
    required this.available
  });

  factory Shift.fromMap(Map<String, dynamic> map){
    return Shift(
      id: map['id'] as int,
      type: map['type'] as String,
      start: DateTime.parse(map['date']+' '+map['start']),
      end: DateTime.parse(map['date']+' '+map['end']),
      registrationsWanted: map['registrationsWanted'] as int,
      registrations: map['registrations'] as int,
      available: map['available'] as bool,
    );
  }

  final formatStart = DateFormat('dd.MM.yyyy HH:mm');
  final formatEnd = DateFormat(' - HH:mm');

  getTimeSpan() {
    return formatStart.format(start) + formatEnd.format(end);
  }

}