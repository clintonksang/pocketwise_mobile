import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pocketwise/data/data.dart';
import 'package:pocketwise/models/categories.model.dart';
import 'package:pocketwise/models/expensecardmodel.dart';
import 'package:pocketwise/models/pocket.model.dart';
import 'package:pocketwise/presentation/pockets/shodmodalsheet.dart';
import 'package:pocketwise/provider/category_provider.dart';
import 'package:pocketwise/router/approuter.dart';
import 'package:pocketwise/utils/constants/colors.dart';
import 'package:pocketwise/utils/constants/customAppBar.dart';
import 'package:pocketwise/utils/constants/defaultPadding.dart';
import 'package:pocketwise/utils/constants/formatting.dart';
import 'package:pocketwise/utils/globals.dart';
import 'package:pocketwise/utils/widgets/pockets/budget/edit_limit.dart';
import 'package:pocketwise/utils/widgets/pockets/cardButtons.dart';
import 'package:pocketwise/utils/widgets/pockets/pocketscards.dart';
import 'package:provider/provider.dart';

import '../../../../models/budget.model.dart';
import '../../../../provider/income_provider.dart';
import '../../../constants/textutil.dart';

 
 

 
 
class ViewBudget extends StatefulWidget {
  final BudgetModel categoriesModel;
  // final CategoriesModel categoriesModel;
  const ViewBudget({
    super.key,
  required this.categoriesModel,
  });

  @override
  State<ViewBudget> createState() => _ViewBudgetState();
}

class _ViewBudgetState extends State<ViewBudget> {
  String selectedCategory = '';
  List<ExpenseModel> filteredExpenses = [];

  @override
  void initState() {
    selectedCategory = widget.categoriesModel.categories[0].title;
    super.initState();
    _loadExpensesForCategory();
  }

  Future<void> _loadExpensesForCategory() async {
    List<ExpenseModel> expenses =
        await expenseRepository.getTransactionsByPocket(selectedCategory);
    setState(() {
      filteredExpenses = expenses;
    });
  }

  final titleEditingController = TextEditingController();
  final amountEditingController = TextEditingController();

  @override

  Widget build(BuildContext context) {
        final incomeProvider = Provider.of<IncomeProvider>(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      floatingActionButton: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          width: MediaQuery.of(context).size.width * .3,
          height: 44,
          child: FloatingActionButton.extended(
            onPressed: () async {
              await Navigator.pushNamed(
                context,
                AppRouter.addExpense,
                // arguments: widget.categoriesModel,
              );

              // Refresh the page when returning back
              _loadExpensesForCategory();
            },
            backgroundColor: primaryColor,
            icon: Icon(Icons.add, color: Colors.white),
            label: Text(
             widget.categoriesModel.categories[0].title,
              style: TextStyle(color: Colors.white),
            ),
          )),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AppBar
              CustomAppBar(onPressed: () {
                Navigator.pop(context);
              }),
              
              SizedBox(height: defaultPadding),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Limit: ${toLocaleString(widget.categoriesModel.categories[0].limitAmount)} kes",
                    style: AppTextStyles.bold.copyWith(
                    
                    ), 
                  ),
                  Spacer(),
                   SizedBox(width: defaultPadding),
                   GestureDetector(
                    onTap: () {
                        showModalBottomSheet(context: context, builder: (context){
                                          return EditLimit(
                                             limitAmount: widget.categoriesModel.categories[0].limitAmount,
                                             title: widget.categoriesModel.categories[0].title!,
                                             type: widget.categoriesModel.categories[0].type!,
                                          );
                                        });
                    },
                    child: CardButtons(cardColor: primaryColor, text: 'home.adjust_budget'.tr(), small: false))
                ],
              ),

                     SizedBox(height: defaultPadding),       SizedBox(height: defaultPadding),
           
               Row(
                mainAxisAlignment: MainAxisAlignment.start,
                 children: [
                   Text(
                        "Current: ",
                        style: AppTextStyles.bold.copyWith(

                        ), 
                      ),
                   Text(
                        "${toLocaleString(widget.categoriesModel.categories[0].limitAmount)} kes ",
                        style: AppTextStyles.bold.copyWith(
                                                color: widget.categoriesModel.categories[0].limitAmount <= widget.categoriesModel.categories[0].limitAmount? Colors.green : Colors.red

                        ), 
                      ),
                   Text(
                        "/ ${toLocaleString(incomeProvider.getTotalIncome())} kes",
                        style: AppTextStyles.bold.copyWith(

                        ), 
                      ),
                 ],
               ),
              SizedBox(height: defaultPadding),

              // Display filtered expenses here
              Expanded(
                child: filteredExpenses.isEmpty
                    ? Center(
                        child: Text(
                          "No transactions available",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredExpenses.length,
                        itemBuilder: (context, index) {
                          final expense = filteredExpenses[index];
                          return ExpenseCard(expenseModel: expense);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSelection(CategoriesModel categoriesModel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
 
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedCategory = "needs";
                  _loadExpensesForCategory();

                });
                context.read<CategoryProvider>().updateCategory("needs");
              },
              child: Container(
                height: 30,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color:
                      selectedCategory == "needs" ? needsColor : Colors.white,
                ),
                child: Center(
                  child: Text(
                    "needs",
                    style: AppTextStyles.normal.copyWith(
                      color: selectedCategory == "needs"
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: heightPadding),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedCategory = "wants";
                  _loadExpensesForCategory();
                });
             context.read<CategoryProvider>().updateCategory("wants");

              },
              child: Container(
                height: 30,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: selectedCategory == "wants" ? wantsColor : Colors.white,
                ),
                child: Center(
                  child: Text(
                    "wants",
                    style: AppTextStyles.normal.copyWith(
                      color: selectedCategory == "wants"
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: heightPadding),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedCategory = "savings & investments";
                  _loadExpensesForCategory();
                });
         context.read<CategoryProvider>().updateCategory("savings & investments");

              },
              child: Container(
                height: 30,
                width: MediaQuery.of(context).size.width * .6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: selectedCategory == "savings & investments"
                      ? sandicolor
                      : Colors.white,
                ),
                child: Center(
                  child: Text(
                    'savings & investments',
                    style: AppTextStyles.normal.copyWith(
                      color: selectedCategory == "savings & investments"
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: heightPadding),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedCategory = "debt";
                  _loadExpensesForCategory();
                });
                context.read<CategoryProvider>().updateCategory("debt");
              },
              child: Container(
                height: 30,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: selectedCategory == "debt" ? debtColor : Colors.white,
                ),
                child: Center(
                  child: Text(
                    'debt',
                    style: AppTextStyles.normal.copyWith(
                      color: selectedCategory == "debt"
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
