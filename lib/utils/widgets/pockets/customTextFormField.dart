import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class FieldItems extends StatelessWidget {
  final String hintText;
  final TextInputType inputType;
  final bool isBorderVisible;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText; // New parameter for password obscurity

  const FieldItems({
    Key? key,
    required this.hintText,
    required this.inputType,
    this.keyboardType = TextInputType.text,
    this.isBorderVisible = true,
    required this.controller,
    this.validator,
    this.obscureText = false, // Default value is false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Align(
        alignment: Alignment.topCenter,
        child: TextFormField(
          controller: controller,
          keyboardType: inputType,
          obscureText: obscureText, // Apply the obscureText property
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            border: isBorderVisible ? OutlineInputBorder() : InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey),
            focusedBorder: isBorderVisible ? OutlineInputBorder() : InputBorder.none,
            enabledBorder: isBorderVisible ? OutlineInputBorder() : InputBorder.none,
          ),
        ),
      ),
    );
  }
}
