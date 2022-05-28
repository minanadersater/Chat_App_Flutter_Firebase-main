import 'dart:async';
import 'package:chat_app/Screens/ChatListScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Varified extends StatefulWidget {
  const Varified({Key? key}) : super(key: key);

  @override
  State<Varified> createState() => _VarifiedState();
}

class _VarifiedState extends State<Varified> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isvarified = false;
  Timer? timer;

  void initState() {
    super.initState();

    isvarified = _auth.currentUser!.emailVerified;
    if (!isvarified) {
      sendemail();
    }
  }

  Future sendemail() async {
    final user = _auth.currentUser!;
    await user.sendEmailVerification();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (isvarified) {
      return ChatListScreen();
    } else {
      return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Expanded(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: size.width - 20,
                        child: Text(
                          'An Email has been Sent To Your Mail Please Verifiy Your Email And Try Again',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              overflow: TextOverflow.visible),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FloatingActionButton(
                          child: Icon(Icons.arrow_back),
                          onPressed: () =>
                              Navigator.popAndPushNamed(context, '/login'))
                    ],
                  ),
                ]),
          ),
        ),
      );
    }
  }
}
