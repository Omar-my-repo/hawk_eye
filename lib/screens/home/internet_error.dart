import 'package:flutter/material.dart';

class InternetError extends StatelessWidget {
  const InternetError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.black,
      height: MediaQuery.of(context).size.height * .5,
      child: Center(
        child: Text(
          'لا يوجد إتصال بالإنترنت',
          style: TextStyle(fontSize: 24, color: Colors.red),
        ),
      ),
    );
  }
}
