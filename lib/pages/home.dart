import 'package:chat_app/config/function.dart';
import 'package:chat_app/models/users.dart';
import 'package:chat_app/pages/chat.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/db_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
              onPressed:()async{
                  await AuthServices().signOut();
              },

          icon: Icon(Icons.logout))
        ],
      ),
      body: StreamBuilder<List<CUser>>(
        stream: DBServices().getDiscussionUser,
          builder: (_,s){
            if (s.hasData){
              final users=s.data;
              return users!.length==0
                  ?Center(
                    child:Text("Acune discussion") ,
              )
                  : ListView.builder(
                    itemCount: users.length,
                   itemBuilder:(ctx,i){
                      final user =users[i];
                      return  ListTile(
                  onTap: (){
                    navigateToNextPage(context, ChatPage(
                      user: user,
                    ));
                  },
                  leading: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      shape:BoxShape.circle,
                      color: Colors.grey.withOpacity(.5)
                    ),
                    child: Icon(Icons.person),
                  ),
                  title: Text(user.name!),
                  subtitle: Text(user.email!),
                );
              });
            }else{
              return Center(
                child: CircularProgressIndicator()
              );
            }
        }),
    );
  }
}
