import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pockets/utils/constants/colors.dart';
import 'package:pockets/utils/constants/customAppBar.dart';
import 'package:pockets/utils/constants/defaultPadding.dart';

import '../../utils/constants/textutil.dart';
import '../../utils/textfield.dart';
import '../../utils/widgets/pockets/customTextFormField.dart';
import '../../utils/widgets/pockets/dropdown.dart';

class CreatePocket extends StatefulWidget {
  const CreatePocket({super.key});

  @override
  State<CreatePocket> createState() => _CreatePocketState();
}

class _CreatePocketState extends State<CreatePocket> {
  final titleEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return   Scaffold(
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
                        Navigator.pop(context);
                      }),
              
                 Padding(
                  padding: const EdgeInsets.only(
                        top: heightPadding, bottom: heightPadding),
                   child: Align(
                       alignment: Alignment.topLeft,
                       child: Text('home.account'.tr()).extralargeBold()),
                 ),
                 
                 
              SizedBox(height: heightPadding,),
             CustomTextField(
              controller: titleEditingController,
              hint: 'pockets.egwaterbill'.tr(),
              title: 'pockets.pocket_title'.tr(),
             ),
             SizedBox(height: heightPadding,),
             CustomTextField(
              controller: titleEditingController,
              hint: 'pockets.eg1000'.tr(),
              title: 'pockets.amount'.tr(),
             ),
             SizedBox(height: heightPadding,),
             CustomTextField(
              controller: titleEditingController,
              hint: 'pockets.none_selected'.tr(),
              title: 'pockets.category'.tr(),
              hasdropdown: true,
              dropdownItems: [
  DropdownItem(title: 'Bills', icon: Icons.account_balance),
      DropdownItem(title: 'Travel',  ),
      DropdownItem(title: 'Groceries', ),
      DropdownItem(title: 'Entertainment',  ),
      DropdownItem(title: 'Health',  ),
              ],
              
             )
             
                  
                ],
              ),
          ),
        )),
    );
      
       
  }
}

 