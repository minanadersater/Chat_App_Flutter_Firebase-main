import 'package:flutter/material.dart';

class CTextfield extends StatelessWidget {
  final TextEditingController?controller;
  final String? hint;
  final Widget? prefix;
  final bool? obscureText;
  final TextInputType? keyboardType;
  const CTextfield({Key? key,this.controller,this.hint,this.prefix,
    this.keyboardType,this.obscureText=false})
  :super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller:controller,
      obscureText:obscureText!,
      decoration:InputDecoration(
        prefixIcon:  prefix ,
        hintText: hint??''),
      keyboardType: keyboardType,

    );
  }
}
