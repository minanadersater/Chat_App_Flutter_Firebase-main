import 'package:chat_app/Screens/ChatListScreen.dart';
import 'package:chat_app/Authenticate/LoginScree.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    if (_auth.currentUser != null) {
      return ChatListScreen();
    } else {
      return LoginScreen();
    }
  }
}
