import 'package:flutter/material.dart';

class LogoBackground extends StatelessWidget {
  const LogoBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Opacity(
        opacity: .1,
        child: Image.asset(
          'assets/images/icon.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
