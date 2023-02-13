import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Test extends StatelessWidget {
  Test({Key? key}) : super(key: key);

  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('dd/MM -- HH:mm');

  @override
  Widget build(BuildContext context) {
    final String formatted = formatter.format(now);
    print('===========================> $formatted');
    return Scaffold();
  }
}
