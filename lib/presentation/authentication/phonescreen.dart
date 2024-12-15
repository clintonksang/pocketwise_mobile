import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pocketwise/repository/auth/firebase_auth.dart';
import 'package:pocketwise/router/approuter.dart';
import 'package:pocketwise/utils/widgets/authentication/phoneField.dart';

import '../../utils/constants/customsnackbar.dart';
import '../../utils/widgets/authentication/authpages.dart';

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  bool validphone = false;

  String phoneNum = "";
  validatePhone(String phone) {
    if (phone.length != 9) {
      setState(() {
        validphone = false;
      });
      return 'Enter a valid phone number (9 digits)';
    } else {
      setState(() {
        validphone = true;
        phoneNum = "+254" + phone;
      });
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController phoneController = TextEditingController();
    Auth auth = Auth();
    return AuthPageManager(
      pagetitle: 'register.register'.tr(),
      onButtonPressed: () {
        validatePhone(phoneController.text);
        if (validphone) {
          auth.signInWithPhone(
            phoneNum,
            context,
            (verificationId, resendToken) => Navigator.pushNamed(
                context, AppRouter.otpscreen,
                arguments: verificationId),
            (errorMessage) => showCustomSnackbar(context, errorMessage),
          );
        } else {
          showCustomSnackbar(
              context, 'Please enter a valid phone number (9 digits)');
        }
      },
      buttontext: "home.continue".tr(),
      pagedescription: "register.description".tr(),
      children: Column(
        children: [
          Phonefield(phoneController: phoneController),
        ],
      ),
    );
  }
}
