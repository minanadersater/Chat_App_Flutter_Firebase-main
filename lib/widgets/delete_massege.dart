import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Up {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future update(
      {required String id,
      required String collection,
      required String receiverid,
      required String layer,
      required int who}) async {
    switch (who) {
      case 1:
        await _firestore
            .collection(collection)
            .doc(receiverid)
            .collection('chats')
            .doc(id)
            .update({
          "status": true,
        });
        break;
      case 2:
        await _firestore
            .collection(collection)
            .doc(receiverid)
            .collection('sub_group')
            .doc(layer)
            .collection('chats')
            .doc(id)
            .update({
          "status": true,
        });
        break;
      case 3:
        await _firestore
            .collection(collection)
            .doc(_auth.currentUser!.uid)
            .collection('chats')
            .doc(receiverid)
            .collection('chats')
            .doc(id)
            .update({
          "status": true,
        });
        await _firestore
            .collection(collection)
            .doc(receiverid)
            .collection('chats')
            .doc(_auth.currentUser!.uid)
            .collection('chats')
            .doc(layer)
            .update({
          "status": true,
        });
        break;
    }
  }
}
