import 'package:lets_talk_about/components/buttons.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants.dart';
import 'chat_screen.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ProgressHUD(
        child: Builder(
            builder: (context) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      email = value;
                    },
                    decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Enter your Email'),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    obscureText: true,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      password = value;
                    },
                    decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter your password'),
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),
                  TextButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(30)),
                                side: BorderSide(color: Colors.black)
                            )
                        )
                    ),
                    child: Text('Register'),
                    onPressed: () async {
                      final progress = ProgressHUD.of(context);
                      progress?.show();
                      final userEmail = email;
                      final userPassword = password;
                      if (userEmail != null && userPassword != null) {
                        try {
                          final newUser =
                          await _auth.createUserWithEmailAndPassword(
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
            )
        ),
      ),
    );
  }
}
