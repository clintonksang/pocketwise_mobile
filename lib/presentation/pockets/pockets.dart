import 'dart:math';

import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:logger/web.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pocketwise/data/data.dart';
import 'package:pocketwise/models/budget.model.dart';
import 'package:pocketwise/models/categories.model.dart';
import 'package:pocketwise/models/expensecardmodel.dart';
import 'package:pocketwise/repository/budget.repo.dart';
import 'package:pocketwise/utils/constants/colors.dart';
import 'package:pocketwise/utils/constants/customsnackbar.dart';
import 'package:pocketwise/utils/constants/defaultPadding.dart';
import 'package:pocketwise/utils/constants/limits.dart';
import 'package:pocketwise/utils/functions/timeofday.dart';
import 'package:pocketwise/utils/widgets/pockets/animatedFAB.dart';
import 'package:pocketwise/utils/widgets/pockets/cardButtons.dart';
import 'package:pocketwise/utils/widgets/pockets/incomeexpensebuttons.dart';
import 'package:pocketwise/utils/widgets/pockets/toptext.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:pocketwise/utils/widgets/pockets/month_selector.dart';
import 'package:pocketwise/utils/constants/formatting.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pocketwise/utils/widgets/pockets/budget/budget_card.dart';
import 'package:pocketwise/utils/widgets/pockets/tracker_card.dart';
import 'package:pocketwise/utils/widgets/pockets/maincard.dart';
import 'package:pocketwise/utils/widgets/pockets/pocketscards.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../models/pocket.model.dart';
import '../../provider/income_provider.dart';
import '../../repository/expense.repo.dart';
import '../../router/approuter.dart';
import '../../utils/constants/textutil.dart';
import '../../utils/globals.dart';
import '../../utils/tutorial_coach.dart';

class Pockets extends StatefulWidget {
  final Function(bool) onScrollChange;

  Pockets({required this.onScrollChange});

  @override
  State<Pockets> createState() => _PocketsState();
}

class _PocketsState extends State<Pockets> {
  final ScrollController _scrollController = ScrollController();
  bool _isFabExpanded = false;
  final ExpenseRepository expenseRepository = ExpenseRepository();
  late Future<List<ExpenseModel>> _futureExpenses;
  DateTime? _lastBackPressTime;
  String firstName = '';
  String phoneNo = '';
  String lastName = '';

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
  bool hasNotificationPermission = false;
  bool hasSMSPermission = false;

