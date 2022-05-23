import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../packges/upload_file.dart';
import '../widgets/massege.dart';

class ChatRoom extends StatelessWidget {
  final String reciverId, currentReciverName;
  ChatRoom({required this.reciverId, required this.currentReciverName});
  final TextEditingController _message = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final bool status = false;
  static String collection = 'chatroom';
  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sendBy": _auth.currentUser!.displayName,
        "message": _message.text.trim(),
        "type": "text",
        "time": FieldValue.serverTimestamp(),
        "status": status,
        "docid1": "",
        "docid2": "",
      };

      _message.clear();
      DocumentReference doc1 = await _firestore
          .collection(collection)
          .doc(_auth.currentUser!.uid)
          .collection('chats')
          .doc(reciverId)
          .collection('chats')
          .add(messages);

      DocumentReference doc2 = await _firestore
          .collection(collection)
          .doc(reciverId)
          .collection('chats')
          .doc(_auth.currentUser!.uid)
          .collection('chats')
          .add(messages);
      await _firestore
          .collection(collection)
          .doc(_auth.currentUser!.uid)
          .collection('chats')
          .doc(reciverId)
          .collection('chats')
          .doc(doc1.id)
          .update({"docid1": doc1.id, "docid2": doc2.id});
      await _firestore
          .collection(collection)
          .doc(reciverId)
          .collection('chats')
          .doc(_auth.currentUser!.uid)
          .collection('chats')
          .doc(doc2.id)
          .update({"docid1": doc1.id, "docid2": doc2.id});
    } else {
      print("Enter Some Text");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<DocumentSnapshot>(
          stream: _firestore.collection("users").doc(reciverId).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return Container(
                child: Column(
                  children: [
                    Text(currentReciverName),
                    Text(
                      snapshot.data!['status'],
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SafeArea(
                child: Container(
                  height: size.height / 1.25,
                  width: size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('chatroom')
                        .doc(_auth.currentUser!.uid)
                        .collection('chats')
                        .doc(reciverId)
                        .collection('chats')
                        .orderBy("time", descending: false)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.data != null) {
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> map =
                                snapshot.data!.docs[index].data()
                                    as Map<String, dynamic>;
                            return Massege().messages(
                              size: size,
                              map: map,
                              context: context,
                              collection: collection,
                              reciverid: reciverId,
                              layer: map["docid2"],
                              who: 3,
                              docid: map["docid1"],
                            );
                          },
                        );
                      } else {
                        return Container(
                          height: size.height / 10,
                          width: size.width,
                        );
                      }
                    },
                  ),
                ),
              ),
              Container(
                height: size.height / 10,
                width: size.width,
                alignment: Alignment.center,
                child: Container(
                  height: size.height / 12,
                  width: size.width / 1.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: size.height / 17,
                        width: size.width / 1.3,
                        child: TextField(
                          controller: _message,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UploadFile(
                                        chatRoom: reciverId,
                                        collection: collection,
                                        layer: reciverId,
                                        who: 3,
                                      ),
                                    )),
                                icon: Icon(Icons.photo),
                              ),
                              hintText: "Send Message",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              )),
                        ),
                      ),
                      IconButton(
                          icon: Icon(Icons.send), onPressed: onSendMessage),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
