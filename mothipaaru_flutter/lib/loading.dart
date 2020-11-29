import 'package:flutter/material.dart';

import 'dart:ui';

final themeColor = Color(0xfff5a623);
final primaryColor = Color(0xff203152);
final greyColor = Color(0xffaeaeae);
final greyColor2 = Color(0xffE8E8E8);

class Loading extends StatelessWidget {
  
  const Loading();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(themeColor),
        ),
      ),
      color: Colors.white.withOpacity(0.8),
    );
  }
}