import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../repository/auth/firebase_auth.dart';
import '../../router/approuter.dart';
import '../../utils/constants/customsnackbar.dart';
import '../../utils/widgets/authentication/authpages.dart';
import '../../utils/widgets/pockets/textfield.dart';

class EnterKYCPage extends StatefulWidget {
  const EnterKYCPage({super.key});

  @override
  State<EnterKYCPage> createState() => _EnterKYCPageState();
}

class _EnterKYCPageState extends State<EnterKYCPage> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  final Auth auth = Auth();
  bool isLoading = false;

  // Password strength indicators
  bool hasUpperCase = false;
  bool hasLowerCase = false;
  bool hasSpecialChar = false;
  bool hasMinLength = false;

  @override
  void initState() {
    super.initState();
    passwordController.addListener(updatePasswordStrength);
  }

  @override
  void dispose() {
    passwordController.removeListener(updatePasswordStrength);
    super.dispose();
  }

  void updatePasswordStrength() {
    setState(() {
      final password = passwordController.text;
      hasUpperCase = password.contains(RegExp(r'[A-Z]'));
      hasLowerCase = password.contains(RegExp(r'[a-z]'));
      hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
      hasMinLength = password.length >= 8;
    });
  }

  bool isPasswordStrong() {
    return hasUpperCase && hasLowerCase && hasSpecialChar && hasMinLength;
  }

  Future<void> sendEmailVerification(User user) async {
    try {
      await user.sendEmailVerification();
      print("Verification email sent.");
    } catch (e) {
      print("Failed to send verification email: $e");
      throw Exception(e);
    }
  }

  bool isValidEmail(String email) =>
      RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(email);

  void saveUserData(String uid, Map<String, dynamic> userData) {
    // Save user data to Firestore
    FirebaseFirestore.instance.collection('users').doc(uid).set(userData);
    // Save user data to SharedPreferences
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('uid', uid);
      prefs.setString('firstname', userData['firstname']);
      prefs.setString('lastname', userData['lastname']);
      prefs.setString('email', userData['email']);
      prefs.setString('phoneNumber', userData['phoneNumber']);
      prefs.setBool('verified', userData['verified']);
    });
  }

  Future<String?> getPhoneNumber() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('phone');
  }

  void registerUser() async {
    setState(() {
      isLoading = true;
    });

    try {
      await auth.registerWithEmailPassword(
          emailController.text, passwordController.text);
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await sendEmailVerification(user);

        final String? phoneNumber = await getPhoneNumber();
        if (phoneNumber != null) {
          // Save user data to Firestore
          saveUserData(phoneNumber, {
            'firstname': firstnameController.text,
            'lastname': lastnameController.text,
            'email': emailController.text,
            "phoneNumber": phoneNumber,
            "verified": false
          });
        }

        showCustomSnackbar(context,
            "Registration successful, Please check your email for verification.");
        Navigator.pushReplacementNamed(context, AppRouter.login);
      }
    } catch (error) {
      showCustomSnackbar(context, "Registration failed: $error");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void checkFieldsAndNavigate() {
    String errorMessage = '';
    if (firstnameController.text.isEmpty) {
      errorMessage = 'Please enter your first name.';
    } else if (lastnameController.text.isEmpty) {
      errorMessage = 'Please enter your last name.';
    } else if (emailController.text.isEmpty ||
        !isValidEmail(emailController.text)) {
      errorMessage = 'Please enter a valid email address.';
    } else if (passwordController.text.isEmpty) {
      errorMessage = 'Please enter a password.';
    } else if (!isPasswordStrong()) {
      errorMessage = 'Please ensure your password meets all requirements.';
    } else if (confirmpasswordController.text.isEmpty) {
      errorMessage = 'Please confirm your password.';
    } else if (passwordController.text != confirmpasswordController.text) {
      errorMessage = 'Passwords do not match.';
    }

    if (errorMessage.isNotEmpty) {
      showCustomSnackbar(context, errorMessage);
    } else {
      registerUser();
    }
  }

  Widget _buildPasswordRequirements() {
    return Container(
      margin: EdgeInsets.only(top: 8, bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Password requirements:',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 4),
          _buildRequirement('At least 8 characters', hasMinLength),
          _buildRequirement('Contains uppercase letter', hasUpperCase),
          _buildRequirement('Contains lowercase letter', hasLowerCase),
          _buildRequirement('Contains special character', hasSpecialChar),
        ],
      ),
    );
  }

  Widget _buildRequirement(String text, bool isMet) {
    return Row(
      children: [
        Icon(
          isMet ? Icons.check_circle : Icons.circle_outlined,
          size: 16,
          color: isMet ? Colors.green : Colors.grey,
        ),
        SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: isMet ? Colors.green : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthPageManager(
      pagetitle: 'register.enter_details'.tr(),
      onButtonPressed: checkFieldsAndNavigate,
      buttontext: "register.sign_up".tr(),
      pagedescription: 'register.enter_details'.tr(),
      children: Column(
        children: [
          isLoading
              ? Column(
                  children: [
                    CircularProgressIndicator(),
                    Text('register.please_wait'.tr())
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextField(
                      controller: firstnameController,
                      width: MediaQuery.of(context).size.width * .42,
                      hint: 'register.hint_first_name'.tr(),
                      title: 'register.first_name'.tr(),
                      keyboardType: TextInputType.text,
                    ),
                    CustomTextField(
                      controller: lastnameController,
                      width: MediaQuery.of(context).size.width * .42,
                      hint: 'register.hint_last_name'.tr(),
                      title: 'register.last_name'.tr(),
                      keyboardType: TextInputType.text,
                    ),
                  ],
                ),
          SizedBox(height: 15),
          CustomTextField(
            controller: emailController,
            width: MediaQuery.of(context).size.width,
            hint: 'register.hint_email'.tr(),
            title: 'register.email'.tr(),
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 15),
          CustomTextField(
            controller: passwordController,
            width: MediaQuery.of(context).size.width,
            isPassword: true,
            hint: 'register.enter_password'.tr(),
            title: 'register.password'.tr(),
            keyboardType: TextInputType.text,
          ),
          SizedBox(height: 15),
          CustomTextField(
            controller: confirmpasswordController,
            width: MediaQuery.of(context).size.width,
            isPassword: true,
            hint: 'register.hint_confirm_password'.tr(),
            title: 'register.confirm_password'.tr(),
            keyboardType: TextInputType.text,
          ),
          _buildPasswordRequirements(),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}
