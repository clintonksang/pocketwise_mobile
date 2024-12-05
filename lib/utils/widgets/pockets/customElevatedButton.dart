import 'package:flutter/material.dart';
import 'package:pockets/utils/constants/colors.dart';
import 'package:pockets/utils/constants/textutil.dart';


class Customelevatedbutton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? color;
   final Color? textcolor;
  const Customelevatedbutton({super.key, required this.text,  required this.onPressed, this.textcolor, this.color =Colors.deepPurple });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration: ShapeDecoration(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: Center(
      child: Text(text, style: AppTextStyles.medium.copyWith(color: textcolor, fontWeight: FontWeight.bold),),
        ),
      ),
    );
  }
}