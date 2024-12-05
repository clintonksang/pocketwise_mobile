import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pockets/utils/constants/colors.dart';
import 'package:pockets/utils/constants/defaultPadding.dart';
import 'package:pockets/utils/functions/timeofday.dart';
import 'package:pockets/utils/widgets/pockets/animatedFAB.dart';
import 'package:pockets/utils/widgets/pockets/toptext.dart';

import '../../utils/constants/textutil.dart';
import '../../utils/widgets/pockets/maincard.dart';
import '../../utils/widgets/pockets/pocketscards.dart';

class Pockets extends StatefulWidget {
  @override
  State<Pockets> createState() => _PocketsState();
}

class _PocketsState extends State<Pockets> {

    reload(){
    setState(() {
      
    });
  }
  Color categoryColor = Colors.blue;
  Color categoryColor2 = Colors.amber;
  
   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      floatingActionButton: AnimatedFloatingActionButton(),
        floatingActionButtonLocation: CustomFloatingActionButtonLocation(offsetY: 0), // Adjust this value as needed
    
      body: SafeArea(
        child: SingleChildScrollView(
          child: RefreshIndicator(
            onRefresh: () {
            return   reload();
            },
            child: Container(
              margin: const EdgeInsets.only(
                  left: defaultPadding, right: defaultPadding, top: defaultPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Top Text
                  Toptext(),
            
                  Padding(
                    padding: const EdgeInsets.only(
                        top: defaultPadding, bottom: heightPadding),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('home.account'.tr()).extralargeBold()),
                  ),
                  // Cards
                    Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MainCard(
                      titleText: 'home.balance'.tr(),
                      amount: "10,000",
                      currency: 'kes',
                      buttomColor:greencolor ,
                      buttonText: 'home.deposit'.tr(),
                 
            
            
                    ), MainCard(
                        titleText: 'home.all_pockets'.tr(),
                         amount: "10,000",
                         currency: 'kes',
                         buttomColor: primaryColor,
                         buttonText: 'home.fund_pockets'.tr(),
                          
                    )],
                  ),
            
                  // Bottom Text
                  SizedBox(height: heightPadding,),
                  
                  Padding(
                    padding: const EdgeInsets.only(top: heightPadding),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'home.pockets'.tr(),
                        ).extralargeBold()),
                  ),
                  SizedBox(height: heightPadding,),
                  PocketsCard(
                    amount: '500',
                    currency: 'kes',
                    cardTitle: 'water bill pocket',
                    fundedStatus: 'funded',
                    date: "12th September 2024",
                    category: 'bills',
                    categoryColor: categoryColor
                  ),
                  SizedBox(height: heightPadding,),
                   PocketsCard(
                    amount: '430',
                    currency: 'kes',
                    cardTitle: 'coast travel',
                    fundedStatus: 'unfunded',
                    date: "7th September 2024",
                    category: 'travel',
                    categoryColor: categoryColor2,
                   
                  ),
                   SizedBox(height: heightPadding,),
                    PocketsCard(
                    amount: '430',
                    currency: 'kes',
                    cardTitle: 'coast travel',
                    fundedStatus: 'unfunded',
                    date: "7th September 2024",
                    category: 'travel',
                    categoryColor: categoryColor2,
                   
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


 
class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  final double offsetY;

  const CustomFloatingActionButtonLocation({this.offsetY = 0});

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    // Start with the standard bottom right position
    final Offset offset = FloatingActionButtonLocation.endFloat.getOffset(scaffoldGeometry);
    // Return a new Offset with the same horizontal position (x) but adjusted vertical position (y)
    return Offset(offset.dx, offset.dy - offsetY);
  }
}