import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pocketwise/repository/auth/firebase_auth.dart';
import 'package:pocketwise/router/approuter.dart';
import 'package:pocketwise/utils/widgets/authentication/phoneField.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/constants/customsnackbar.dart';
import '../../utils/widgets/authentication/authpages.dart';

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
     Auth auth = Auth(); 
  bool validphone = false;
  bool isLoading = false;   
  String phoneNum = "";
  TextEditingController phoneController = TextEditingController();  

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

  Future<void> _savePhone(String phoneN) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('phone', phoneN);
  }

  void initiateSignIn() {
    validatePhone(phoneController.text);
    if (validphone) {
      _savePhone(phoneNum);
      setState(() {
        isLoading = true;  
      });
      auth.signInWithPhone(
        phoneNum,
        context,
        (verificationId, resendToken) {
          setState(() {
            isLoading = false;  
          });
          Navigator.pushNamed(context, AppRouter.otpscreen, arguments: verificationId);
        },
        (errorMessage) {
          setState(() {
            isLoading = false;  
          });
          showCustomSnackbar(context, errorMessage);
        },
      );
    } else {
      showCustomSnackbar(context, 'Please enter a valid phone number (9 digits)');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthPageManager(
      pagetitle: 'register.register'.tr(),
      onButtonPressed: initiateSignIn,
      buttontext: "home.continue".tr(),
      pagedescription: "register.description".tr(),
      children: Column(
        children: [
          Phonefield(phoneController: phoneController),
          isLoading ? CircularProgressIndicator() : Container(), // Show loader when `isLoading` is true
        ],
      ),
    );
  }
}