  bool get hasAllPermissions => hasNotificationPermission && hasSMSPermission;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_toggleFabExpansion);
    _initializeData();
    _loadUserData();
    _checkNotificationPermission();
    _checkSMSPermission();
    _futureExpenses = expenseRepository.getTransactionsSortedByDate();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        selectedbutton = 1;
        selectedButtonText = 'budget';
      });
    });
  }

  Future<void> _initializeData() async {
    await _loadTotalIncome();
  }

  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? phoneNumber = prefs.getString('phone');
      phoneNo = phoneNumber ?? '';
      if (phoneNumber != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .where('phoneNumber', isEqualTo: phoneNumber)
            .get();

        if (userDoc.docs.isNotEmpty) {
          final userData = userDoc.docs.first.data();
          setState(() {
            firstName = userData['firstname'] ?? '';
            lastName = userData['lastname'] ?? '';
          });
        }
      }
    } catch (e) {
      Logger().e('Error loading user data: $e');
    }
  }

  Future<void> _checkNotificationPermission() async {
    final status = await Permission.notification.status;
    setState(() {
      hasNotificationPermission = status.isGranted;
    });
  }

  Future<void> _requestNotificationPermission() async {
    final status = await Permission.notification.request();
    setState(() {
      hasNotificationPermission = status.isGranted;
    });

    if (!status.isGranted) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Enable Notifications'),
              content: Text(
                  'To get updates about your expenses and budgets, please enable notifications in your device settings.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Not Now'),
                ),
                TextButton(
                  onPressed: () {
                    openAppSettings();
                    Navigator.pop(context);
                  },
                  child: Text('Open Settings'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  Future<void> _checkSMSPermission() async {
    final status = await Permission.sms.status;
    setState(() {
      hasSMSPermission = status.isGranted;
    });
  }

  Future<void> _requestSMSPermission() async {
    final status = await Permission.sms.request();
    setState(() {
      hasSMSPermission = status.isGranted;
    });

    if (!status.isGranted) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Enable SMS Access'),
              content: Text(
                  'To automatically track your expenses from SMS messages, please enable SMS access in your device settings.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Not Now'),
                ),
                TextButton(
                  onPressed: () {
                    openAppSettings();
                    Navigator.pop(context);
                  },
                  child: Text('Open Settings'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  // Call this function if data needs refreshing, like after a save operation
  reload() async {
    try {
      await Future.wait([
        expenseRepository.refreshTransactions(),
        incomeRepository.refreshTransactions(),
      ]);

      await _loadTotalIncome();
      await _loadPocketTotals();

      if (mounted) {
        setState(() {
          _futureExpenses = expenseRepository.getTransactionsSortedByDate();
        });
      }
    } catch (e) {
      Logger().e('Error reloading data: $e');
    }
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
    try {
      double total = await incomeRepository.getTotalIncome();
      Logger().i('Loading total income: $total');
      if (mounted) {
        setState(() {
          totalIncome = total;
        });
      }
    } catch (e) {
      Logger().e('Error loading total income: $e');
    }
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

  Future<bool> _onWillPop() async {
    final now = DateTime.now();
    if (_lastBackPressTime == null ||
        now.difference(_lastBackPressTime!) > Duration(seconds: 2)) {
      _lastBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Press back again to exit'),
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }
    return true;
  }

  Future<void> _requestPermissions() async {
    if (!hasNotificationPermission) {
      await _requestNotificationPermission();
    }
    if (!hasSMSPermission) {
      await _requestSMSPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    BudgetRepository budgetRepository = BudgetRepository();
    var incomeProvider = Provider.of<IncomeProvider>(context);
    budgetRepository.initializeCategories(
        incomeProvider.getTotalIncome(), context);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
                            Toptext(firstName: firstName),
                            Spacer(),
                            Stack(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    if (!hasAllPermissions) {
                                      _requestPermissions();
                                      saveUserIDToNative(phoneNo);
                                    }
                                  },
                                  icon: Image.asset(
                                    'assets/images/bell.png',
                                    width: 24,
                                    height: 24,
                                    color: hasAllPermissions
                                        ? Colors.black
                                        : Colors.grey,
                                  ),
                                ),
                                if (!hasAllPermissions)
                                  Positioned(
                                    right: 8,
                                    top: 8,
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(width: 8),
                            IconButton(
                              onPressed: () {
                                Logger().i(
                                    'Test button pressed - triggering notification');
                                saveUserIDToNative(phoneNo);
                              },
                              icon: Icon(
                                Icons.notifications_active,
                                color: Colors.blue,
                                size: 24,
                              ),
                            ),
                            SizedBox(width: 8),
                            CircleAvatar(
                              backgroundColor: black,
                              radius: 24,
                              child: Text(
                                '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}'
                                    .toUpperCase(),
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
                                  double totalincome = snapshot.data ?? 0.0;
                                  int sourceCount =
                                      incomeProvider.incomes.length;

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
                                      amount: totalincome.toStringAsFixed(2),
                                      currency: 'kes',
                                      cardcolor: black,
                                      buttonText: 'home.add_income'.tr(),
                                      sourceCount: sourceCount,
                                      onViewPressed: () => Navigator.pushNamed(
                                          context, AppRouter.view_income),
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
                        SizedBox(height: heightPadding),
                        ExpenseList(futureExpenses: _futureExpenses),
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
                            onTap: () async {
                              final result = await Navigator.pushNamed(
                                  context, AppRouter.add_income);
                              if (result == 'added') {
                                reload();
                              }
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
      ),
    );
  }
}

class ExpenseList extends StatefulWidget {
  final Future<List<ExpenseModel>> futureExpenses;

  const ExpenseList({super.key, required this.futureExpenses});

  @override
  State<ExpenseList> createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
  DateTime selectedMonth = DateTime.now();
  List<ExpenseModel> filteredExpenses = [];
  double monthlyTotal = 0.0;
  bool isLoading = true;
  final ExpenseRepository expenseRepository = ExpenseRepository();

  @override
  void initState() {
    super.initState();
    _loadExpensesForMonth(selectedMonth);
  }

  Future<void> _loadExpensesForMonth(DateTime month) async {
    setState(() {
      isLoading = true;
    });

    try {
      // First refresh the transactions to get fresh data
      await expenseRepository.refreshTransactions();

      final expenses = await expenseRepository.getTransactionsByMonth(month);
      final total = await expenseRepository.getTotalExpenseByMonth(month);

      if (mounted) {
        setState(() {
          filteredExpenses = expenses
            ..sort((a, b) => b.dateCreated.compareTo(a.dateCreated));
          monthlyTotal = total;
          selectedMonth = month;
          isLoading = false;
        });
      }
    } catch (e) {
      Logger().e('Error loading expenses: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _loadExpensesForMonth(selectedMonth),
      child: Column(
        children: [
          // Month selector
          MonthSelector(
            selectedMonth: selectedMonth,
            onDateRangeSelected: (start, end) => _loadExpensesForMonth(start),
          ),
          SizedBox(height: heightPadding),

          // Monthly total
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Monthly Total:",
                  style: AppTextStyles.bold,
                ),
                Text(
                  "${toLocaleString(monthlyTotal)} kes",
                  style: AppTextStyles.bold.copyWith(
                    color: monthlyTotal > 0 ? Colors.red : Colors.green,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: heightPadding),

          // Expenses list
          if (isLoading)
            Center(child: CircularProgressIndicator())
          else if (filteredExpenses.isEmpty)
            Center(
              child: Text(
                'No expenses for ${DateFormat('MMMM yyyy').format(selectedMonth)}',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: filteredExpenses.length,
              itemBuilder: (context, index) {
                final expense = filteredExpenses[index];
                return Container(
                  width: MediaQuery.of(context).size.width,
                  child: ExpenseCard(expenseModel: expense),
                );
              },
            ),
        ],
      ),
    );
  }
}
