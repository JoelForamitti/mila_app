import 'package:flutter/material.dart';
import 'package:mila_app/services/services.dart';
import 'package:mila_app/pages/login_page.dart';

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({Key? key}) : super(key: key);

  @override
  _MyAccountPageState createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  final orangeButtonStyle = ElevatedButton.styleFrom(
      primary: Colors.deepOrange[900]
  );
  final heading = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold
  );
  final bold = TextStyle(
      fontWeight: FontWeight.bold
  );
  final normal = TextStyle(
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: Services.of(context).userService.getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final user = Services.of(context).authService.getUser();
          final userData = (snapshot.data ?? {});
          return Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(userData['name'], style: heading),
                    SizedBox(height: 15.0),
                    Row(
                        children: [
                          Text('Email Adresse: ', style: bold),
                          Text(user.email, style: normal)
                        ]
                    ),
                    SizedBox(height: 15.0),
                    Row(
                        children: [
                          Text('Schichtenstand: ', style: bold),
                          Text('${userData['shift_balance']}', style: normal)
                        ]
                    ),
                    SizedBox(height: 15.0),
                    ElevatedButton(
                      child: Text('Abmelden'),
                      style: orangeButtonStyle,
                      onPressed: (){
                        Services.of(context).authService.signOut();
                        Navigator.pushReplacement(
                          context, MaterialPageRoute(
                            builder: (_) => LoginPage()
                          )
                        );
                      },
                    )
                  ]
              )
          );
        } else {
          return Center(
              child: CircularProgressIndicator()
          );
        }
      }
    );
  }
}

