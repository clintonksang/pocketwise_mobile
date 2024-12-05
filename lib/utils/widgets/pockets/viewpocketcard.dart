import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pockets/utils/constants/colors.dart';
import 'package:pockets/utils/constants/defaultPadding.dart';
import 'package:pockets/utils/constants/textutil.dart';
import 'package:pockets/utils/widgets/pockets/cardButtons.dart';

import '../../../models/pocket.model.dart';

class ViewPocketCard extends StatelessWidget {
   final PocketModel ? args;
  const ViewPocketCard({super.key,   this.args});

  @override


  Widget build(BuildContext context) {
    return Container(
  width: MediaQuery.of(context).size.width,
  height: MediaQuery.of(context).size.width*.900,
  decoration: ShapeDecoration(
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
  child: Padding(padding: EdgeInsets.all(15),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,

    children: [
 
    // Row(
    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //   children: [
    //     Text('pockets.pocket_title'.tr()).normal(color: secondaryColor),
        
    //     Text(args!.cardTitle).normal(color: black),

    //   ],
    // ),
     
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    
    Text('pockets.total_amount'.tr()).normal(color: secondaryColor), 
       RichText(
         text: TextSpan(
           children: <TextSpan>[
             TextSpan(
               text: '${args!.target}',
               style: AppTextStyles.largeBold,
             ),
             TextSpan(
               text: ' ${args!.currency}',
               style: AppTextStyles.normal,
             ),
           ],
         ),
       ),

         CardButtons(
                    cardColor:  primaryColor,
                    text: 'adjust',
                    small: true,
                   ),
  ],
),

      args!.fundedStatus =="funded"?  Container():Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
       Text('pockets.total_saved'.tr()).normal(color: secondaryColor),
        
        Text(args!.current_amount).normal(color: black),

      ],
    ),

     Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('pockets.total_spend'.tr()).normal(color: secondaryColor),
        
        Text(args!.expense).normal(color: black),

      ],
    ),

     Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('pockets.category'.tr()).normal(color: secondaryColor),
        
        Text(args!.category!).normal(color:args!.categoryColor! ),

      ],
    ),
SizedBox(height: defaultPadding,),
     Row(
      mainAxisAlignment:  args!.fundedStatus !="funded"? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
       children: [
        args!.fundedStatus !="funded"?  CardButtons(cardColor: primaryColor, text: 'top up', small: false): Container(),
         CardButtons(cardColor: primaryColor, text: 'pay out', small: false),
       ],
     )

    //  amount
 
    // bottom section

 
    ],
  ),
  ),
);
  }
}