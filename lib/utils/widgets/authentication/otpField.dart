import 'package:flutter/material.dart';
import 'package:pocketwise/utils/constants/colors.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OTPField extends StatefulWidget {
  const OTPField({super.key});

  @override
  State<OTPField> createState() => _OTPFieldState();
}

class _OTPFieldState extends State<OTPField> {
  // otp
  String otp = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      child: PinFieldAutoFill(
        codeLength: 5,
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
          if (code != null && code.length == 5) {
            otp = code;
            print('Entered OTP: $otp');
          }
        },
        onCodeSubmitted: (String code) {
          otp = code;
          print('Final OTP: $otp');
        },
      ),
    );
  }
}
