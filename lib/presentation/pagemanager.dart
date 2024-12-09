import 'package:flutter/material.dart';
import 'package:pockets/presentation/profile/profile.dart';
import 'package:pockets/utils/constants/colors.dart';
import 'package:pockets/utils/constants/textutil.dart';
import 'package:pockets/presentation/components/expensePage.dart';
// import 'package:pockets/presentation/components/incomeCard.dart';

import 'pockets/pockets.dart';
import 'more/more.dart';
import 'transactions/transactions.dart';

class PageManager extends StatefulWidget {
  @override
  State<PageManager> createState() => _PageManagerState();
}

class _PageManagerState extends State<PageManager> {
  int _currentIndex = 0;
  late PageController _pageController;

  final List<Widget> _pages = [
    Pockets(),
    Profile(),
    ExpensePage()
    // ExpenseCard(title:'20,000'),
    // IncomeCard()
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _pages,
      ),
      backgroundColor: backgroundColor,
      bottomNavigationBar: BottomNav(
        activeColor: primaryColor,

        /// The [BottomNav] allows users to switch between pages by tapping on
        /// the icons in the navigation bar. The [onTabChange] callback uses
        /// [_pageController.jumpToPage] to navigate to the selected page.
        ///
        /// The UI's background color is set to [backgroundColor], and the colors for
        /// the active and inactive bottom navigation icons are set to [primaryColor]
        /// and [secondaryColor], respectively.
        inactiveColor: secondaryColor,
        backgroundColor: backgroundColor,
        height: 120,
        onTabChange: (index) {
          _pageController.jumpToPage(index); // Navigate to the selected page
        },
      ),
    );
  }
}

class BottomNav extends StatefulWidget {
  final Color activeColor;
  final Color inactiveColor;
  final Color backgroundColor;
  final double height;
  final Function(int) onTabChange;

  const BottomNav({
    Key? key,
    this.activeColor = Colors.purple,
    this.inactiveColor = Colors.grey,
    this.backgroundColor = Colors.white,
    this.height = 60,
    required this.onTabChange,
  }) : super(key: key);

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;

  final List<String> _tabLabels = ['pockets', 'profile', 'components'];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      color: widget.backgroundColor,
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_tabLabels.length, (index) {
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                  widget.onTabChange(index);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  color: Colors.transparent,
                  child: Text(
                    _tabLabels[index],
                    textAlign: TextAlign.center,
                    style: AppTextStyles.normal.copyWith(
                      color: _selectedIndex == index
                          ? widget.activeColor
                          : widget.inactiveColor,
                      fontWeight: _selectedIndex == index
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
