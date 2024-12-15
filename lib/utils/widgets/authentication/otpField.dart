import 'package:flutter/material.dart';
import 'package:pocketwise/utils/constants/colors.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../router/approuter.dart';

class OTPField extends StatefulWidget {
  final String verificationId;

  const OTPField({Key? key, required this.verificationId}) : super(key: key);

  @override
  State<OTPField> createState() => _OTPFieldState();
}

class _OTPFieldState extends State<OTPField> {
  String otp = '';
  final TextEditingController _otpController =
      TextEditingController(); // Added for controlling text input

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> verifyOTP() async {
    try {
      // Create a PhoneAuthCredential with the code
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otp,
      );

      // Sign in the user with the credential
      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.pushNamed(context, AppRouter.kycpage);

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text("Phone verification successful")),
      // );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to verify OTP: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      child: PinFieldAutoFill(
        controller: _otpController,
        codeLength: 6,
        decoration: BoxLooseDecoration(
          strokeColorBuilder: FixedColorBuilder(white),
          bgColorBuilder: FixedColorBuilder(white), // Light background
          gapSpace: 15.0,
          radius: const Radius.circular(10.0),
          textStyle: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        onCodeChanged: (String? code) {
          if (code != null && code.length == 6) {
            otp = code;
            verifyOTP(); // Verify OTP as soon as the code length matches
          }
        },
        onCodeSubmitted: (String code) {
          otp = code;
          verifyOTP(); // Also attempt verification when the code is submitted
        },
      ),
    );
  }
}
