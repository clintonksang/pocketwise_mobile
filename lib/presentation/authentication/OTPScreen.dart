import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pocketwise/utils/widgets/authentication/otpField.dart';

import '../../router/approuter.dart';
import '../../utils/widgets/authentication/authpages.dart';

class OtpScreen extends StatelessWidget {
  final String verificationCode;
  const OtpScreen({super.key, required this.verificationCode});

  @override
  Widget build(BuildContext context) {
    return AuthPageManager(
      pagetitle: 'register.verify_phone'.tr(),
      onButtonPressed: () {
        Navigator.pushNamed(context, AppRouter.kycpage);
      },
      buttontext: "home.continue".tr(),
      pagedescription: "register.enter_otp".tr(),
      children: Column(
        children: [OTPField(verificationId: verificationCode)],
      ),
    );
  }
}
