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

  Future<void> simulateExpense() async {
    try {
      final String userId = "12345"; // This should be dynamically assigned
      final String result =
          await platform.invokeMethod('simulateExpenseSMS', {'USERID': userId});
      print(result);
    } on PlatformException catch (e) {
      print("Failed to invoke method: '${e.message}'.");
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
        //  SIMULATE HERE
        simulateExpense();
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
