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
import '../../constants/defaultPadding.dart';

class MainCard extends StatelessWidget {
  final String titleText;
  final String amount;
  final String currency;
  final String? subtext;
  final Color cardcolor;
  final String buttonText;
  final int? sourceCount;
  final VoidCallback? onViewPressed;

  const MainCard({
    Key? key,
    required this.titleText,
    required this.amount,
    required this.currency,
    this.subtext,
    required this.cardcolor,
    required this.buttonText,
    this.sourceCount,
    this.onViewPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .44,
      height: MediaQuery.of(context).size.width * .25,
      decoration: ShapeDecoration(
        color: cardcolor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(12, 12, 12, 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  titleText,
                  style: AppTextStyles.normal.copyWith(
                    color: Colors.white,
                  ),
                ),
                if (sourceCount != null)
                  Text(
                    'home.income_sources'
                        .tr(namedArgs: {'count': sourceCount.toString()}),
                    style: AppTextStyles.normal.copyWith(
                      color: Colors.white70,
                      fontSize: 9,
                    ),
                  ),
              ],
            ),
            Row(
              children: [
                Text(
                  currency,
                  style: AppTextStyles.normal.copyWith(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                SizedBox(width: 2),
                Text(
                  toLocaleString(double.parse(amount)),
                  style: AppTextStyles.largeBold.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  buttonText,
                  style: AppTextStyles.normal.copyWith(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
                if (onViewPressed != null)
                  GestureDetector(
                    onTap: onViewPressed,
                    child: Text(
                      'home.view'.tr(),
                      style: AppTextStyles.normal.copyWith(
                        color: Colors.white,
                        fontSize: 10,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CardBudget extends StatefulWidget {
  String? title;

  double? limit_amount;
  double? limit_rate;
  String? currency;
  Color? categoryColor;
  String? buttonText;
  //  CategoriesModel  ?categoriesModel;

  CardBudget(
      {required this.title,
      required this.limit_amount,
      required this.buttonText,
      required this.currency,
      required this.categoryColor,
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
        width: MediaQuery.of(context).size.width * .25,
        height: 100,
        decoration: BoxDecoration(
          color: widget.categoryColor,
          borderRadius: BorderRadius.circular(18),
          shape: BoxShape.rectangle,
        ),
        child: Padding(
          padding: EdgeInsets.all(15),
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
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return EditLimit(
                              limitAmount: widget.limit_amount!,
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
                  child: Text('Limit: ${widget.limit_rate}% of income')
                      .smallLight(color: white)),
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
                        text: toLocaleString(
                            double.parse(widget.limit_amount!.toString())),
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
