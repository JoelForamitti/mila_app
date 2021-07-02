import 'package:flutter/material.dart';
import 'package:mila_app/services/services.dart';
import 'package:mila_app/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signUp() async {
    final success = await Services.of(context)
        .authService
        .signUp(_emailController.text, _passwordController.text);
    await _handleResponse(success);
  }

  void _signIn() async {
    final success = await Services.of(context)
        .authService
        .signIn(_emailController.text, _passwordController.text);
    await _handleResponse(success);
  }

  Future<void> _handleResponse(bool success) async {
    if (success) {
      await Navigator.pushReplacement(  // Prevents going back
          context, MaterialPageRoute(builder: (_) => HomePage()));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Something went wrong.')));
    }
  }

  @override
  Widget build(BuildContext context) {

    final email = TextField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      //autofocus: false,
      decoration: InputDecoration(
        hintText: 'Email',
      //  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      //  border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextField(
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        //border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = ElevatedButton(
        child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Anmelden'),
        ),
        onPressed: _signIn
    );

    final forgotLabel = TextButton(
      child: Text(
      'Passwort vergessen?',
      style: TextStyle(color: Colors.black54),
      ),
      onPressed: (){
        //Services.of(context).authService.resetPassword(_emailController.text);
      },
      );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Image.asset("logo_wide.png"), //logo,
                SizedBox(height: 48.0),
                email,
                SizedBox(height: 8.0),
                password,
                SizedBox(height: 24.0),
                loginButton,
                SizedBox(height: 8.0),
                forgotLabel
              ],
            )
          )
        )
      )
    );
  }
}