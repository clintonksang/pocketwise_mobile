import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pockets/models/categories.model.dart';
import 'package:pockets/router/approuter.dart';
import 'package:pockets/utils/constants/defaultPadding.dart';
import 'package:pockets/utils/constants/textutil.dart';
import 'package:pockets/utils/widgets/pockets/cardButtons.dart';

import '../../../models/pocket.model.dart';
import '../../constants/colors.dart';
import '../../constants/formatting.dart';
class TrackerCard extends StatefulWidget {
  final CategoriesModel? categoriesModel;
  
  TrackerCard({
    required this.categoriesModel, 
    super.key
  });

  @override
  State<TrackerCard> createState() => _TrackerCardState();
}

class _TrackerCardState extends State<TrackerCard> {
  Color progressColor = greencolor;
 

  double getPercentage(double current, double limit, double limitRate) {
    if (limit == 0) return 0;
    double rate = (current / limit) * limitRate;
    progressColor = rate <= 50 ? greencolor : rate <= 75 ? Colors.amber : red;
    return rate;
  }

  double getRatePercentage(double current, double limit) {
    if (limit == 0) return 0;
    double rate = (current / limit) * 100;
    progressColor = rate <= 50 ? greencolor : rate <= 75 ? Colors.amber : red;
    return rate;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.categoriesModel == null) {
       
      return Expanded(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(18.0),
            border: Border.all(width: 1.0, color: Colors.grey),
          ),
          child: Center(
            child: Text(
              'No data available',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }

    final ValueNotifier<double> _valueNotifier = ValueNotifier(0);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, AppRouter.viewCategory, arguments: widget.categoriesModel);
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 1.0, color: backgroundColor),
              borderRadius: BorderRadius.circular(18.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Title
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      widget.categoriesModel!.title == 'savings & investments' ? 'sav/inv' : widget.categoriesModel!.title,
                    ).medium(color: black, fontWeight: FontWeight.bold),
                  ),
                  
                  // Circular Progress Bar
                  DashedCircularProgressBar.aspectRatio(
                    aspectRatio: .6,
                    valueNotifier: _valueNotifier,
                    progress: getRatePercentage(
                      widget.categoriesModel!.current_amount,
                      widget.categoriesModel!.total_expense == 0 ? 1 : widget.categoriesModel!.total_expense,
                    ),
                    startAngle: 0,
                    sweepAngle: 360,
                    foregroundColor: progressColor,
                    backgroundColor: const Color(0xffeeeeee),
                    foregroundStrokeWidth: 10,
                    backgroundStrokeWidth: 10,
                    animation: true,
                    animationCurve: Curves.easeIn,
                    animationDuration: Duration(seconds: 1),
                    seekSize: 6,
                    seekColor: const Color(0xffeeeeee),
                    child: Center(
                      child: ValueListenableBuilder(
                        valueListenable: _valueNotifier,
                        builder: (_, double value, __) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${getPercentage(widget.categoriesModel!.current_amount, widget.categoriesModel!.total_expense, widget.categoriesModel!.limit_amount_rate).toInt()}/${widget.categoriesModel!.limit_amount_rate.toInt()}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 9,
                              ),
                            ),
                            const Text(
                              'percent',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Currency Display
                  Text(
                    'kes \n${toLocaleString(widget.categoriesModel!.current_amount)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Bottom Button
                  CardButtons(
                    cardColor: black,
                    text: 'view',
                    small: false,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
