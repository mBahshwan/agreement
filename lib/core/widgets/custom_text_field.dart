import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String lableText;
  final TextInputType textInputType;
  final bool obscureText;
  final TextEditingController? controller;
  const CustomTextField({
    super.key,
    required this.lableText,
    this.textInputType = TextInputType.text,
    this.obscureText = false,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: lableText,
        border: OutlineInputBorder(),
      ),
      keyboardType: textInputType,
      obscureText: obscureText,
    );
  }
}
