import 'package:chat_app/Authenticate/Methods.dart';
import 'package:chat_app/Screens/ChatRoom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreen createState() => _SearchScreen();
}

class _SearchScreen extends State<SearchScreen> with WidgetsBindingObserver {
  Map<String, dynamic>? userMap;
  List chatrooms = [];
  bool isLoading = false, alreadyexist = false;
  final TextEditingController _search = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    setStatus("Online");
  }

  void setStatus(String status) async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      "status": status,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // online
      setStatus("Online");
    } else {
      // offline
      setStatus("Offline");
    }
  }

  Future<void> ontap() async {
    setState(() {
      isLoading = true;
    });
    await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('chatrooms')
        .get()
        .then((value) {
      setState(() {
        chatrooms = value.docs;
        isLoading = false;
      });
    });

    for (int i = 0; i < chatrooms.length; i++) {
      if (chatrooms[i]['id'] == userMap!['uid']) {
        alreadyexist = true;
      }
    }
    if (alreadyexist == true) {
      Navigator.pop(context);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ChatRoom(
            reciverId: userMap!['uid'],
            currentReciverName: userMap!['name'],
          ),
        ),
      );
    } else {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('chatrooms')
          .doc(userMap!['uid'])
          .set({
        "name": userMap!['name'],
        "id": userMap!['uid'],
      });
      Navigator.pop(context);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ChatRoom(
            reciverId: userMap!['uid'],
            currentReciverName: userMap!['name'],
          ),
        ),
      );
    }
  }

  void onSearch() async {
    setState(() {
      isLoading = true;
    });
    if (_search.text.isNotEmpty) {
      await _firestore
          .collection('users')
          .where("email", isEqualTo: _search.text.trim())
          .get()
          .then((value) {
        setState(() {
          userMap = value.docs[0].data();
          isLoading = false;
        });
        print(userMap);
      });
    } else {
      isLoading = false;
      return;
    }
  }

  logout() {
    setStatus("Offline");
    logOut(context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
        actions: [
          IconButton(icon: Icon(Icons.logout), onPressed: () => logout())
        ],
      ),
      body: isLoading
          ? Center(
              child: Container(
                height: size.height / 20,
                width: size.height / 20,
                child: CircularProgressIndicator(),
              ),
            )
          : Column(
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
                ElevatedButton(
                  onPressed: onSearch,
                  child: Text("Search"),
                ),
                SizedBox(
                  height: size.height / 30,
                ),
                userMap != null
                    ? ListTile(
                        onTap: ontap,

                        //
                        leading: Icon(Icons.account_box, color: Colors.black),
                        title: Text(
                          userMap!['name'],
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(userMap!['email']),
                        trailing: Icon(Icons.chat, color: Colors.black),
                      )
                    : Container(),
              ],
            ),
    );
  }
}
