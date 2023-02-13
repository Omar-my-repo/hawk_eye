import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Widget defaultTextField({
  required TextEditingController controller,
  required FormFieldValidator<String> validator,
  required String labelText,
  bool obscureText = false,
  IconData? prefixIcon,
  var suffixIcon,
}) {
  return TextFormField(
    controller: controller,
    validator: validator,
    obscureText: obscureText,
    style: TextStyle(fontSize: 22),
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Colors.black,
          width: 1.5,
        ),
      ),
      prefixIcon: Icon(prefixIcon),
      suffixIcon: suffixIcon,
    ),
  );
}

showToast({required errorMessage}) {
  return Fluttertoast.showToast(
      msg: errorMessage,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 4,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0);
}
