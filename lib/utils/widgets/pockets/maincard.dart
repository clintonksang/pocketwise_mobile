import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocketwise/data/data.dart';
import 'package:pocketwise/models/budget.model.dart';
import 'package:pocketwise/utils/constants/formatting.dart';
import 'package:pocketwise/utils/constants/textutil.dart';
import 'package:pocketwise/utils/widgets/pockets/cardButtons.dart';
import 'package:pocketwise/utils/widgets/pockets/budget/edit_limit.dart';
import 'package:pocketwise/utils/widgets/pockets/textfield.dart';

import '../../../models/categories.model.dart';
import '../../../router/approuter.dart';
import '../../constants/colors.dart';
import '../../functions/timeofday.dart';

class MainCard extends StatefulWidget {
  String ? titleText;
  String ? subtext;
  String ? amount;
  String ? currency;
   Color ? cardcolor;
   String ? buttonText;
  
 
 
    MainCard({
     required this.titleText,
     this.subtext,
     required this.amount,
     required this.buttonText,
     required this.currency,
     required this.cardcolor ,
    
   
    super.key});

  @override
  State<MainCard> createState() => _MainCardState();
}

class _MainCardState extends State<MainCard> {
  @override
  Widget build(BuildContext context) {
    return  
    Container(
  width: MediaQuery.of(context).size.width*.44,
  height: MediaQuery.of(context).size.width*.22,
  decoration: ShapeDecoration(
    color: widget.cardcolor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
    ),
  ),
  child: Padding(padding: EdgeInsets.all(15),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,

    children: [

    Align(
                    alignment: Alignment.topLeft,

      child: RichText(
        text: TextSpan(
          children: <TextSpan>[
             TextSpan(
              text: ' ${widget.currency} ',
              style: AppTextStyles.normal.copyWith(color: white),
            ),
            TextSpan(
              text: toLocaleString(double.parse(widget.amount!)),
              style: AppTextStyles.largeBold.copyWith(color: white),
            ),
           
          ],
        ),
      ),
    ),
      // top
    Align(
              alignment: Alignment.topLeft,
              child: Text(widget.titleText!).bold(color: white)),
 
   
    
    ],
  ),
  ),
);
  }
}
 

 



//  

class CardBudget extends StatefulWidget {
  String ? title;
 
  double ? limit_amount;
  double ? limit_rate;
  String ? currency;
   Color ? categoryColor;
   String ? buttonText;
  //  CategoriesModel  ?categoriesModel;
  
 
 
    CardBudget({
     required this.title,
   
     required this.limit_amount,
     required this.buttonText,
     required this.currency,
     required this.categoryColor ,
     required this.limit_rate,
    
   
    super.key});

  @override
  State<CardBudget> createState() => _CardBudgetState();
}

class _CardBudgetState extends State<CardBudget> {

  @override
  Widget build(BuildContext context) {
   return Padding(
     padding: const EdgeInsets.all(8.0),
     child: Container(
       width: MediaQuery.of(context).size.width*.25,
       height: 100,
       decoration: BoxDecoration(
      color: widget.categoryColor  ,
      borderRadius: BorderRadius.circular(18),
      shape:  BoxShape.rectangle,
       ),
       child: Padding(padding: EdgeInsets.all(15),
       child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
     
      children: [
      Row(
        children: [
          Align(
                    alignment: Alignment.topLeft,
                    child: Text(widget.title!).bold(color: white)),
          Spacer(),
         GestureDetector(
                          onTap: () {
                             showModalBottomSheet(context: context, builder: (context){
                                                return EditLimit(
                                                   limitAmount: widget.limit_amount !,
                                                   title: widget.title!,
                                                   type: widget.title!,
                                                );
                                              });
                          },
                          child: Image.asset(
                            'assets/images/edit.png',
                            width: 20,
                            height: 20,
                      
                          ),
                        ),
        ],
      ),
       Align(
                    alignment: Alignment.topLeft,
                    child: Text('Limit: ${widget.limit_rate}% of income').smallLight(color: white)),
      Align(
                      alignment: Alignment.centerLeft,
     
        child: RichText(
          text: TextSpan(
            children: <TextSpan>[
               TextSpan(
                text: 'Total ${widget.currency} ',
                style: AppTextStyles.normal.copyWith(color: white),
              ),
              TextSpan(
                text: toLocaleString(double.parse(widget.limit_amount!.toString())),
                style: AppTextStyles.largeBold.copyWith(color: white),
              ),
             
            ],
          ),
        ),
      ),
        // top
     
      
     
      
      ],
       ),
       ),
     ),
   );

  // int percentage =  widget.categoriesModel!.limit_amount_rate!.toInt();

  
    // Padding(
    //   padding: const EdgeInsets.all(8.0),
    //   child: Container(
    //     width: MediaQuery.of(context).size.width*.25,
    //     height: 10,
    //     decoration: ShapeDecoration(
    //   color: widget.categoryColor,
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(18),
    //   ),
    //     ),
    //     child: Padding(padding: EdgeInsets.all(2),
        // child: Column(
        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      
        //   children: [
      
        //     // top
        //   Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
          
        //       Align(
        //                 alignment: Alignment.topLeft,
        //                 child: Text(
                      
        //                  widget.title! == "savings & investments" ? "savings &\ninv -${widget.limit_rate}%" :"${ widget.title!}- ${widget.limit_rate}%",
        //                   style: AppTextStyles.bold.copyWith(color: white,
        //                   fontSize: 16
        //                   ),
        //                   )
                    
        //                 ),
        //                 GestureDetector(
        //                   onTap: () {
        //                      showModalBottomSheet(context: context, builder: (context){
        //                                         return EditLimit(
        //                                            amount: widget.limit_amount!.toString(),
        //                                            title: widget.title!,
        //                                         );
        //                                       });
        //                   },
        //                   child: Image.asset(
        //                     'assets/images/edit.png',
        //                     width: 20,
        //                     height: 20,
                      
        //                   ),
        //                 ),
        //     ],
        //   ),
        //      //  amount
        //   Align(
        //                   alignment: Alignment.topLeft,
      
        //     child: RichText(
        //       text: TextSpan(
        //         children: <TextSpan>[
        //            TextSpan(
        //             text: ' ${widget.currency} ',
        //             style: AppTextStyles.light.copyWith(color: white, fontSize: 15, fontWeight: FontWeight.w300),
        //           ),
        //            TextSpan(
      
        //             // - ${ categoriesModel!.limit_amount_rate.toString()} 
        //             text: "${toLocaleString(double.parse(widget.limit_amount!.toString() ) )} ",
        //             style: AppTextStyles.largeBold.copyWith(color: white),
        //           ),
      
              
             
             
        //         ],
        //       ),
        //     ),
        //   ),
      
       
         
      
        //   ],
        // ),
      //   ),
      // ),
    // );
  }
}
 

 