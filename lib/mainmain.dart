import 'package:chat_app/Authenticate/Autheticate.dart';
import 'package:chat_app/Screens/HomeScreen.dart';
import 'package:chat_app/pages/login.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title:("chat :${AuthServices().user.email}"),
      theme: ThemeData(
        primarySwatch: Colors.blue,

      ),
      home: StreamBuilder(
        stream: AuthServices().onChangedUser,
        builder:(context,snapshot){
          return snapshot.data == null?LoginPage():HomeScreen();
        },
      ),
    );
  }
}

