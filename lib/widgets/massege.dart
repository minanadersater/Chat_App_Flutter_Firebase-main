import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:selectable_autolink_text/selectable_autolink_text.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../packges/download.dart';
import 'bottomsheet.dart';

class Massege {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextSelectionControls _controls = MaterialTextSelectionControls();
  Widget messages(
      {
      required Map<String, dynamic> map,
      required BuildContext context,
      required String collection,
      required String reciverid,
      required String layer,
      required int who,
      required String docid}) {
    final  size = MediaQuery.of(context).size;
    return Builder(
      builder: (_) {
        if (map["status"] == true) {
          return InkWell(
            onLongPress: () {
              if (map['sendBy'] == _auth.currentUser!.displayName) {
                bottomsheet(
                  context: context,
                  docid: docid,
                  collection: collection,
                  reciverid: reciverid,
                  layer: layer,
                  who: who,
                  status: false,
                );
              }
            },
            child: Container(
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
            ),
          );
        } else if (map['type'] == "text" && map["status"] == false) {
          return InkWell(
            onLongPress: () {
              if (map['sendBy'] == _auth.currentUser!.displayName) {
                bottomsheet(
                    context: context,
                    docid: docid,
                    collection: collection,
                    reciverid: reciverid,
                    layer: layer,
                    who: who,
                    status: true);
              }
            },
            child: Container(
              width: size.width / 2,
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
                  child: who != 3
                      ? map['sendBy'] != _auth.currentUser!.displayName
                          ? Column(
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
                                SelectableAutoLinkText(
                                  map['message'],
                                  showCursor: true,
                                  selectionControls: _controls,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                  linkStyle: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                  highlightedLinkStyle: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    backgroundColor: Colors.black,
                                  ),
                                  onTap: (url) => launchUrlString(url),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                SelectableAutoLinkText(
                                  map['message'],
                                  showCursor: true,
                                  selectionControls: _controls,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                  linkStyle: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                  highlightedLinkStyle: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    backgroundColor: Colors.black,
                                  ),
                                  onTap: (url) => launchUrlString(url),
                                ),
                              ],
                            )
                      : Column(
                          children: [
                            SelectableAutoLinkText(
                              map['message'],
                              showCursor: true,
                              selectionControls: _controls,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                              linkStyle:
                                  TextStyle(fontSize: 16, color: Colors.white),
                              highlightedLinkStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                backgroundColor: Colors.black,
                              ),
                              onTap: (url) => launchUrlString(url),
                            ),
                          ],
                        )),
            ),
          );
        } else if (map['type'] == "files" && map["status"] == false) {
          return InkWell(
            onLongPress: () {
              if (map['sendBy'] == _auth.currentUser!.displayName) {
                bottomsheet(
                    context: context,
                    docid: docid,
                    collection: collection,
                    reciverid: reciverid,
                    layer: layer,
                    who: who,
                    status: true);
              }
            },
            child: Container(
              width: size.width / 2,
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
                child: who != 3
                    ? map['sendBy'] != _auth.currentUser!.displayName
                        ? Column(
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
                                              map['message']);
                                        },
                                        icon: const Icon(Icons.download,
                                            color: Colors.black))
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
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
                                              map['message']);
                                        },
                                        icon: const Icon(Icons.download,
                                            color: Colors.black))
                                  ],
                                ),
                              ),
                            ],
                          )
                    : Column(
                        children: [
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
                                          map['message']);
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
