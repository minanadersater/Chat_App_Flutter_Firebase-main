import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../packges/download.dart';
import 'delete_massege.dart';

// ignore: camel_case_types
class massege {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Widget messages(
      {required Size size,
      required Map<String, dynamic> map,
      required BuildContext context,
      required String collection,
      required String reciverid,
      required String layer,
      required int who,
      required String docid}) {
    return Builder(
      builder: (_) {
        if (map["status"] == true) {
          return Container(
            width: size.width,
            alignment: map['sendBy'] == _auth.currentUser!.displayName
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.black,
                ),
                child: Column(
                  children: [
                    Text(
                      "massege was deleted",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )),
          );
        } else if (map['type'] == "text" && map["status"] == false) {
          return Container(
            width: size.width,
            alignment: map['sendBy'] == _auth.currentUser!.displayName
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: InkWell(
              onTap: () {
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: 100,
                      color: Colors.white,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const Text('Delete This Massege'),
                            ElevatedButton(
                              child: const Text('Delete'),
                              onPressed: () => Up().update(
                                id: docid,
                                collection: collection,
                                receiverid: reciverid,
                                layer: layer,
                                who: who,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
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
                      SelectableText(
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
          );
        } else if (map['type'] == "files" && map["status"] == false) {
          return Container(
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
              child: InkWell(
                onTap: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 100,
                        color: Colors.white,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const Text('Delete This Massege'),
                              ElevatedButton(
                                child: const Text('Delete'),
                                onPressed: () => Up().update(
                                  id: docid,
                                  collection: collection,
                                  receiverid: reciverid,
                                  layer: layer,
                                  who: who,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
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
                                downloadFile(map['message'], map['filename']);
                              },
                              icon: const Icon(Icons.download,
                                  color: Colors.black))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }
}
