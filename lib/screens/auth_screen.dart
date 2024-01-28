import 'package:flutter/material.dart';

import '../widgets/auth_form.dart';
import '../widgets/sign_up_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var _hasAccount = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          Expanded(
            flex: 2,
            child: Container(),
          ),
          //Expanded(
          //  child: Center(
            //  child: Image.asset(
              //  'assets/messenger_logo.png',
                //fit: BoxFit.cover,
             // ),
           // ),
          //),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                _hasAccount ? const AuthForm() : const SignUpForm(),
                if (_hasAccount)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _hasAccount = false;
                      });
                    },
                    child: const Text("don't have an account? Sign Up."),
                  ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
