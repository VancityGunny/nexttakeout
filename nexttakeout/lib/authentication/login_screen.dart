import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nexttakeout/authentication/index.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  LoginScreenState();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Form(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Image.asset('graphics/logo.png', height: 200),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[GoogleLoginButton()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      icon: Icon(FontAwesomeIcons.google, color: Colors.white),
      onPressed: () {
        BlocProvider.of<AuthBloc>(context).add(
          LoginInWithGoogleAuthEvent(),
        );
      },
      label: Text('Sign in with Google', style: TextStyle(color: Colors.white)),
      color: Colors.redAccent,
    );
  }
}
