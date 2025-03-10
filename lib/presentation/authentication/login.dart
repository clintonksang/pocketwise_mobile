import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../repository/auth/firebase_auth.dart';
import '../../router/approuter.dart';
import '../../utils/globals.dart';
import '../../utils/widgets/authentication/authpages.dart';
import '../../utils/widgets/authentication/phoneField.dart';
import '../../utils/widgets/pockets/textfield.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPhoneSelected = false;
  bool isLoading = false;
  String phoneFromCache = '';
  final logger = Logger();
  DateTime? lastBackPressTime;

  @override
  void initState() {
    super.initState();
    _prefillPhone();
    _getPhone();
  }

  Future<void> _prefillPhone() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    phoneController.text = prefs.getString('phone') ?? '';
  }

  Future<void> _getPhone() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      phoneFromCache = prefs.getString('phone') ?? '';
    });
  }

  Future<bool> _onWillPop() async {
    final now = DateTime.now();
    if (lastBackPressTime == null ||
        now.difference(lastBackPressTime!) > Duration(seconds: 2)) {
      lastBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Press back again to exit'),
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: AuthPageManager(
        pagetitle: 'login.login'.tr(),
        onButtonPressed: () {
          if (isPhoneSelected) {
            phoneLogin();
          } else {
            emailLogin();
          }
        },
        buttontext: 'login.login'.tr(),
        pagedescription: 'login.description'.tr(),
        children: Column(
          children: [
            // SwitchListTile(
            //   title: Text(isPhoneSelected ? "Use Email" : "Use Phone"),
            //   value: !isPhoneSelected,
            //   onChanged: (bool value) {
            //     setState(() {
            //       isPhoneSelected = !value;
            //     });
            //   },
            //   secondary: Icon(isPhoneSelected ? Icons.phone : Icons.email),
            // ),
            // isPhoneSelected
            //     ? Phonefield(
            //         phoneController: phoneController,
            //       )
            // :
            CustomTextField(
              controller: phoneController,
              hint: "register.hint_email".tr(),
              title: "login.email".tr(),
              keyboardType: isPhoneSelected
                  ? TextInputType.phone
                  : TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            CustomTextField(
              controller: passwordController,
              isPassword: true,
              hint: 'register.hint_password'.tr(),
              title: 'login.password'.tr(),
              keyboardType: TextInputType.text,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => forgotPassword(),
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
            isLoading
                ? CircularProgressIndicator()
                : SizedBox.shrink(), // Loader display
          ],
        ),
      ),
    );
  }

  bool isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(email);
  }

  void emailLogin() async {
    setState(() {
      isLoading = true;
    });

    logger.i('Starting login process with email: ${phoneController.text}');

    if (isValidEmail(phoneController.text) &&
        passwordController.text.isNotEmpty) {
      try {
        logger.d('Attempting Firebase authentication...');
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: phoneController.text,
          password: passwordController.text,
        );

        logger.i('Firebase auth successful, checking user verification status');
        User? user = userCredential.user;

        if (user != null) {
          logger.d('User found: ${user.uid}');
          logger.d('Email verified: ${user.emailVerified}');

          if (user.emailVerified) {
            logger.i('User email is verified, checking phone number...');

            // Check if we have phone number in cache
            if (phoneFromCache.isEmpty) {
              // Show dialog to enter phone number
              String? enteredPhone = await showDialog<String>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  TextEditingController phoneController =
                      TextEditingController();
                  String errorText = '';

                  return StatefulBuilder(builder: (context, setState) {
                    return AlertDialog(
                      title: Text('Phone Verification Required'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Please enter your phone number to continue'),
                          SizedBox(height: 10),
                          Phonefield(phoneController: phoneController),
                          if (errorText.isNotEmpty)
                            Text(
                              errorText,
                              style: TextStyle(color: Colors.red),
                            ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            String phone = phoneController.text;
                            if (phone.length != 9) {
                              setState(() {
                                errorText =
                                    'Please enter a valid phone number (9 digits)';
                              });
                              return;
                            }

                            // Check if phone exists in Firestore
                            final querySnapshot = await FirebaseFirestore
                                .instance
                                .collection('users')
                                .where('phoneNumber', isEqualTo: "+254$phone")
                                .get();

                            if (querySnapshot.docs.isNotEmpty) {
                              Navigator.of(context).pop("+254$phone");
                            } else {
                              setState(() {
                                errorText = 'Phone number not found';
                              });
                            }
                          },
                          child: Text('Verify'),
                        ),
                      ],
                    );
                  });
                },
              );

              if (enteredPhone == null) {
                setState(() {
                  isLoading = false;
                });
                return;
              }

              // Save the verified phone number
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              await prefs.setString('phone', enteredPhone);
              phoneFromCache = enteredPhone;
              print("enteredPhone : $enteredPhone");
              await saveUserIDToNative(enteredPhone);
            }

            try {
              logger.d(
                  'Attempting to update Firestore document for email: ${user.email}');

              // First check if user exists by email field
              final querySnapshot = await FirebaseFirestore.instance
                  .collection('users')
                  .where('email', isEqualTo: user.email)
                  .get();

              if (querySnapshot.docs.isEmpty) {
                logger
                    .w('User document not found, checking by phone number...');
                // Try finding by phone number
                if (phoneFromCache.isNotEmpty) {
                  final querySnapshot = await FirebaseFirestore.instance
                      .collection('users')
                      .where('phoneNumber', isEqualTo: phoneFromCache)
                      .get();

                  if (querySnapshot.docs.isNotEmpty) {
                    await querySnapshot.docs.first.reference
                        .update({"verified": true, "email": user.email});
                    logger.i('Updated user document by phone number');
                  } else {
                    throw Exception('No user document found for this account');
                  }
                } else {
                  throw Exception(
                      'No user document found and no phone number available');
                }
              } else {
                // Update the existing document using the found document's reference
                await querySnapshot.docs.first.reference
                    .update({"verified": true, "email": user.email});
                logger.i('Updated user document by email');
              }

              logger.d('Saving user ID to native storage...');
              await saveUserIDToNative(user.email!);

              logger.d('Updating SharedPreferences...');
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              await prefs.setBool('isLoggedIn', true);
              await prefs.setString('email', user.email!);

              logger.i(
                  'All login steps completed successfully, navigating to page manager');
              Navigator.pushReplacementNamed(context, AppRouter.pagemanager);
            } catch (firestoreError) {
              logger.e('Error updating Firestore:',
                  error: firestoreError, stackTrace: StackTrace.current);
              showErrorDialog(
                  'Error updating user data: ${firestoreError.toString()}');
            }
          } else {
            logger.w('User email is not verified');
            showErrorDialog('Please verify your email before logging in.');
          }
        } else {
          logger.e('User object is null after successful authentication');
          showErrorDialog('Authentication error. Please try again.');
        }
      } on FirebaseAuthException catch (e) {
        logger.e('Firebase Auth Exception:',
            error: e, stackTrace: e.stackTrace);
        handleFirebaseAuthError(e);
      } catch (e, stackTrace) {
        logger.e('Unexpected error during login:',
            error: e, stackTrace: stackTrace);
        showErrorDialog('An unexpected error occurred. Please try again.');
      }
    } else {
      logger.w('Invalid email or empty password');
      showErrorDialog('Please enter a valid email and password.');
    }

    setState(() {
      isLoading = false;
    });
  }

  void phoneLogin() async {
    setState(() {
      isLoading = true;
    });

    logger.i('Starting login process with phone: ${phoneController.text}');

    if (phoneController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      try {
        logger.d('Attempting Firestore query for phone number...');
        final querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('phone', isEqualTo: phoneController.text)
            .get();

        if (querySnapshot.docs.isEmpty) {
          logger.w('No user found with this phone number');
          showErrorDialog('No account found with this phone number.');
          setState(() {
            isLoading = false;
          });
          return;
        }

        final userDoc = querySnapshot.docs.first;
        final userData = userDoc.data();

        if (userData['email'] == null) {
          logger.e('User document has no associated email');
          showErrorDialog(
              'Account error: No email associated with this phone number.');
          setState(() {
            isLoading = false;
          });
          return;
        }

        logger.d('Found user document, attempting Firebase authentication...');
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: userData['email'],
          password: passwordController.text,
        );

        User? user = userCredential.user;
        if (user != null) {
          logger.d('User authenticated successfully');

          // Update SharedPreferences
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('phone', phoneController.text);
          await prefs.setString('email', userData['email']);

          // Save user ID
          await saveUserIDToNative(phoneController.text);

          logger.i('Login successful, navigating to page manager');
          Navigator.pushReplacementNamed(context, AppRouter.pagemanager);
        }
      } on FirebaseAuthException catch (e) {
        logger.e('Firebase Auth Exception:',
            error: e, stackTrace: e.stackTrace);
        handleFirebaseAuthError(e);
      } catch (e, stackTrace) {
        logger.e('Unexpected error during login:',
            error: e, stackTrace: stackTrace);
        showErrorDialog('An unexpected error occurred. Please try again.');
      }
    } else {
      logger.w('Empty phone or password');
      showErrorDialog('Please enter your phone number and password.');
    }

    setState(() {
      isLoading = false;
    });
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error Signin in'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void handleFirebaseAuthError(FirebaseAuthException e) {
    String errorMessage;
    switch (e.code) {
      case 'user-not-found':
        errorMessage = 'No user found for that email.';
        break;
      case 'wrong-password':
        errorMessage = 'Wrong password provided for that user.';
        break;
      case 'user-disabled':
        errorMessage = 'This user has been disabled.';
        break;
      case 'too-many-requests':
        errorMessage = 'Too many requests. Try again later.';
        break;
      case 'operation-not-allowed':
        errorMessage = 'Signing in with Email and Password is not enabled.';
        break;
      default:
        errorMessage = 'Login failed: ${e.message}';
        break;
    }
    showErrorDialog(errorMessage);
  }

  void forgotPassword() async {
    if (!isValidEmail(phoneController.text)) {
      showErrorDialog('Please enter a valid email address first.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: phoneController.text,
      );
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Password Reset'),
          content: Text('Password reset link has been sent to your email.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for that email.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is invalid.';
          break;
        default:
          errorMessage = 'Error: ${e.message}';
          break;
      }
      showErrorDialog(errorMessage);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
