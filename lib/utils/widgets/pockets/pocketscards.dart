import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pocketwise/router/approuter.dart';
import 'package:pocketwise/utils/constants/defaultPadding.dart';
import 'package:pocketwise/utils/constants/textutil.dart';
import 'package:pocketwise/utils/widgets/pockets/cardButtons.dart';

import '../../../models/expensecardmodel.dart';
import '../../../models/pocket.model.dart';
import '../../constants/colors.dart';
import '../../constants/formatting.dart';

class ExpenseCard extends StatelessWidget {
  ExpenseModel? expenseModel;
  // String cardTitle;
  // String amount;
  // String currency;
  // String date;
  // String fundedStatus;
  // String category;
  // Color categoryColor;
    ExpenseCard({
      required this.expenseModel, 
    super.key});
  
   @override
   Widget build(BuildContext context) {
    return GestureDetector(
       onTap: () {
          print('View Pocket');
            Navigator.pushNamed(context, AppRouter.viewPocket, arguments: expenseModel);

          },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width * .25,
          decoration: ShapeDecoration(
            color: containerColors,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                         
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text(expenseModel!.title).normal()),
                        ],
                      ),
                      
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            
                          Align(
                            alignment: Alignment.topRight,
                          
                                child: RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:  expenseModel!.amount.toString() ,
                                        style: AppTextStyles.normal.copyWith(fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                        text: 'kes',
                                        style: AppTextStyles.normal,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        ],
                      ),
                    ],
                  ),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                    
        
                     CardButtons(cardColor: getColor(expenseModel!.pocket), text: expenseModel!.pocket!, small: true),
                    
                               Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                               expenseModel!.date, style: AppTextStyles.smallLight.copyWith(
                                
                                
                                color: secondaryColor,
                                
                              ),)
                              ),
                   ],
                 )
                ]
                ),
          ),
        ),
      ),
    );
  }
}
