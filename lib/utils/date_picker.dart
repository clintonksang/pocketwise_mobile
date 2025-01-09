import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ReusableDatePickerForm extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  ReusableDatePickerForm({
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 8, left: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Flexible(
            //   flex: 1,
            //   child: Align(
            //     alignment: Alignment.topLeft,
            //     child: Text(
            //       hintText,
            //       style: TextStyle(
            //         fontSize: 10,
            //         fontWeight: FontWeight.w600,
            //         color: Colors.black,
            //       ),
            //     ),
            //   ),
            // ),
            Flexible(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 2,
                      child: TextFormField(
                        controller: controller,
                        decoration: InputDecoration(
                          hintText: hintText,
                          border: InputBorder.none,
                        ),
                        readOnly: true,
                        onTap: () => _selectDate(context),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '$hintText cannot be empty';
                          }
                          return null;
                        },
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime today = DateTime.now();
    DateTime thirtyDaysAgo = today.subtract(Duration(days: 30));

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: thirtyDaysAgo,
      lastDate: today,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue,
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      String formattedDate = _formatDate(pickedDate);
      controller.text = formattedDate;
    }
  }

  _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }
}
