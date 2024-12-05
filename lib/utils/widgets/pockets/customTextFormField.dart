import 'package:flutter/material.dart';

class FieldItems extends StatelessWidget {
  final String hintText;
  final TextInputType inputType;
  final bool isBorderVisible;
  final TextEditingController controller;
  final String? Function(String?)? validator;  

  const FieldItems({
    Key? key,
    required this.hintText,
    required this.inputType,
    this.isBorderVisible = true,
    required this.controller,
    this.validator, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
 
      child: Align(
        alignment: Alignment.topCenter,
        child: TextFormField(
          controller: controller,
          keyboardType: inputType,
          validator: validator,  
          decoration: InputDecoration(
            hintText: hintText,
            border: isBorderVisible
                ? OutlineInputBorder()
                : InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey),
            focusedBorder: isBorderVisible
                ? OutlineInputBorder()
                : InputBorder.none,
            enabledBorder: isBorderVisible
                ? OutlineInputBorder()
                : InputBorder.none,
          ),
        ),
      ),
    );
  }
}
