
import 'package:flutter/material.dart';
import 'package:pocketwise/utils/constants/textutil.dart';

class CardButtons extends StatelessWidget {
    Color ? cardColor;
    String ? text;
    bool ? small;
    // textcolor, default white
    Color ? textcolor;

   CardButtons({super.key, required this.cardColor, required this.text, required this.small ,this.textcolor = Colors.white });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 30),
      child: Container(
        constraints: const BoxConstraints(minWidth: 50),
        height:  small!? 25: 28,
        // width:small!?  MediaQuery.of(context).size.width*.16: MediaQuery.of(context).size.width*.32,
        decoration: ShapeDecoration(
      color: cardColor, 
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 1, color:cardColor!),
        borderRadius: BorderRadius.circular(10),
      ),
        ),
        child: Center(child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(text!, 
                    style: small!? 
                    AppTextStyles.smallLight.copyWith(color: textcolor , fontWeight: FontWeight.w300):
                    AppTextStyles.medium.copyWith(color: textcolor, fontWeight: FontWeight.bold)
                     
                     ,
            
            ),
          ),
        )),  
      ),
    );
  }
}