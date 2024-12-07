import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pocketwise/utils/constants/customAppBar.dart';
import 'package:pocketwise/utils/widgets/pockets/customElevatedButton.dart';
import 'package:provider/provider.dart';

import '../../../provider/dropdown_provider.dart';
import '../../constants/colors.dart';
import '../../constants/defaultPadding.dart';
import '../../constants/textutil.dart';
import 'cardButtons.dart';
import 'customTextFormField.dart';
import 'dropdown.dart';

class CustomTextField extends StatelessWidget {
  final String? title;
  final String hint;
  final bool hasdropdown;
  final bool hasOptions;
  final String option1;
  final String option2;
  // keyboard type
  final TextInputType keyboardType;
  final List<DropdownItem> dropdownItems;
  final TextEditingController controller;
  CustomTextField(
      {super.key,
      required this.title,
      this.hasdropdown = false,
      this.hasOptions = false,
      this.keyboardType = TextInputType.text,
      this.dropdownItems = const [],
      this.option1 = '',
      this.option2 = '',
      required this.hint,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: white,
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 8, left: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    title!,
                    style: AppTextStyles.medium.copyWith(
                      fontSize: 10,
                    ),
                  )),
            ),
            Expanded(
                flex: 1,
                child:
                 
                    hasdropdown
                        ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Expanded(
                              //     flex: 2,
                              //     child:
                              //         Text(hint).normal(color: secondaryColor)),
                              
                              Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: IconDropdown(
                                  items: dropdownItems,
                                  onChanged: (value) {
                                    print('Selected category: $value');
                                    if(value == 'add new category'){
                                      
                                      showModalBottomSheet(context: context, builder: (context){
                                        return AddCategory();
                                      });
                                
                                    }
                                  },
                                ),
                              ),
                            ],
                          )
                        : hasOptions
                            ?

                            // Has selected options
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: CardButtons(
                                        cardColor: primaryColor,
                                        text: option1,
                                        small: false,
                                      )),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: CardButtons(
                                        cardColor: primaryColor,
                                        text: option2,
                                        small: false,
                                      )),
                                  Spacer()
                                ],
                              )
                            :
                            
                            // just text forms
                             FieldItems(
                                hintText: hint,
                                inputType: TextInputType.name,
                                isBorderVisible: false,
                                keyboardType:  keyboardType,
                                controller: controller,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '$title cannot be empty';
                                  }
                                  return null;
                                },
                              )),
            Spacer(),
          ],
        ),
      ),
    );
  }
}


class AddCategory extends StatelessWidget {
  const AddCategory({super.key});

  @override
  Widget build(BuildContext context) {
            final dropdownProvider = Provider.of<DropdownProvider>(context);

    TextEditingController categoryEditingController = TextEditingController();
    return   Container(
      height: MediaQuery.of(context).size.height*.7,
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
                        top: heightPadding, bottom: heightPadding),
                   child: Align(
                       alignment: Alignment.topLeft,
                       child: Text('pockets.add_category'.tr()).extralargeBold()),
                 ),
                 
                 
              SizedBox(height: heightPadding,),
              // expense amount  
             
             CustomTextField(
              controller: categoryEditingController,
              hint: 'pockets.category'.tr(),
              title: '',
              keyboardType: TextInputType.phone,
              
             ),
             SizedBox(height: heightPadding,),

            
             SizedBox(height: heightPadding,),

            

             GestureDetector(
              onTap: () {
                dropdownProvider.setSelectedValue(categoryEditingController.text);
                 Navigator.pop(context);
                },
               child: Customelevatedbutton(
                text: 'pockets.save'.tr(),
                onPressed: (){}
                
               ),
             ),
              
            
                  
                ],
              ),
          );
  }
}