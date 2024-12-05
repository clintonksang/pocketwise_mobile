
import 'package:flutter/material.dart';
import 'package:pockets/utils/constants/textutil.dart';

class CardButtons extends StatelessWidget {
    Color ? cardColor;
    String ? text;
    bool ? small;

   CardButtons({super.key, required this.cardColor, required this.text, required this.small});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 30),
      child: Container(
        constraints: const BoxConstraints(minWidth: 50),
        height:  small!? 20: 30,
        width:small!?  MediaQuery.of(context).size.width*.22: MediaQuery.of(context).size.width*.32,
        decoration: ShapeDecoration(
      color: cardColor, 
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 1, color:cardColor!),
        borderRadius: BorderRadius.circular(5),
      ),
        ),
        child: Center(child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Text(text!, 
        style: small!? 
        AppTextStyles.smallLight.copyWith(color: Colors.white, fontWeight: FontWeight.w300):
        AppTextStyles.medium.copyWith(color: Colors.white, fontWeight: FontWeight.bold)
         
         ,
          
          ),
        )),  
      ),
    );
  }
}