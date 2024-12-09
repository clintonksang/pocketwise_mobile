import 'dart:math';

import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:logger/web.dart';
import 'package:pocketwise/data/data.dart';
import 'package:pocketwise/models/budget.model.dart';
import 'package:pocketwise/models/categories.model.dart';
import 'package:pocketwise/models/expensecardmodel.dart';
import 'package:pocketwise/repository/budget.repo.dart';
import 'package:pocketwise/utils/constants/colors.dart';
import 'package:pocketwise/utils/constants/defaultPadding.dart';
import 'package:pocketwise/utils/constants/limits.dart';
import 'package:pocketwise/utils/functions/timeofday.dart';
import 'package:pocketwise/utils/widgets/pockets/animatedFAB.dart';
import 'package:pocketwise/utils/widgets/pockets/cardButtons.dart';
import 'package:pocketwise/utils/widgets/pockets/incomeexpensebuttons.dart';
import 'package:pocketwise/utils/widgets/pockets/toptext.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../models/pocket.model.dart';
import '../../provider/income_provider.dart';
import '../../repository/expense.repo.dart';
import '../../router/approuter.dart';
import '../../utils/constants/textutil.dart';
import '../../utils/globals.dart';
import '../../utils/tutorial_coach.dart';
import '../../utils/widgets/pockets/budget/budget_card.dart';
import '../../utils/widgets/pockets/tracker_card.dart';
import '../../utils/widgets/pockets/maincard.dart';
import '../../utils/widgets/pockets/pocketscards.dart';

class Pockets extends StatefulWidget {
  final Function(bool) onScrollChange;

  Pockets({required this.onScrollChange});

  @override
  State<Pockets> createState() => _PocketsState();
}

class _PocketsState extends State<Pockets> {
  final ScrollController _scrollController = ScrollController();
  bool _isFabExpanded = false;

  double totalIncome = 0.0;

  double totalWants = 0.0;
  double totalNeeds = 0.0;
  double totalSavingsInvestments = 0.0;
  double totalDebt = 0.0;
  List<CategoriesModel> pocketCategories = [];

  CategoriesModel? needsCategory;
  CategoriesModel? wantsCategory;
  CategoriesModel? savingsInvestmentsCategory;
  CategoriesModel? debtCategory;



