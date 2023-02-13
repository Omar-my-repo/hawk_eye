// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:maps/controllers/login/login_cubit.dart';
// import 'package:maps/controllers/login/login_states.dart';
// import 'package:maps/screens/home/user_screen.dart';
// import 'package:maps/screens/auth/login_screen.dart';
// import 'package:maps/shared_component/shared.dart';
//
//
// class RegisterScreen extends StatefulWidget {
//   @override
//   _RegisterScreenState createState() => _RegisterScreenState();
// }
//
// class _RegisterScreenState extends State<RegisterScreen> {
//   final _formKey = GlobalKey<FormState>();
//
//   final emailController = TextEditingController();
//   final nameController = TextEditingController();
//   final passwordController = TextEditingController();
//   final confirmPasswordController = TextEditingController();
//
//
//   @override
//   void dispose() {
//     emailController.dispose();
//     nameController.dispose();
//     passwordController.dispose();
//     confirmPasswordController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (BuildContext context) => LoginCubit(),
//       child: BlocConsumer<LoginCubit, LoginStates>(
//         listener: (context, states) async{
//           if (states is UserSuccessState) {
//             Navigator.of(context)
//                 .pushReplacement(
//               MaterialPageRoute(
//                 builder: (context) =>
//                     UserScreen(),
//               ),
//             );
//           }
//         },
//         builder: (context, states) {
//           var cubit = LoginCubit.get(context);
//           return Scaffold(
//             body: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Form(
//                 key: _formKey,
//                 child: Center(
//                   child: SingleChildScrollView(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Register',
//                           style: TextStyle(
//                             fontSize: 45,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(height: 50),
//                         defaultTextField(
//                           labelText: 'User Name',
//                           controller: nameController,
//                           prefixIcon: Icons.person,
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               return 'pleas enter your name';
//                             }
//                           },
//                         ),
//                         SizedBox(height: 25),
//                         defaultTextField(
//                           labelText: 'Email',
//                           controller: emailController,
//                           prefixIcon: Icons.email_outlined,
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               return 'pleas enter your email';
//                             }
//                           },
//                         ),
//                         SizedBox(height: 25),
//                         defaultTextField(
//                           labelText: 'Password',
//                           controller: passwordController,
//                           prefixIcon: Icons.lock_outline,
//                           suffixIcon: IconButton(
//                               onPressed: () {
//                                 cubit.changePasswordState();
//                               },
//                               icon: cubit.isPasswordShown
//                                   ? Icon(Icons.visibility)
//                                   : Icon(Icons.visibility_off)),
//                           obscureText: cubit.isPasswordShown ? false : true,
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               return 'pleas enter your password';
//                             }
//                           },
//                         ),
//                         SizedBox(height: 25),
//                         defaultTextField(
//                           labelText: 'Confirm Password',
//                           controller: confirmPasswordController,
//                           prefixIcon: Icons.lock_outline,
//                           suffixIcon: IconButton(
//                               onPressed: () {
//                                 cubit.changeConfirmPasswordState();
//                               },
//                               icon: cubit.isConfirmPasswordShown
//                                   ? Icon(Icons.visibility)
//                                   : Icon(Icons.visibility_off)),
//                           obscureText:
//                               cubit.isConfirmPasswordShown ? false : true,
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               return 'pleas Reenter your password';
//                             }
//                           },
//                         ),
//                         SizedBox(height: 25),
//                         Container(
//                           width: double.infinity,
//                           child: ElevatedButton(
//                             onPressed: () {
//                               FocusScope.of(context).unfocus();
//                               if (_formKey.currentState!.validate()) {
//                                 if (passwordController.text ==
//                                     confirmPasswordController.text) {
//
//                                   cubit.signUpWithUserAccount(email: emailController.text.trim(),
//                                       password:  passwordController.text,
//                                       userName: nameController.text);
//                                 } else {
//                                   showToast(
//                                     errorMessage:
//                                         'password not confirmed, please check again',
//                                   );
//                                 }
//                               }
//                             },
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(vertical: 14),
//                               child: states is! UserLoadingState ? Text(
//                                 'Register',
//                                 style: TextStyle(
//                                   fontSize: 22,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ): CircularProgressIndicator(color: Colors.white,),
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 40),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               'Do you have an account ? ',
//                               style: TextStyle(fontSize: 14),
//                             ),
//                             GestureDetector(
//                               child: Text('Login Now ',
//                                   style: TextStyle(
//                                       fontSize: 20, color: Colors.blue)),
//                               onTap: () {
//                                 Navigator.of(context).pushReplacement(
//                                     MaterialPageRoute(
//                                         builder: (context) => LoginScreen()));
//                               },
//                             )
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
