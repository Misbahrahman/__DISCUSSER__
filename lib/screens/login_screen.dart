import 'package:firebase_auth/firebase_auth.dart';
import 'package:lets_talk_about/components/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

import '../constants.dart';
import 'chat_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? email;
  String? password;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ProgressHUD(
          child: Builder(builder: (context) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Hero(
                  tag: 'logo_hero',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('image/logo.png'),
                  ),
                ),
                const SizedBox(
                  height: 48.0,
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration:
                  kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextField(
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your password'),
                ),
                const SizedBox(
                  height: 24.0,
                ),
                TextButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              side: BorderSide(color: Colors.black)
                          )
                      )
                  ),
                  child: Text('Log in'),
                  onPressed: () async {
                    final progress = ProgressHUD.of(context);
                    progress?.show();
                    final userEmail = email;
                    final userPassword = password;
                    if (userEmail != null && userPassword != null) {
                      try {
                        final user = await _auth.signInWithEmailAndPassword(
                            email: userEmail, password: userPassword);
                        Navigator.pushNamed(context, ChatScreen.id);
                      } catch (e) {
                        print(e);
                      }
                    }
                    progress?.dismiss();
                  },
                ),
              ],
            ),
          ),)
      ),
    );
  }
}