import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../router/approuter.dart';
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
  TextEditingController emailController  = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AuthPageManager(
      pagetitle: 'register.enter_details'.tr(),
      onButtonPressed: (){
       Navigator.pushNamed(context, AppRouter.login);
      },
      buttontext: "register.sign_up".tr(),
      pagedescription:'register.enter_details'.tr(),
      children: Column(children: [

        // firstname /lastname
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomTextField(
                  controller: firstnameController,
                  width: MediaQuery.of(context).size.width*.42,
                  
                  hint: 'register.hint_first_name'.tr(),
                  title:'register.first_name'.tr(),
                  keyboardType: TextInputType.text,
                  
                 ),

            CustomTextField(
                  controller: lastnameController,
                  width: MediaQuery.of(context).size.width*.42,
                  
                  hint: 'register.hint_last_name'.tr(),
                  title:'register.last_name'.tr(),
                  keyboardType: TextInputType.text,
                  
                 ),
          ],
        ),
SizedBox(height: 15,),
        //  email
    CustomTextField(
              controller: emailController,
              width: MediaQuery.of(context).size.width,
              hint: 'register.hint_email'.tr(),
              title:'register.email'.tr(),
              keyboardType: TextInputType.text,
              
              ),
              SizedBox(height: 15,),

    //  password
    CustomTextField(
              controller: passwordController,
              width: MediaQuery.of(context).size.width,
              isPassword: true,
              hint: 'register.enter_password'.tr(),
              title: 'register.password'.tr(),
              keyboardType: TextInputType.text,
              
             ),
             SizedBox(height: 15,),

      // confirm password
      CustomTextField(
              controller: confirmpasswordController,
              width: MediaQuery.of(context).size.width,
              isPassword: true,
              hint: 'register.hint_confirm_password'.tr(),
              title:'register.confirm_password'.tr(),
              keyboardType: TextInputType.text,
              
             ),
             SizedBox(height: 15,),





      ],),
    );
  }
}