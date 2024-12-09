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
class CustomTextField extends StatefulWidget {
  final String? title;
  final String hint;
  double width;
  final bool hasdropdown;
  final bool hasOptions;
  final String option1;
  final String option2;
  final bool isPassword;  
  final TextInputType keyboardType;
  final List<DropdownItem> dropdownItems;
  final TextEditingController controller;

  CustomTextField({
    super.key,
    required this.title,
    this.width = double.infinity,
    this.hasdropdown = false,
    this.hasOptions = false,
    this.isPassword = false, // Default value is false
    this.keyboardType = TextInputType.text,
    this.dropdownItems = const [],
    this.option1 = '',
    this.option2 = '',
    required this.hint,
    required this.controller,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isObscured = true; // For toggling password visibility

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: widget.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: white,
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 8, left: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (widget.title != null)
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    widget.title!,
                    style: AppTextStyles.medium.copyWith(fontSize: 10),
                  ),
                ),
              ),
            Expanded(
              flex: 1,
              child: widget.hasdropdown
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: IconDropdown(
                            items: widget.dropdownItems,
                            onChanged: (value) {
                              print('Selected category: $value');
                              if (value == 'add new category') {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return AddCategory();
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    )
                  : widget.hasOptions
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: CardButtons(
                                cardColor: primaryColor,
                                text: widget.option1,
                                small: false,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: CardButtons(
                                cardColor: primaryColor,
                                text: widget.option2,
                                small: false,
                              ),
                            ),
                            const Spacer(),
                          ],
                        )
                      : Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            FieldItems(
                              hintText: widget.hint,
                              inputType: TextInputType.text,
                              isBorderVisible: false,
                              keyboardType: widget.isPassword
                                  ? TextInputType.visiblePassword
                                  : widget.keyboardType,
                              controller: widget.controller,
                              obscureText: widget.isPassword ? isObscured : false,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '${widget.title} cannot be empty';
                                }
                                return null;
                              },
                            ),
                            if (widget.isPassword)
                              IconButton(
                                icon: Icon(
                                  isObscured
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isObscured = !isObscured;
                                  });
                                },
                              ),
                          ],
                        ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}


 

class AddCategory extends StatelessWidget {
  final TextEditingController categoryController = TextEditingController();

  AddCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Close button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Add New Category',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context); // Close the bottom sheet
                },
              ),
            ],
          ),
          SizedBox(height: 16.0),

          // Category Name TextField
          Text(
            'Category Name',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 8.0),
          TextField(
            controller: categoryController,
            decoration: InputDecoration(
              hintText: 'Enter category name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
          SizedBox(height: 16.0),

          // Save Button
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                String newCategory = categoryController.text.trim();
                if (newCategory.isNotEmpty) {
                  // Perform your save logic here
                  print('Category Saved: $newCategory');
                  Navigator.pop(context, newCategory); // Pass new category back
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter a category name'),
                    ),
                  );
                }
              },
              child: Text('Save Category'),
            ),
          ),
        ],
      ),
    );
  }
}
