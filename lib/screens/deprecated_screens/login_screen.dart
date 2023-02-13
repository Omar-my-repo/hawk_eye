// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:maps/controllers/login/login_cubit.dart';
// import 'package:maps/controllers/login/login_states.dart';
// import 'package:maps/screens/auth/register_screen.dart';
// import 'package:maps/shared_component/shared.dart';
//
// import '../../find_next_screen.dart';
//
// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//
//   @override
//   void dispose() {
//     emailController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (BuildContext context) => LoginCubit(),
//       child: BlocConsumer<LoginCubit, LoginStates>(
//         listener: (context, state) async {
//           if (state is UserSuccessState) {
//             Widget nextScreen = await getNextScreen();
//             Navigator.of(context).pushReplacement(
//               MaterialPageRoute(
//                 builder: (context) => nextScreen,
//               ),
//             );
//           }
//         },
//         builder: (context, state) {
//           var cubit = LoginCubit.get(context);
//           return Scaffold(
//             body: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Login',
//                       style: TextStyle(
//                         fontSize: 45,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 50),
//                     defaultTextField(
//                       labelText: 'Email',
//                       controller: emailController,
//                       prefixIcon: Icons.email_outlined,
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return 'pleas enter your email';
//                         }
//                       },
//                     ),
//                     SizedBox(height: 25),
//                     defaultTextField(
//                       labelText: 'Password',
//                       controller: passwordController,
//                       prefixIcon: Icons.lock_outline,
//                       suffixIcon: IconButton(
//                           onPressed: () {
//                             cubit.changePasswordState();
//                           },
//                           icon: cubit.isPasswordShown
//                               ? Icon(Icons.visibility)
//                               : Icon(Icons.visibility_off)),
//                       obscureText: cubit.isPasswordShown ? false : true,
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return 'pleas enter your password';
//                         }
//                       },
//                     ),
//                     SizedBox(height: 25),
//                     Container(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: () async {
//                           FocusScope.of(context).unfocus();
//                           if (_formKey.currentState!.validate()) {
//                             cubit.loginWithUserAccount(emailController.text.trim(),
//                                 passwordController.text);
//                             // try {
//                             // await _auth
//                             //     .logIn(
//                             //   mail: emailController.text,
//                             //   password: passwordController.text,
//                             // )
//                             //     .then(
//                             //   (_) async {
//                             //     Widget nextScreen = await getNextScreen();
//                             //     Navigator.of(context).pushReplacement(
//                             //       MaterialPageRoute(
//                             //         builder: (context) => nextScreen,
//                             //       ),
//                             //     );
//                             //   },
//                             // );
//                             // } on FirebaseAuthException catch (e) {
//                             //   showToast(errorMessage: errorHandle(e.code));
//                             // }
//                           }
//                         },
//                         child: Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 14),
//                             child: state is! UserLoadingState
//                                 ? Text(
//                               'Login',
//                               style: TextStyle(
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ) : CircularProgressIndicator(color: Colors.white,),
//
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 40),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           'Don\'t have an account ? ',
//                           style: TextStyle(fontSize: 14),
//                         ),
//                         GestureDetector(
//                           child: Text('Register Now ',
//                               style:
//                               TextStyle(fontSize: 20, color: Colors.blue)),
//                           onTap: () {
//                             Navigator.of(context).pushReplacement(
//                                 MaterialPageRoute(
//                                     builder: (context) => RegisterScreen()));
//                           },
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//
// }
