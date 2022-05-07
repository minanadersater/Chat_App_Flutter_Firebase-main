import 'package:chat_app/group_chats/sub_group/group_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../packges/upload_file.dart';
import '../../widgets/massege.dart';

class SubGroupChatRoom extends StatelessWidget {
  final String groupChatId, subgroupChatId, groupName;

  SubGroupChatRoom(
      {required this.groupName,
      required this.groupChatId,
      Key? key,
      required this.subgroupChatId})
      : super(key: key);

  final TextEditingController _message = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static String collection = 'groups';
  final bool status = false;
  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> chatData = {
        "sendBy": _auth.currentUser!.displayName,
        "message": _message.text.trim(),
        "type": "text",
        "time": FieldValue.serverTimestamp(),
        "status": status,
        "docid": "",
      };

      _message.clear();

      DocumentReference doc = await _firestore
          .collection(collection)
          .doc(groupChatId)
          .collection('sub_group')
          .doc(subgroupChatId)
          .collection('chats')
          .add(chatData);

      await _firestore
          .collection(collection)
          .doc(groupChatId)
          .collection('sub_group')
          .doc(subgroupChatId)
          .collection('chats')
          .doc(doc.id)
          .update({"docid": doc.id});
    } else {
      print("Enter Some Text");
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(groupName),
        actions: [
          IconButton(
              onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => SubGroupInfo(
                        groupName: groupName,
                        groupId: groupChatId,
                        subgroupId: subgroupChatId,
                      ),
                    ),
                  ),
              icon: Icon(Icons.more_vert)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: size.height / 1.27,
              width: size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection(collection)
                    .doc(groupChatId)
                    .collection('sub_group')
                    .doc(subgroupChatId)
                    .collection('chats')
                    .orderBy('time')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> map = snapshot.data!.docs[index]
                            .data() as Map<String, dynamic>;
                        return massege().messages(
                          size: size,
                          map: map,
                          context: context,
                          collection: collection,
                          reciverid: groupChatId,
                          layer: subgroupChatId,
                          who: 2, docid: map["docid"],
                        );
                        
                      },
                    );
                  } else {
                    return Container();
                  }
                },
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
                                      chatRoom: groupChatId,
                                      collection: collection,
                                      layer: subgroupChatId,
                                      who: 2,
                                    ),
                                  )),
                              icon: Icon(Icons.file_upload_outlined),
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
    );
  }
}
