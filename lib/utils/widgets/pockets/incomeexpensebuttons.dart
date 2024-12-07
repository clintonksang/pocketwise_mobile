import 'dart:ffi';

import 'package:flutter/material.dart';

import '../../../router/approuter.dart';
 
import '../../constants/textutil.dart';

class Incomeexpensebuttons extends StatelessWidget {
  final String label;
  final String iconPath;
  final VoidCallback onTap;
  final Color backgroundColor;
  const Incomeexpensebuttons({super.key,
  required this.label,
  required this.iconPath,
  required this.onTap, 
  required this.backgroundColor
  
  });

  @override
  Widget build(BuildContext context) {
      return GestureDetector(
    onTap:  onTap,
    child: Container(
     
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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