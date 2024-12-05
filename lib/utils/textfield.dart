import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'constants/colors.dart';
import 'constants/textutil.dart';
import 'widgets/pockets/customTextFormField.dart';
import 'widgets/pockets/dropdown.dart';

class CustomTextField extends StatelessWidget {
  final String ? title;
 final String hint;
 final bool  hasdropdown;
 final List <DropdownItem> dropdownItems;
  final TextEditingController controller;
    CustomTextField({super.key,
  required this.title,  this.hasdropdown = false, this.dropdownItems = const [], required this.hint, required this.controller
  });

  @override
  Widget build(BuildContext context) {
    return      Container(
                  height: 70,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                  color: white, 
                  ),
                  child: Padding(padding: EdgeInsets.only(top: 8, left: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                    flex: 1,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(title!, style: AppTextStyles.medium.copyWith(fontSize: 10, ),)),
                      ),

                     Flexible(
                      flex: 1,
                       child: 
                       
                       !hasdropdown ?FieldItems(
                                     hintText: hint,
                                     inputType: TextInputType.name,
                                     isBorderVisible: false, 
                                     controller: controller,
                                      validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '$title cannot be empty';  
                  }
                  return null;
                },
                                   ): 
                                   Row(
                                     
                                    children: [
                                      
                                   Flexible(
                                    flex: 2,
                                    child: Text(hint).normal(color: secondaryColor)),
                                   Spacer(),
                                    Flexible(
                                      flex: 2,
                                      child: IconDropdown(
                                                items:  dropdownItems,
                                                onChanged: (value) {
                                                  print('Selected category: $value');
                                                },
                                              ),
                                    ),
                                      
                                    ],
                                   )
                     ),
                Spacer() 
                    ],
                  ),
                  ),
                  
                 );
  }
}