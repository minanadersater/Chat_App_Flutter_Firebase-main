import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddMembersINSubGroup extends StatefulWidget {
  final String groupChatId, name, subgroupId;
  final List membersList;
  const AddMembersINSubGroup(
      {required this.name,
      required this.membersList,
      required this.groupChatId,
      Key? key, required this.subgroupId})
      : super(key: key);

  @override
  _AddMembersINSubGroupState createState() => _AddMembersINSubGroupState();
}

class _AddMembersINSubGroupState extends State<AddMembersINSubGroup> {
  final TextEditingController _search = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? userMap;
  bool isLoading = false;
  List membersList = [];
  List membersListadd = [];

  @override
  void initState() {
    super.initState();
    membersList = widget.membersList;
  }

  void onSearch() async {
    setState(() {
      isLoading = true;
    });
    await _firestore
        .collection('groups')
        .doc(widget.groupChatId)
        .get()
        .then((chatMap) {
      membersListadd = chatMap['members'];
      setState(() {});
    });
    for (int i = 0; i < membersListadd.length; i++) {
      if (membersListadd[i]["email"] == _search.text.trim()) {
        setState(() {
          userMap = membersListadd[i];
        });
      }
    }
  }

  void onAddMembers() async {
    bool isAlreadyExist = false;

    for (int i = 0; i < membersList.length; i++) {
      if (membersList[i]['uid'] == userMap!['uid']) {
        isAlreadyExist = true;
      }
    }

    if (!isAlreadyExist) {
      setState(() {
        membersList.add({
          "name": userMap!['name'],
          "email": userMap!['email'],
          "uid": userMap!['uid'],
          "isAdmin": false,
        });

       
      });
    }
    await _firestore
    .collection('groups')
    .doc(widget.groupChatId)
    .collection('sub_group')
    .doc(widget.subgroupId)
    .update({
      "members": membersList,
    });

    await _firestore
        .collection('users')
        .doc(userMap!['uid'])
        .collection('groups')
        .doc(widget.groupChatId)
        .collection('sub_group')
        .doc(widget.subgroupId)
        .set({"name": widget.name, "id": widget.groupChatId});
 
  } 

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Members"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: size.height / 20,
            ),
            Container(
              height: size.height / 14,
              width: size.width,
              alignment: Alignment.center,
              child: Container(
                height: size.height / 14,
                width: size.width / 1.15,
                child: TextField(
                  controller: _search,
                  decoration: InputDecoration(
                    hintText: "Search",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: size.height / 50,
            ),
            isLoading
                ? Container(
                    height: size.height / 12,
                    width: size.height / 12,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  )
                : ElevatedButton(
                    onPressed: onSearch,
                    child: Text("Search"),
                  ),
            userMap != null
                ? ListTile(
                    onTap: onAddMembers,
                    leading: Icon(Icons.account_box),
                    title: Text(userMap!['name']),
                    subtitle: Text(userMap!['email']),
                    trailing: Icon(Icons.add),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
