import 'package:flutter/material.dart';
import 'package:pockets/presentation/more/more.dart';
import 'package:pockets/presentation/pockets/pockets.dart';
import 'package:pockets/presentation/transactions/transactions.dart';
import 'package:pockets/utils/constants/colors.dart';
import 'package:pockets/utils/constants/textutil.dart';

class PageManager extends StatefulWidget {
  @override
  State<PageManager> createState() => _PageManagerState();
}

class _PageManagerState extends State<PageManager> {
  int _currentIndex = 0;
  late PageController _pageController;
  bool _showAddButtons = true;

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

 

  void _onScrollChange(bool show) {
    if (_currentIndex == 0) {
      setState(() {
        _showAddButtons = show;
      });
    }
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
      
     
    
        children: [
          Pockets(onScrollChange: _onScrollChange),
          // TransactionsPage(),
          More(),
        ],
      ), 
      backgroundColor: backgroundColor,
      bottomNavigationBar: BottomNav(
        activeColor: primaryColor,
        inactiveColor: secondaryColor,
        backgroundColor: backgroundColor,
        height: MediaQuery.of(context).size.height * 0.08,
        currentIndex: _currentIndex,
        onTabChange: (index) {
          _pageController.jumpToPage(index);
        },
      ),
    );
  }

  Widget _buildAddButton(BuildContext context,
      {required String label,
      required String iconPath,
      required Color backgroundColor}) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Tapped: $label")),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: AppTextStyles.normal.copyWith(color: Colors.white),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 14,
              child: Image.asset(
                iconPath,
                height: 16,
                width: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNav extends StatefulWidget {
  final Color activeColor;
  final Color inactiveColor;
  final Color backgroundColor;
  final double height;
  final int currentIndex;
  final Function(int) onTabChange;

  const BottomNav({
    Key? key,
    this.activeColor = Colors.purple,
    this.inactiveColor = Colors.grey,
    this.backgroundColor = Colors.white,
    this.height = 60,
    required this.currentIndex,
    required this.onTabChange,
  }) : super(key: key);

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  final List<String> _tabLabels = ['pockets',   'support'];

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
                    widget.onTabChange(index);
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  color: Colors.transparent,
                  child: Text(
                    _tabLabels[index],
                    textAlign: TextAlign.center,
                    style: AppTextStyles.normal.copyWith(
                      color: widget.currentIndex == index
                          ? widget.activeColor
                          : widget.inactiveColor,
                      fontWeight: widget.currentIndex == index
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
