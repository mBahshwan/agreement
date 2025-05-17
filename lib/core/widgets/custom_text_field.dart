import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String lableText;
  final TextInputType textInputType;
  final bool obscureText;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final Function(String)? onChanged;
  const CustomTextField(
      {super.key,
      required this.lableText,
      this.textInputType = TextInputType.text,
      this.obscureText = false,
      required this.controller,
      this.onChanged,
      this.prefixIcon});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        labelText: lableText,
        border: OutlineInputBorder(),
      ),
      keyboardType: textInputType,
      obscureText: obscureText,
      onChanged: onChanged,
    );
  }
}
