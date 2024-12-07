import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'constants/colors.dart';

import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

 
List<TargetFocus> createTargets(TutorialCoachMark tutorialCoachMark) {
  return [
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
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor, // Use primaryColor for the button
                ),
                onPressed: () {
                  tutorialCoachMark.next(); // Go to the next step
                },
                child: Text("Next"),
              ),
            ],
          ),
        ),
      ],
    ),
    TargetFocus(
      keyTarget: wantsKey,
      shape: ShapeLightFocus.RRect,
      radius: 10,
      contents: [
        TargetContent(
          align: ContentAlign.top,
          child: Column(
            children: [
              Text(
                "30% for Wants",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "This part is for discretionary spending, like dining out, entertainment, and hobbies.",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor, // Use primaryColor for the button
                ),
                onPressed: () {
                  tutorialCoachMark.next();
                },
                child: Text("Next"),
              ),
            ],
          ),
        ),
      ],
    ),
    TargetFocus(
      keyTarget: savingsInvestmentsKey,
      shape: ShapeLightFocus.RRect,
      radius: 10,
      contents: [
        TargetContent(
          align: ContentAlign.top,
          child: Column(
            children: [
              Text(
                "20% for Savings & Investments",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "This portion is dedicated to building your future through savings, retirement, and investments.",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor, // Use primaryColor for the button
                ),
                onPressed: () {
                  tutorialCoachMark.next();
                },
                child: Text("Next"),
              ),
            ],
          ),
        ),
      ],
    ),
    TargetFocus(
      keyTarget: debtKey,
      shape: ShapeLightFocus.RRect,
      radius: 10,
      contents: [
        TargetContent(
          align: ContentAlign.top,
          child: Column(
            children: [
              Text(
                "20% for Debt Repayment",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Use this part of your budget to manage and reduce debts such as loans and credit card balances.",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor, // Use primaryColor for the button
                ),
                onPressed: () {
                  tutorialCoachMark.finish(); // Finish the tutorial
                },
                child: Text("Finish"),
              ),
            ],
          ),
        ),
      ],
    ),
  ];
}

final GlobalKey needsKey = GlobalKey();
final GlobalKey wantsKey = GlobalKey();
final GlobalKey savingsInvestmentsKey = GlobalKey();
final GlobalKey debtKey = GlobalKey();
