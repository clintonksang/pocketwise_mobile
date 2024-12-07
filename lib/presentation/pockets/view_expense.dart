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
import 'package:pocketwise/utils/widgets/pockets/pocketscards.dart';
import 'package:provider/provider.dart';

import '../../utils/constants/textutil.dart';
 
 

 
 
class ViewExpense extends StatefulWidget {
  final CategoriesModel categoriesModel;
  const ViewExpense({
    super.key,
    required this.categoriesModel,
  });

  @override
  State<ViewExpense> createState() => _ViewExpenseState();
}

class _ViewExpenseState extends State<ViewExpense> {
  String selectedCategory = '';
  List<ExpenseModel> filteredExpenses = [];

  @override
  void initState() {
    selectedCategory = widget.categoriesModel.title;
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
              "home.add_expense".tr(),
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
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: heightPadding),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "${selectedCategory} pocket",
                    style: AppTextStyles.bold,
                  ),
                ),
              ),
              // Selections
              buildSelection(widget.categoriesModel),
              SizedBox(height: defaultPadding),
              Text(
                "total: ${toLocaleString(widget.categoriesModel.total_expense)} kes",
                style: AppTextStyles.bold,
              ),
              Text(
                "You've spent 28% of your income in this month".tr(),
              ).smallLight(),
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
