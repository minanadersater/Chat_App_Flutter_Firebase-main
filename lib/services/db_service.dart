import 'package:chat_app/models/message.dart';
import 'package:chat_app/models/users.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DBServices{
  var userCollection =FirebaseFirestore.instance.collection('Users');
  var msgCollection =FirebaseFirestore.instance.collection('Messages');
  saveUser(CUser user){
    try{
      userCollection.doc(user.uid).set(user.toJson());

  }catch(e){}
  }
  Stream<List<CUser>>get getDiscussionUser{

      return userCollection
          .where('uid',isNotEqualTo: AuthServices().user.uid)
          .snapshots()
          .map((event) =>
          event.docs.map((e)=>CUser.fromJson(e.data())).toList());
  }
  Stream<List<Message>>getMessage (String reciverUID,[bool myMessage =true]){
    return msgCollection
        .where('senderUID',isNotEqualTo: myMessage?AuthServices().user.uid:reciverUID)
        .where('reciverUID',isEqualTo:myMessage? reciverUID:AuthServices().user.uid)
        .snapshots()
        .map((event) =>
        event.docs.map((e) =>Message.fromJson(e.data(), e.id)).toList());
  }
  Future <bool> sendMessage(Message msg)async{
    try{
      await msgCollection.doc().set(msg.toJson());
      return true;
    }catch(e){
      return false;
    }
  }

}
