
import 'package:app/option_widget/signup_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app/homescreen.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  
  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    final auth = FirebaseAuth.instance;
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SizedBox(
            width: widthScreen,
            child: StreamBuilder(
              stream: auth.authStateChanges(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if(snapshot.hasData)
                {
                  return const HomeScreen();
                }            
                return const SignIn();
              },
            ),
          
          );
        },
      ),
      
    );
  }
}