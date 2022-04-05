import 'package:chat_app/config/function.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/widgets/textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({Key? key}) : super(key: key);
  var emailController = TextEditingController();
  var nameController = TextEditingController();
  var passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children:
                      [
                        Center(
                          child: Text("Register", style:
                          TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold
                          ),),
                        ),
                        SizedBox(height: 30,),
                        CTextfield(
                          controller: emailController,
                          prefix: Icon(Icons.vpn_key),
                          keyboardType: TextInputType.emailAddress,
                          hint: "enter votre nom",
                        ),
                        SizedBox(height: 30,),
                        CTextfield(
                          controller: emailController,
                          prefix: Icon(Icons.email),
                          keyboardType: TextInputType.emailAddress,
                          hint: "enter votre email",
                        ),
                        SizedBox(height: 30,),
                        CTextfield(
                          controller: passController,
                          prefix: Icon(Icons.vpn_key),
                          keyboardType: TextInputType.emailAddress,
                          hint: "enter password",
                        ),
                        SizedBox(height: 15,),
                        SizedBox(height: 30,),
                        CTextfield(
                          controller: passController,
                          prefix: Icon(Icons.vpn_key),
                          keyboardType: TextInputType.emailAddress,
                          hint: "enter password",
                        ),
                        SizedBox(height: 15,),
                        ElevatedButton(
                          onPressed: () async{
                            await AuthServices().singup(nameController.text, emailController.text,passController.text);
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "login ",
                            style: TextStyle(fontSize: 20),
                          ),
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(vertical: 20))),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("data"),
                            SizedBox(
                              width: 10,
                            ),
                            TextButton(
                                onPressed: () {
                                Navigator.of(context).pop();
                                },
                                child: Text('connexion'))
                          ],
                        )
                      ],
                    )
                )
            )

        )
    );
  }
}
