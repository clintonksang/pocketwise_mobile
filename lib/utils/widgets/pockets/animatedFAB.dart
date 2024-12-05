import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:pockets/utils/constants/textutil.dart';

import '../../../router/approuter.dart';

class AnimatedFloatingActionButton extends StatefulWidget {
  const AnimatedFloatingActionButton({Key? key}) : super(key: key);

  @override
  _AnimatedFloatingActionButtonState createState() => _AnimatedFloatingActionButtonState();
}

class _AnimatedFloatingActionButtonState extends State<AnimatedFloatingActionButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.easeInOut,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    print("Toggle button pressed"); // Debug print
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  Widget _buildItem(String label, VoidCallback onTap, int index, String assetImage) {
    return AnimatedBuilder(
      animation: _expandAnimation,
      builder: (context, child) {
        final animation = Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _expandAnimation,
          curve: Interval(0.1 * index, 0.6 + 0.1 * index, curve: Curves.easeOut),
        ));

        return SlideTransition(
          position: animation,
          child: FadeTransition(
            opacity: _expandAnimation,
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Align(
          alignment: Alignment.bottomRight,
          child: SizedBox(
            width: 179,
            height: 44,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff7400E0),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                print("Button pressed: $label"); // Debug print
                onTap();
              },
              child: Row(
                children: [
                  Image.asset(assetImage, width: 24, height: 24, color: Colors.white),
                  const SizedBox(width: 10),
                  Text(label, style: AppTextStyles.medium.copyWith(color: Colors.white, fontWeight: FontWeight.w900)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          if (_isExpanded)
            Positioned(
              bottom: 80, // Increased to avoid overlap with main FAB
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildItem('fund pocket', () {
                    print('fund pocket action');
                  }, 0, 'assets/images/fund.png'),
                  _buildItem('deposit', () {
                    print('deposit action');
                  }, 1, 'assets/images/deposit.png'),
                  _buildItem('create pocket', () {
                    print('create pocket action');
                    Navigator.pushNamed(context, AppRouter.createPocket);
                  }, 2, 'assets/images/add.png'),
                ],
              ),
            ),
          Positioned(
            bottom: 0,
            right: 0,
            child: FloatingActionButton(
              backgroundColor: const Color(0xff7400E0),
              onPressed: _toggleExpanded,
              shape: const CircleBorder(),
              child: AnimatedIcon(
                icon: AnimatedIcons.menu_close,
                progress: _expandAnimation,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}