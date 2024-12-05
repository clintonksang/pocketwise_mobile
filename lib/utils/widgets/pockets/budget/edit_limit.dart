
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pockets/utils/constants/colors.dart';
import 'package:pockets/utils/constants/customAppBar.dart';
import 'package:pockets/utils/constants/textutil.dart';
import 'package:pockets/utils/widgets/pockets/customElevatedButton.dart';
import 'package:pockets/utils/widgets/pockets/textfield.dart';
import 'package:provider/provider.dart';

import '../../../../provider/dropdown_provider.dart';
import '../../../../repository/budget.repo.dart';
import '../../../constants/customsnackbar.dart';
import '../../../constants/defaultPadding.dart';

// class EditLimit extends StatelessWidget {
//   final String title;
//  final String amount;
//   const EditLimit({super.key, required this.amount, required this.title});

//   @override
//   Widget build(BuildContext context) {
//             final dropdownProvider = Provider.of<DropdownProvider>(context);

//     TextEditingController categoryEditingController = TextEditingController();
//     return   Container(
//       height: MediaQuery.of(context).size.height*.7,
//              margin: const EdgeInsets.only(
//                   left: defaultPadding, right: defaultPadding, top: defaultPadding),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   // AppBar
//                    CustomAppBar(onPressed: (){
//                     print('Pop');
//                         Navigator.pop(context);
//                       }),
              
//                  Padding(
//                   padding: const EdgeInsets.only(
//                         top: heightPadding, bottom: heightPadding),
//                    child: Align(
//                        alignment: Alignment.topLeft,
//                        child: Text('pockets.edit_limit'.tr()).extralargeBold()),
//                  ),
//                  Text("Category: $title").normal(),
//                  Text("Current Limit: $amount").normal(),
                 
//               SizedBox(height: heightPadding,),
//               // expense amount  
             
//              CustomTextField(
//               controller: categoryEditingController,
//               hint: 'pockets.limit'.tr(),
//               title: '',

//               keyboardType: TextInputType.phone,
              
//              ),
//              SizedBox(height: heightPadding,),

            
//              SizedBox(height: heightPadding,),

            

//              GestureDetector(
//               onTap: () {
//                 dropdownProvider.setSelectedValue(categoryEditingController.text);
//                  Navigator.pop(context);
//                 },
//                child: Customelevatedbutton(
//                 text: 'pockets.save'.tr(),
//                 onPressed: (){}
                
//                ),
//              ),
              
            
                  
//                 ],
//               ),
//           );
//   }
// }
 
class EditLimit extends StatefulWidget {
  final String title;
  final double limitAmount;
  final String type;

  const EditLimit({Key? key, required this.type, required this.limitAmount, required this.title}) : super(key: key);

  @override
  _EditLimitState createState() => _EditLimitState();
}

class _EditLimitState extends State<EditLimit> {
  late TextEditingController limitController;

  @override
  void initState() {
    super.initState();
    limitController = TextEditingController(text: widget.limitAmount.toString());
  }

  @override
  Widget build(BuildContext context) {
    final budgetRepo = Provider.of<BudgetRepository>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text('Edit ${widget.title} Limit')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: limitController,
              decoration: InputDecoration(labelText: 'New Limit'),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )
              ),
              onPressed: () {
                double? newLimit = double.tryParse(limitController.text);
                budgetRepo.updateCategoryLimitAndRate(widget.type, newLimit!, context);
Navigator.pop(context);
showCustomSnackbar(context, 'Limit updated successfully\nOther budgets will be adjusted proportionately.');
              },
              child: Text('Save', style: TextStyle(color: white),),
            )
          ],
        ),
      ),
    );
  }
}