  int selectedbutton = 1;
  String selectedButtonText = 'budget';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_toggleFabExpansion);
    _initializeData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // showTutorial(context);
      setState(() {
        selectedbutton = 1;
        selectedButtonText = 'budget';
      });
    });
  }

  Future<void> _initializeData() async {
    await _loadTotalIncome();
 
  }

 


  // Call this function if data needs refreshing, like after a save operation
  reload() async {
    // await _loadPocketCategories();
    _loadTotalIncome(); 
  }

  Future<void> _loadPocketTotals() async {
    totalWants = await expenseRepository.getTotalByPocket('wants');
    totalNeeds = await expenseRepository.getTotalByPocket('needs');
    totalSavingsInvestments =
        await expenseRepository.getTotalByPocket('savings & investments');
    totalDebt = await expenseRepository.getTotalByPocket('debt');

    setState(() {});
  }

  void _toggleFabExpansion() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (_showAddButtons) {
        setState(() => _showAddButtons = false);
        widget.onScrollChange(false);
      }
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (!_showAddButtons) {
        setState(() => _showAddButtons = true);
        widget.onScrollChange(true);
      }
    }
  }

  Future<void> _loadTotalIncome() async {
    double total = await incomeRepository.getTotalIncome();
    Logger().i('initstate total income: $total');
    setState(() {
      totalIncome = total;
    });
  }

  Widget budgetAndTracker() {
    List<Widget> allCards = [
      CardButtons(
        cardColor: selectedbutton == 0 ? primaryColor : white,
        text: 'home.tracker'.tr(),
        textcolor: selectedbutton == 0 ? white : black,
        small: false,
      ),
      CardButtons(
        cardColor: selectedbutton == 1 ? primaryColor : white,
        text: 'home.budget'.tr(),
        textcolor: selectedbutton == 1 ? white : black,
        small: false,
      ),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: allCards.asMap().entries.map((entry) {
        int index = entry.key;
        Widget card = entry.value;

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedbutton = index;
              selectedButtonText = selectedbutton == 0 ? 'tracker' : 'budget';
            });
            Logger().i(
                'Card tapped: ${selectedbutton == 0 ? 'Tracker' : 'Budget'}');
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.40,
            padding: EdgeInsets.all(8.0),
            child: card,
          ),
        );
      }).toList(),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_toggleFabExpansion);
    _scrollController.dispose();

    super.dispose();
  }

  String selectedCategory = '';
  List<ExpenseModel> filteredExpenses = [];
  bool _showAddButtons = true;
  List selectedItems = ['needs', 'wants', 'savings & investments', 'debt'];

  void showTutorial(BuildContext context) {
    TutorialCoachMark tutorialCoachMark = TutorialCoachMark(
      targets: createTargets(TutorialCoachMark(targets: [
        TargetFocus(
          keyTarget: needsKey,
          shape: ShapeLightFocus.RRect,
          radius: 10,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              child: Column(
                children: [
                  Text(
                    "50% of your income for Needs",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "This part of your budget is for essential expenses like rent, groceries, utilities, and transportation.",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ],
        )
      ])),
      colorShadow: Colors.black,
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0.8,
    );

    tutorialCoachMark.show(context: context);
  }

  @override
  Widget build(BuildContext context) {
    BudgetRepository budgetRepository = BudgetRepository();
        var incomeProvider = Provider.of<IncomeProvider>(context);
        budgetRepository.initializeCategories(incomeProvider.getTotalIncome(), context);

    return Scaffold(
      backgroundColor: backgroundColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () {
            return reload();
          },
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: _scrollController,
                child: Container(
                  margin: const EdgeInsets.only(
                      left: defaultPadding,
                      right: defaultPadding,
                      top: defaultPadding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: defaultPadding),
                      Row(
                        children: [
                          Toptext(),
                          Spacer(),
                          IconButton(
                            onPressed: () {
                         Provider.of<IncomeProvider>(context, listen: false).clearAllIncomes();
                            },
                            icon: Image.asset('assets/images/bell.png',
                                width: 24, height: 24, color: Colors.black),
                          ),
                          CircleAvatar(
                            backgroundColor: black,
                            radius: 24,
                            child: Text(
                              'CS',
                              style: AppTextStyles.normal
                                  .copyWith(color: Colors.white),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: defaultPadding),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(
                                context, AppRouter.add_income),
                            child: StreamBuilder<double>(
                              stream: incomeProvider.totalIncomeStream,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return MainCard(
                                    titleText: 'home.income'.tr(),
                                    amount: "0.00",
                                    currency: 'kes',
                                    cardcolor: black,
                                    buttonText: 'home.add_income'.tr(),
                                  );
                                } else {
                                  return MainCard(
                                    titleText: 'home.income'.tr(),
                                    amount:
                                        "${snapshot.data?.toStringAsFixed(2) ?? "0.00"}",
                                    currency: 'kes',
                                    cardcolor: black,
                                    buttonText: 'home.add_income'.tr(),
                                  );
                                }
                              },
                            ),
                          ),
                          StreamBuilder<double>(
                            stream: expenseRepository.expenseStream,
                            builder: (context, snapshot) {
                              double totalExpense = snapshot.data ?? 0.0;
                              return MainCard(
                                titleText: 'home.expense'.tr(),
                                amount: totalExpense.toStringAsFixed(2),
                                currency: 'kes',
                                subtext: "75",
                                cardcolor: primaryColor,
                                buttonText: 'home.add_expense'.tr(),
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: heightPadding),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'home.pockets'.tr(),
                          ).largeBold(),
                        ),
                      ),
                      SizedBox(height: 5),
                      budgetAndTracker(),
                      SizedBox(height: heightPadding),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: selectedButtonText != 'budget'? MediaQuery.of(context).size.height * .32 : MediaQuery.of(context).size.height * .46,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          color: white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: selectedButtonText == 'budget'
                              ? BudgetCard(
                                hasBudget : false
                              )
                              : 
                              ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: selectedItems.length,
                                itemBuilder: (context, index) {
                                  return TrackerCard(
                                    key: selectedItems[index].key,
                                    categoriesModel: selectedItems[index],
                                  );
                                },
                              )
                              // Row(
                              //     children: [
                              //       TrackerCard(
                              //           key: needsKey,
                              //           categoriesModel: needsCategory),
                              //       TrackerCard(
                              //           key: wantsKey,
                              //           categoriesModel: wantsCategory),
                              //       TrackerCard(
                              //           key: savingsInvestmentsKey,
                              //           categoriesModel:
                              //               savingsInvestmentsCategory),
                              //       TrackerCard(
                              //           key: debtKey,
                              //           categoriesModel: debtCategory),
                              //     ],
                              //   ),
                        ),
                      ),
                      SizedBox(height: heightPadding),
                      selectedButtonText != 'budget'? Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'home.transactions'.tr(),
                          ).largeBold(),
                        ),
                      ) : SizedBox(height: 0),
                      selectedButtonText != 'budget'?ExpenseList() :
                      SizedBox(height: 0),
                    ],
                  ),
                ),
              ),
              if (_showAddButtons)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 300),
                    opacity: _showAddButtons ? 1.0 : 0.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Incomeexpensebuttons(
                          label: 'add income',
                          iconPath: 'assets/images/income_arrow.png',
                          backgroundColor: Colors.black,
                          onTap: () {
                            Navigator.pushNamed(context, AppRouter.add_income);
                          },
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Incomeexpensebuttons(
                          label: 'add expense',
                          iconPath: 'assets/images/expense_arrow.png',
                          backgroundColor: primaryColor,
                          onTap: () async {
                            final result = await Navigator.pushNamed(
                                context, AppRouter.addExpense);
                            if (result == 'added') {
                              _loadTotalIncome();
                              _loadPocketTotals();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExpenseList extends StatelessWidget {
  final ExpenseRepository expenseRepository = ExpenseRepository();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ExpenseModel>>(
      future: expenseRepository.getAllTransactions(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No expenses found.'));
        } else {
          final expenses = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: expenses.length,
            itemBuilder: (context, index) {
              final expense = expenses[index];
              return Container(
                  width: MediaQuery.of(context).size.width,
                  child: ExpenseCard(expenseModel: expense));
            },
          );
        }
      },
    );
  }
}
