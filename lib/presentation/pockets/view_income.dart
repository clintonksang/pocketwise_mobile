import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pocketwise/models/income.model.dart';
import 'package:pocketwise/provider/income_provider.dart';
import 'package:pocketwise/utils/constants/colors.dart';
import 'package:pocketwise/utils/constants/customAppBar.dart';
import 'package:pocketwise/utils/constants/defaultPadding.dart';
import 'package:pocketwise/utils/constants/formatting.dart';
import 'package:pocketwise/utils/constants/textutil.dart';
import 'package:provider/provider.dart';

class ViewIncome extends StatelessWidget {
  const ViewIncome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(
            left: defaultPadding,
            right: defaultPadding,
            top: defaultPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(onPressed: () => Navigator.pop(context)),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: heightPadding),
                child: Text('income.income'.tr()).extralargeBold(),
              ),
              Expanded(
                child: Consumer<IncomeProvider>(
                  builder: (context, incomeProvider, _) {
                    final incomes = incomeProvider.incomes;

                    if (incomes.isEmpty) {
                      return Center(
                        child: Text(
                          'home.no_budget'.tr(),
                          style:
                              AppTextStyles.normal.copyWith(color: Colors.grey),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: incomes.length,
                      itemBuilder: (context, index) {
                        final income = incomes[index];
                        return Card(
                          margin: EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            title: Text(
                              income.income_from,
                              style: AppTextStyles.normal.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              DateFormat('MMM dd, yyyy').format(
                                DateTime.parse(income.date),
                              ),
                              style: AppTextStyles.smallLight,
                            ),
                            trailing: Text(
                              '${toLocaleString(income.amount)} kes',
                              style: AppTextStyles.normal.copyWith(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
