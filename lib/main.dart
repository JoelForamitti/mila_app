import 'package:flutter/material.dart';
import 'package:layout/layout.dart';
import 'package:mila_app/services/services.dart';
import 'package:mila_app/pages/home_page.dart';
import 'package:mila_app/pages/login_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Services(  // Inherited widget for backend-connection
      child: Layout(  // Package for responsive layout tools
        child: MaterialApp(
          title: 'MILA App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            appBarTheme: AppBarTheme(
              color: Colors.white,
            ),
            scaffoldBackgroundColor: Colors.grey[200],
            primarySwatch: Colors.blue,
          ),
          home: Builder(
            builder: (context) {  // Pass context to FutureBuilder?
              // Recover session or show login page
              return FutureBuilder<bool>(
                future: Services.of(context).authService.recoverSession(),
                builder: (context, snapshot) {
                  final sessionRecovered = snapshot.data ?? false;
                  return sessionRecovered ? HomePage() : LoginPage();
                },
              );
            },
          ),
        ),
      )
    );
  }
}

