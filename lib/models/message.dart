import 'package:chat_app/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Message{
  String? content;
  String? uid;
  String? senderUID;
  String? reciverUID;
  Timestamp? createAt;
  Message.fromJson(Map<String,dynamic>json,String id){
    uid =id;
    content=json['content'];
    senderUID = json ['senderUID'];
    reciverUID = json['reciverUID'];
    createAt = json['createAt'];
  }
  Map<String,dynamic>toJson(){
    return{
      'createAt':createAt,
      'reciverUID':reciverUID,
      'senderUID':senderUID,
      'content':content
    };
  }
  bool get isMe => AuthServices().user.uid==senderUID;
}