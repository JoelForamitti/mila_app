import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';

import 'package:mila_app/secrets.dart';
import 'package:mila_app/services/shift_service.dart';
import 'package:mila_app/services/auth_service.dart';
import 'package:mila_app/services/user_service.dart';

class Services extends InheritedWidget {
  final AuthService authService;
  final ShiftService shiftService;
  final UserService userService;

  Services._({
    required this.authService,
    required this.shiftService,
    required this.userService,
    required Widget child,
  }) : super(child: child);

  factory Services({required Widget child}) {
    final client = SupabaseClient(supabaseUrl, supabaseKey);
    final authService = AuthService(client.auth);
    final shiftService = ShiftService(client);
    final userService = UserService(client);
    return Services._(
      authService: authService,
      shiftService: shiftService,
      userService: userService,
      child: child,
    );
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }

  static Services of(BuildContext context) {
    // Convenience method to access services
    return context.dependOnInheritedWidgetOfExactType<Services>()!;
  }
}

