import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pocketwise/models/budget.model.dart';
import 'package:pocketwise/models/categories.model.dart';
import 'package:pocketwise/router/approuter.dart';
import 'package:pocketwise/utils/constants/defaultPadding.dart';
import 'package:pocketwise/utils/constants/textutil.dart';
import 'package:pocketwise/utils/widgets/pockets/budget/edit_limit.dart';
import 'package:pocketwise/utils/widgets/pockets/cardButtons.dart';
import 'package:pocketwise/utils/widgets/pockets/maincard.dart';
import 'package:provider/provider.dart';

import '../../../../models/pocket.model.dart';
import '../../../../provider/income_provider.dart';
import '../../../../repository/budget.repo.dart';
import '../../../constants/colors.dart';
import '../../../constants/formatting.dart';
class BudgetCard extends StatefulWidget {
 
  
  BudgetCard({
   
    super.key
  });

  @override
  State<BudgetCard> createState() => _BudgetCardState();
}

class _BudgetCardState extends State<BudgetCard> {
  Color progressColor = greencolor;
  bool hasBudget = false;
 

  @override
  Widget build(BuildContext context) {
     BudgetRepository budgetRepository = BudgetRepository();
 
    //  final budgetRepository = Provider.of<BudgetRepository>(context);
 final IncomeProvider incomeProvider = Provider.of<IncomeProvider>(context);
   
    if (hasBudget) {
       
      return Expanded(
        child: Container(
        
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
          
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, AppRouter.add_income);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'home.no_budget'.tr(),
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: heightPadding),
                Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: CardButtons(cardColor: black , text: 'add income', small: false))
              ],
            ),
          ),
        ),
      );
    } else{
   
    return Consumer<BudgetRepository>(
      builder: (context, budgetRepository, child) {
        budgetRepository.initializeIfNeeded(context, );
       print("Building BudgetCard with ${budgetRepository.categories.length} categories"); // Debug print

        
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemCount: budgetRepository.categories.length,
          itemBuilder: (context, index) {
            final category = budgetRepository.categories[index];
                       print("Building card for ${category.type} with rate ${category.limitRate}"); // Debug print

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditLimit(
                      type: category.type,
                      limitAmount: category.limitAmount,
                      title: category.title,
                    ),
                  ),
                );
              },
              child: CardBudget(
                title: category.title,
                limit_amount: category.limitAmount,
                limit_rate: category.limitRate,
                currency: "KES",   
                categoryColor: category.BudgetCategoryColor,
                buttonText: "View Details",
                
              ),
            );
          },
        );
      },
    );
  
    //  return  GridView.builder(
    //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
    //   itemCount: budgetRepository.categories.length,
      
    //   itemBuilder: (context, index) {
    //     final category = budgetRepository.categories[index];
    //     return CardBudget(
          
    //       title: category.title,
    //       limit_amount: category.limitAmount,
    //       limit_rate: category.limitRate,
    //       currency: "KES",   
    //       categoryColor: category.BudgetCategoryColor,
    //       buttonText: "View Details",  // Adjust as needed
    //     );
    //   },
    // );
    }

    // final ValueNotifier<double> _valueNotifier = ValueNotifier(0);

    // return Padding(
    //   padding: const EdgeInsets.all(2.0),
    //   child: GridView.builder(
    //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
    //   itemCount: budgetRepository.categories.length,
    //   itemBuilder: (context, index) {
    //     final category = budgetRepository.categories[index];
    //     return CardBudget(
    //       title: category.title,
    //       limit_amount: category.limitAmount,
    //       limit_rate: category.limitRate,
    //       currency: "KES",   
    //       categoryColor: primaryColor,
    //       buttonText: "View Details",  // Adjust as needed
    //     );
    //   },
    // )
    //   // GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3), itemBuilder: (){})
      
    //   //  GestureDetector(
    //   //   onTap: () {
    //   //     // Navigator.pushNamed(context, AppRouter.viewBudget, arguments: widget.categoriesModel![0]);
    //   //   },
    //     // child: 
    
    //   //  Column(
    //   //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //   //   children: [
    //   //     Row(
    //   //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //   //       children: [
     
       
    //     // CardBudget(limit_amount: widget.categoriesModel![0]!.total_expense.toString(), cardcolor: needsColor,buttonText: 'pockets.needs'.tr(),currency: 'kes',title:'pockets.needs'.tr(),subtext: '' , categoriesModel: widget.categoriesModel![0],),
    //   //         // CardBudget(amount: widget.categoriesModel![1]!.total_expense.toString(), cardcolor: wantsColor,buttonText: 'pockets.wants'.tr(),currency: 'kes',titleText:'pockets.wants'.tr(),subtext: '' ,categoriesModel: widget.categoriesModel![1],)
    //   //       ],
    //   //     ),
    //   //      Row(
    //   //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //   //       children: [
    //   //         // CardBudget(amount: widget.categoriesModel![2].total_expense.toString(), cardcolor: sandicolor,buttonText: 'pockets.savings'.tr(),currency: 'kes',titleText:'pockets.savings'.tr(),subtext: '' ,categoriesModel: widget.categoriesModel![2],),
    //   //         // CardBudget(amount: widget.categoriesModel![3].total_expense.toString(), cardcolor: debtColor,buttonText: 'pockets.debt'.tr(),currency: 'kes',titleText:'pockets.debt'.tr(),subtext: '' ,categoriesModel: widget.categoriesModel![3],)
    //   //       ],
    //   //     )
    //   //   ],
    //   //  )
        
         
     
    // );
 
 
  }
}


 
// import 'package:flutter/material.dart';
// import 'package:pocketwise/utils/constants/colors.dart';
// import 'package:pocketwise/utils/widgets/pockets/maincard.dart';
// import 'package:provider/provider.dart';
// import '../../../../repository/budget.repo.dart';
 

// class BudgetCard extends StatefulWidget {
//   @override
//   _BudgetCardState createState() => _BudgetCardState();
// }

// class _BudgetCardState extends State<BudgetCard> {
//   @override
//   Widget build(BuildContext context) {
//     final budgetRepository = Provider.of<BudgetRepository>(context);

//     return GridView.builder(
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
//       itemCount: budgetRepository.categories.length,
//       itemBuilder: (context, index) {
//         final category = budgetRepository.categories[index];
//         return CardBudget(
//           title: category.title,
//           limit_amount: category.limitAmount,
//           limit_rate: category.limitRate,
//           currency: "KES",   
//           categoryColor: primaryColor,
//           buttonText: "View Details",  // Adjust as needed
//         );
//       },
//     );
//   }
// }
