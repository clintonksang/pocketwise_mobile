 


  import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pocketwise/utils/constants/colors.dart';
import 'package:pocketwise/utils/constants/textutil.dart';

import '../../utils/constants/defaultPadding.dart';
import '../../utils/widgets/pockets/customElevatedButton.dart';
import '../../utils/widgets/pockets/dropdown.dart';
import '../../utils/widgets/pockets/textfield.dart';

void showCustomModalBottomSheet(BuildContext context) {
    final fromEditingController = TextEditingController();
  final amountEditingController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,  
      backgroundColor: Colors.transparent, // Make background transparent
      builder: (context) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 300), // Animation duration
          curve: Curves.easeInOut,
          height: MediaQuery.of(context).size.height * 0.8, // 80% of screen height
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Container(
                         margin: const EdgeInsets.only(
                  left: defaultPadding, right: defaultPadding, top: defaultPadding),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0, top: heightPadding, bottom: heightPadding),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('pockets.close').tr().large(),
                        IconButton(
                          icon: Icon(Icons.close, size: 30),
                          onPressed: () {
                            Navigator.pop(context); // Close the bottom sheet
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                CustomTextField(
                controller: fromEditingController,
                 hint: 'pockets.none_selected'.tr(),
                title: 'pockets.fund_from'.tr(),
                hasdropdown: true,
                dropdownItems: [
                  DropdownItem(title: 'Bills',),
                  DropdownItem(title: 'Travel',  ),
                  DropdownItem(title: 'Groceries', ),
                  DropdownItem(title: 'House ammentities that was required lasr week bt the commisiuon',  ),
                  DropdownItem(title: 'Health',  ),
                ],
                
               ),
               SizedBox(height: heightPadding,),
            
              //  amount
               CustomTextField(
                controller: amountEditingController,
                hint: 'pockets.eg1000'.tr(),
                title: 'pockets.amount'.tr(),
                keyboardType: TextInputType.phone,
                
               ),
               SizedBox(height: heightPadding,),
               SizedBox(height: heightPadding,),
               SizedBox(height: heightPadding,),
               GestureDetector(
              onTap: () {
                  print('fund pocket');
                 Navigator.pop(context);
                },
               child: Customelevatedbutton(
                text: 'pockets.fund'.tr(),
                onPressed: (){}
                
               ),
             ),
                
              ],
            ),
          ),
        );
      },
    );
  }