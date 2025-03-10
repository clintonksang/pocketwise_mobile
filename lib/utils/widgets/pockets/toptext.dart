import 'package:flutter/material.dart';
import 'package:pocketwise/utils/constants/textutil.dart';

import '../../constants/colors.dart';
import '../../functions/timeofday.dart';

class Toptext extends StatelessWidget {
  final String firstName;

  const Toptext({
    super.key,
    required this.firstName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
            alignment: Alignment.topLeft,
            child: Text('good ${greeting()}').normal(color: secondaryColor)),
        Align(
            alignment: Alignment.topLeft,
            child: Text(firstName.toLowerCase()).normal()),
      ],
    );
  }
}
