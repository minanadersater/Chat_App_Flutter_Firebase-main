import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../packges/download.dart';

// ignore: camel_case_types
class massege {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Widget messages(Size size, Map<String, dynamic> map, BuildContext context) {
    return map['type'] == "text" 
        ?Container(
          width: size.width,
          alignment: map['sendBy'] == _auth.currentUser!.displayName
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: InkWell(
            onTap: () {
              // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              // content: Text('Tap'),
              final snackBar = SnackBar(
                content: Text('delete this masseage'),
                backgroundColor: Colors.blueAccent,
                behavior: SnackBarBehavior.floating,
                action: SnackBarAction(
                  label: 'delete',
                  disabledTextColor: Colors.white,
                  textColor: Colors.white,
                  onPressed: () {
                    print("yes");
                    print(map['message']);
                  },
                ),
              );

              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              // Scaffold.of(context).showSnackBar(snackBarr);
            },
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.blue,
                ),
                child: Column(
                  children: [
                    Text(
                      map['sendBy'],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: size.height / 200,
                    ),
                    Text(
                      map['message'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )),
          ),
        )
       :  Container(
          width: size.width,
          alignment: map['sendBy'] == _auth.currentUser!.displayName
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.blue,
              ),
              child: Column(
                children: [
                  Text(
                    map['sendBy'],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: size.height / 200,
                  ),
                  Container(
                    width: 200,
                    child: Row(
                      children: [
                        Container(
                          width: 150,
                          child: Text(
                            map['filename'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              downloadFile(
                                  map['message'], map['filename']);
                            },
                            icon:
                                const Icon(Icons.download, color: Colors.black))
                      ],
                    ),
                  ),
                ],
              )
              ),
        );
      
    }
  }

