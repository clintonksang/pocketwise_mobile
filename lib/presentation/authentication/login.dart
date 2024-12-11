import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../router/approuter.dart';
import '../../utils/widgets/authentication/authpages.dart';
import '../../utils/widgets/authentication/phoneField.dart';
import '../../utils/widgets/pockets/textfield.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
// simulate mpesa transaction
  static const platform = MethodChannel('com.pocketwise.app/simulator');
  Future<void> sendTestTransaction() async {
    print("simulating transaction");
    try {
      final String result = await platform.invokeMethod('simulateTransaction', {
        "message":
            "SL71JZ3A6D Confirmed.You have received Ksh200.00 from Absa Bank Kenya PLC. 303031 on 7/12/24 at 12:01 PM New M-PESA balance is Ksh454.87. Separate personal and business funds through Pochi la Biashara on *334#."
      });
      print(result);
      print("transaction successful");
    } on PlatformException catch (e) {
      print("Failed to Invoke: '${e.message}'.");
    }
  }

  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPhoneSelected = true;
  @override
  Widget build(BuildContext context) {
    return AuthPageManager(
      pagetitle: 'login.login'.tr(),
      onButtonPressed: () {
        sendTestTransaction();
        // Navigator.pushNamed(context, AppRouter.pagemanager);
      },
      buttontext: 'login.login'.tr(),
      pagedescription: 'login.description'.tr(),
      children: Column(
        children: [
          SwitchListTile(
            title: Text(isPhoneSelected ? "Use Email" : "Use Phone"),
            value: isPhoneSelected,
            onChanged: (bool value) {
              setState(() {
                isPhoneSelected = value;
              });
            },
            secondary: Icon(!isPhoneSelected ? Icons.phone : Icons.email),
          ),
          isPhoneSelected
              ? Phonefield()
              : CustomTextField(
                  controller: phoneController,
                  hint: isPhoneSelected
                      ? "register.hint_phone".tr()
                      : "register.hint_email".tr(),
                  title:
                      isPhoneSelected ? "login.phone".tr() : "login.email".tr(),
                  keyboardType: TextInputType.phone,
                ),
          SizedBox(height: 20),
          CustomTextField(
            controller: passwordController,
            isPassword: true,
            hint: 'register.hint_password'.tr(),
            title: 'login.password'.tr(),
            keyboardType: TextInputType.text,
          ),
        ],
      ),
    );
  }
}
