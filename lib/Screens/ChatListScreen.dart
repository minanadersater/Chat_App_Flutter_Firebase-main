import 'package:chat_app/Screens/ChatRoom.dart';
import 'package:chat_app/Screens/SearchScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Authenticate/Methods.dart';
import '../group_chats/group/group_chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  ChatListScreenState createState() => ChatListScreenState();
}

class ChatListScreenState extends State<ChatListScreen>
    with WidgetsBindingObserver {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = true;



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

  logout() {
    setStatus("Offline");
    logOut(context);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Chats"),
        actions: [
          IconButton(
              onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => SearchScreen(),
                    ),
                  ),
              icon: Icon(Icons.search)),
          IconButton(
              onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => GroupChatHomeScreen(),
                    ),
                  ),
              icon: Icon(Icons.group)),
          IconButton(icon: Icon(Icons.logout), onPressed: () => logout()),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: size.height / 1.25,
              width: size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('users')
                    .doc(_auth.currentUser!.uid)
                    .collection('chatrooms')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data != null) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                          Map<String, dynamic> map = snapshot.data!.docs[index]
                            .data() as Map<String, dynamic>;
                        return ListTile(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ChatRoom(
                                reciverId: map['id'],
                                currentReciverName: map['name'],
                              ),
                            ),
                          ),
                          leading: Icon(Icons.person),
                          title: Text(map['name']),
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
                height: size.height,
                width: size.width,
                alignment: Alignment.center,
                child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
