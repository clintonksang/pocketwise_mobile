import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pocketwise/models/income.model.dart';
import 'package:pocketwise/provider/dropdown_provider.dart';
import 'package:pocketwise/utils/constants/colors.dart';
import 'package:pocketwise/utils/constants/customAppBar.dart';
import 'package:pocketwise/utils/constants/customsnackbar.dart';
import 'package:pocketwise/utils/constants/defaultPadding.dart';
import 'package:pocketwise/utils/constants/textutil.dart';
import 'package:pocketwise/utils/noInternet.dart';
import 'package:pocketwise/utils/widgets/pockets/customElevatedButton.dart';
import 'package:pocketwise/utils/widgets/pockets/textfield.dart';
import 'package:provider/provider.dart';
import '../../provider/category_provider.dart';
import '../../provider/income_provider.dart';
import '../../utils/globals.dart';
import '../../utils/widgets/pockets/dropdown.dart';

class AddIncome extends StatefulWidget {
  const AddIncome({super.key});

  @override
  State<AddIncome> createState() => _AddIncomeState();
}

class _AddIncomeState extends State<AddIncome> {
  final categoryController = TextEditingController();
  final amountEditingController = TextEditingController();
  final sourceController = TextEditingController();
  // List to keep track of incomes
  // totalIncome
  double totalIncome = 0.0;

  List<IncomeModel> incomeEntries = [];

  @override
  Widget build(BuildContext context) {
    var dropdownProvider = Provider.of<DropdownProvider>(context);

    void saveEntries() {
      if (dropdownProvider.selectedValue == null ||
          amountEditingController.text.isEmpty ||
          sourceController.text.isEmpty) {
        Future.microtask(
            () => CustomSnackbar(message: 'All fields are required'));
        return;
      }

      if (incomeEntries
          .any((income) => income.income_from == sourceController.text)) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Warning'),
            content: Text('You have already added ${sourceController.text}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        return;
      }

      final newIncome = IncomeModel(
        amount: double.parse(amountEditingController.text),
        date: DateTime.now().toIso8601String(),
        id: DateTime.now().toString(),
        income_from: sourceController.text,
      );

      setState(() {
        incomeEntries.add(newIncome);
        totalIncome += double.parse(amountEditingController.text);
      });

      Provider.of<IncomeProvider>(context, listen: false).addIncome(newIncome);

      amountEditingController.clear();
      sourceController.clear();
      categoryController.clear();
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(
                left: defaultPadding,
                right: defaultPadding,
                top: defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(onPressed: () => Navigator.pop(context)),
                Padding(
                  padding: const EdgeInsets.only(
                      top: heightPadding, bottom: heightPadding),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text('income.income'.tr()).extralargeBold(),
                  ),
                ),
                // List of incomes
                if (incomeEntries.isNotEmpty) ...[
                  SizedBox(height: heightPadding),
                  //  Total
                  Row(
                    children: [
                      Text("income.total_income".tr()).smallLight(),
                      SizedBox(width: heightPadding),
                      Text(
                        totalIncome.toString(),
                        style: AppTextStyles.medium.copyWith(
                            color: black, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: incomeEntries
                          .take(5)
                          .map((income) => Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    income.income_from,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ],
                SizedBox(height: heightPadding),
                CustomTextField(
                  controller: amountEditingController,
                  hint: 'pockets.eg1000'.tr(),
                  title: '',
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: heightPadding),
                CustomTextField(
                  controller: sourceController,
                  hint: 'income.from'.tr(),
                  title: '',
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: heightPadding),
                CustomTextField(
                  controller: categoryController,
                  hint:
                      dropdownProvider.selectedValue ?? 'income.frequency'.tr(),
                  title: '',
                  hasdropdown: true,
                  dropdownItems: [
                    DropdownItem(title: 'Monthly'),
                    DropdownItem(title: 'Weekly'),
                    DropdownItem(title: 'Daily'),
                  ],
                ),

                SizedBox(height: defaultPadding),
                Customelevatedbutton(
                  color: Colors.white,
                  text: 'income.add_another'.tr(),
                  onPressed: noInternet() ? null : saveEntries,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * .20),
                Customelevatedbutton(
                  color: primaryColor,
                  text: 'pockets.save'.tr(),
                  textcolor: white,
                  onPressed: noInternet() ? null : saveEntries,
                ),
                Container(height: 500)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
