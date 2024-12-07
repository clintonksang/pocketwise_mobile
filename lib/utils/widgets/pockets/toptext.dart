import 'package:flutter/material.dart';
import 'package:pocketwise/utils/constants/textutil.dart';

import '../../constants/colors.dart';
import '../../functions/timeofday.dart';

class Toptext extends StatelessWidget {
  const Toptext({super.key});

  @override
  Widget build(BuildContext context) {
     String firstName = 'clinton'.toLowerCase();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Align(
              alignment: Alignment.topLeft,
              child: Text('good ${greeting()}').normal(color: secondaryColor)),
         Align(
              alignment: Alignment.topLeft,
              child: Text(firstName).normal()),
      ],
    );
  }
}