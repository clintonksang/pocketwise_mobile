import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pocketwise/models/categories.model.dart';
import 'package:pocketwise/presentation/pockets/shodmodalsheet.dart';
import 'package:pocketwise/provider/dropdown_provider.dart';
import 'package:pocketwise/utils/constants/colors.dart';
import 'package:pocketwise/utils/constants/customAppBar.dart';
import 'package:pocketwise/utils/constants/defaultPadding.dart';
import 'package:pocketwise/utils/constants/formatting.dart';
import 'package:pocketwise/utils/globals.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/expensecardmodel.dart';
import '../../provider/category_provider.dart';
import '../../utils/constants/textutil.dart';
import '../../utils/date_picker.dart';
import '../../utils/widgets/pockets/customElevatedButton.dart';
import '../../utils/widgets/pockets/textfield.dart';
import '../../utils/widgets/pockets/dropdown.dart';

class AddExpense extends StatefulWidget {
  
  const AddExpense({super.key,
  //  required this.categoriesModel
   });

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  final categoryController = TextEditingController();
  final amountEditingController = TextEditingController();
  final titleEditingController = TextEditingController();
  final dateController = TextEditingController();
  @override

  Widget build(BuildContext context) {
        var dropdownProvider = Provider.of<DropdownProvider>(context);
// Providers
    final categoryProvider = Provider.of<CategoryProvider>( context);

    return   Scaffold(
      backgroundColor: backgroundColor,
       
      body: SafeArea(
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
                        top: heightPadding, bottom: heightPadding),
                   child: Align(
                       alignment: Alignment.topLeft,
                       child: Text('home.account'.tr()).extralargeBold()),
                 ),
                 
                 
              SizedBox(height: heightPadding,),
              SizedBox(height: heightPadding,),
              // expense amount  
             Text(
                              "home.i_spent".tr(),
                            ).smallLight(),
                                    SizedBox(height: heightPadding ,),
             CustomTextField(
              controller: amountEditingController,
              hint: 'pockets.eg1000'.tr(),
              title: '',
              keyboardType: TextInputType.number,
              
             ),
             SizedBox(height: heightPadding,),
             SizedBox(height: heightPadding,),
               Text(
                              "pockets.on".tr(),
                            ).smallLight(),
                                   SizedBox(height: heightPadding ,),
             CustomTextField(
              controller: titleEditingController,
              hint: 'pockets.pocket_title'.tr(),
              title: '',
              keyboardType: TextInputType.number,
              
             ),
           SizedBox(height: heightPadding,),
             SizedBox(height: heightPadding,),
            //  category
            Text(
                              "pockets.category".tr(),
                            ).smallLight(),
                                    SizedBox(height: heightPadding ,),
             CustomTextField(
              controller: categoryController,
              hint: dropdownProvider.selectedValue??'pockets.none_selected'.tr(),
              title: '',
              hasdropdown: true,
              dropdownItems: [
                DropdownItem(title: 'needs',),
                DropdownItem(title: 'wants',  ),
                DropdownItem(title: 'savings & investments', ),
                DropdownItem(title: 'debt',  ),
               
              ],
          
              
             ),
             SizedBox(height: heightPadding,),
             SizedBox(height: heightPadding,),
          
            //  date
            Text(
                            "home.on_date".tr(),
                            ).smallLight(),
                            SizedBox(height: heightPadding ,),
             ReusableDatePickerForm(controller: dateController,hintText: 'pockets.select_date'.tr(),),
             SizedBox(height: MediaQuery.of(context).size.height*.10,),
             
             GestureDetector(
  onTap: () {
    if (dropdownProvider.selectedValue == null ||
        amountEditingController.text.isEmpty ||
        dateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
        ),
      );
    } else {
      // Save the current expense and navigate back
      final newExpense = ExpenseModel(
        amount: double.parse(amountEditingController.text),
        title:titleEditingController.text,
        date: dateController.text,
        id: DateTime.now().toString(),
        pocket:  dropdownProvider.selectedValue!,
      );

      expenseRepository.saveTransaction(newExpense);
     Navigator.pop(context, 'added');
    }
  },
  child: Customelevatedbutton(
  
    textcolor: white,
    text: 'pockets.save'.tr(),
    onPressed: () {},
  ),
),

            //  GestureDetector(
            //   onTap: () {
            //    if (dropdownProvider.selectedValue!.isEmpty) {
            //      print('category is empty');
            //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            //           content: Text('Please fill all fields'),
            //         ));
            //    } else if (amountEditingController.text.isEmpty) {
            //      print('amount is empty');
            //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            //           content: Text('Please fill all fields'),
            //         ));
            //    } else if (dateController.text.isEmpty) {
            //      print('date is empty');
            //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            //           content: Text('Please fill all fields'),
            //         ));
                 
                  
            //       }  else{
            //            Navigator.pop(context);
            //        expenseRepository.saveTransaction(
            //         ExpenseModel(
            //          amount: double.parse(amountEditingController.text),
            //          category: dropdownProvider.selectedValue!,
            //          date:  dateController.text,
            //          id: DateTime.now().toString(),
            //          pocket: categoryProvider.selectedCategory 
            //        ));
             
              
            //       }
            //     },
            //    child: Customelevatedbutton(
            //     text: 'pockets.save'.tr(),
            //     onPressed: (){
                  
            //     }
                
            //    ),
            //  ),
              
            
                  
                ],
              ),
          )
        ),
    );
      
       
  }
}

 