import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../subcreate_group/add_members.dart';
import '../subcreate_group/sub_group_chat_room.dart';
class drawer extends StatefulWidget {
  const drawer({Key? key, required this.groupChatId, required this.groupName,})
      : super(key: key);
 final String groupChatId, groupName;

  @override
  State<drawer> createState() => _drawerState();
}

class _drawerState extends State<drawer> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = true;
  List groupList = [];
   @override
    void initState() {
    super.initState();
    getAvailableGroups();
  }

  void getAvailableGroups() async {
    String uid = _auth.currentUser!.uid;

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('groups')
        .doc(widget.groupChatId)
        .collection('sub_group')
        .get()
        .then((value) {
      setState(() {
        groupList = value.docs;
        isLoading = false;
      });
    });
  }
   
  Widget build(BuildContext context) {
    return  Drawer(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Title(
                    color: Colors.black,
                    child: Text(widget.groupName,
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 50))),
              ],
            ),
            SizedBox(height: 50),
            IconButton(
                onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            AddMembersInsubGroup(groupChatId: widget.groupChatId),
                      ),
                    ),
                icon: Icon(Icons.create)),
             SingleChildScrollView(
               child: ListView.builder(
                 shrinkWrap: true,
                  itemCount: groupList.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      height: 50,
                      width: 30,
                      child: ListTile(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => SubGroupChatRoom(
                              groupName: groupList[index]['name'],
                              groupChatId: widget.groupChatId,
                              subgroupChatId: groupList[index]['id'],
                            ),
                          ),
                        ),
                        leading: Icon(Icons.group,size: 50),
                        title: Text(groupList[index]['name'],style: TextStyle(fontSize: 20),),
                      ),
                    );
                  },
                ),
             ),
             ],
        ),
      ),
    );
  }
}