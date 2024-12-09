import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pocketwise/router/approuter.dart';
import 'package:pocketwise/utils/widgets/authentication/phoneField.dart';

import '../../utils/widgets/authentication/authpages.dart';

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  @override
  Widget build(BuildContext context) {
    return AuthPageManager(
      pagetitle: 'register.register'.tr(),
      onButtonPressed: (){
        Navigator.pushNamed(context, AppRouter.otpscreen);
      },
      buttontext: "home.continue".tr(),
      pagedescription: "register.description".tr() ,

      children: Column(
        children: [
          Phonefield(),
          
        ],
      ),
    );
  }
}