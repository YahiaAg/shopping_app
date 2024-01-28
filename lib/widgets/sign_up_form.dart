import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../providers/database.dart';

import '../screens/products_overview_screen.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {


  Future<void> signUp(
    String email,
    String password,
    String name,
    String wilayaNumber,
  ) async {
     firebase_auth.FirebaseAuth.instance
    .createUserWithEmailAndPassword(email: email, password: password)
    .then((value) async {

    try {
        Database.makeConnection().then((_) async {
        var connection = Database.connection;
        await connection!.execute(
          "INSERT INTO Customers (Name, Email, WilayaNumber) VALUES ('$name' , '$email' , '$wilayaNumber')",
        );
        print("done");
      });
    } catch (e) {
      print(e);
      print("failed");
    }
    });
    // }  );
  }

  final GlobalKey<FormState> _formKey = GlobalKey();
  String _password = "";
  String _email = "";
  String _username = "";
  String _wilayaNumber = '16';

  void login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        signUp(_email, _password, _username, _wilayaNumber);
        Navigator.of(context)
            .pushReplacementNamed(ProductsOverviewScreen.routeName);
      } on PlatformException catch (e) {
        showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: const Text("invalid credentials"),
                content: Text(e.message ?? "something went wrong"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: const Text("Ok"))
                ],
              );
            });
      } catch (e) {
        showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: const Text("try again"),
                content: Text(e.toString()),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: const Text("Ok"))
                ],
              );
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                margin: const EdgeInsets.symmetric(
                  horizontal: 5,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[200]),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty ||
                        value.length < 5 ||
                        value.length > 20) {
                      return "Please enter a valid username";
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: "Username",
                  ),
                  onSaved: (newValue) => _username = newValue!,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[200]),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty || !value.contains("@")) {
                      return "Please enter a valid email address";
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                      labelText: "   Email",
                      hintText: "Enter your email",
                      border: InputBorder.none),
                  onSaved: (newValue) => _email = newValue!.trim(),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                margin: const EdgeInsets.symmetric(
                  horizontal: 5,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[200]),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty || value.length < 7) {
                      return "Please enter a valid password";
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                      labelText: "Password",
                      hintText: "Enter your password",
                      border: InputBorder.none),
                  obscureText: true,
                  onSaved: (newValue) => _password = newValue!,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[200]),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a valid algerian wilaya number";
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                      labelText: "   Wilaya number",
                      hintText: "Enter your current Wilaya number",
                      border: InputBorder.none),
                  onSaved: (newValue) => _wilayaNumber = newValue!,
                ),
              ),
              FilledButton(
                  onPressed: () {
                    login(context);
                  },
                  child: const Text("Sign Up")),
            ],
          ),
        ),
      ),
    );
  }
}
