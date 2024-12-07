import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pocketwise/models/pocket.model.dart';
import 'package:pocketwise/utils/constants/textutil.dart';
import 'package:pocketwise/utils/widgets/pockets/viewpocketcard.dart';
import 'package:provider/provider.dart';

import '../../../provider/income_provider.dart';
import '../../constants/colors.dart';
import '../../constants/customAppBar.dart';
import '../../constants/defaultPadding.dart';

class ViewPockets extends StatelessWidget {
  final PocketModel ? args;
  const ViewPockets({super.key,   this.args});

  @override
  Widget build(BuildContext context) {
    final incomeProvider = Provider.of<IncomeProvider>(context);
    return Scaffold(
      backgroundColor: backgroundColor,
       
      body: SafeArea(
          child: SingleChildScrollView(
          child: Container(
             margin: const EdgeInsets.only(
                  left: defaultPadding, right: defaultPadding, top: defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // AppBar
                   CustomAppBar(onPressed: (){
                    print('Pop');
                        Navigator.pop(context);
                      }),
              
                 Padding(
                  padding: const EdgeInsets.only(
                        top: heightPadding, bottom: 5),
                   child: Align(
                       alignment: Alignment.topLeft,
                       child: Text(
                         args!.cardTitle 
                        
                       ).extralargeBold()),
                 ),
                args!.fundedStatus != "funded"? Text('pockets.target_message'.tr()).normal(color: secondaryColor): Container(),
                
                 SizedBox(height: defaultPadding,),
                 ViewPocketCard(args: args,) 
                ],
              ),
          ),
        )
        ),
    );
  }
}