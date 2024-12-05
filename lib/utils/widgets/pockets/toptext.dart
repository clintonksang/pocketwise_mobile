import 'package:flutter/material.dart';
import 'package:pockets/utils/constants/textutil.dart';

import '../../constants/colors.dart';
import '../../functions/timeofday.dart';

class Toptext extends StatelessWidget {
  const Toptext({super.key});

  @override
  Widget build(BuildContext context) {
     String firstName = 'Ruth'.toLowerCase();
    return Column(
      children: [
         Align(
              alignment: Alignment.topLeft,
              child: Text('good ${greeting()}').normal(color: secondaryColor)),
             Align(
              alignment: Alignment.topLeft,
              child: Text(firstName).extralargeBold()),
      ],
    );
  }
}