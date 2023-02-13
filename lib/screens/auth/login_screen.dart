import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps/controllers/login/login_cubit.dart';
import 'package:maps/controllers/login/login_states.dart';
import 'package:maps/shared_component/logo_background.dart';
import 'package:maps/shared_component/shared.dart';

import '../../find_next_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (context) => LoginCubit(),
        child: Stack(
          children: [
            LogoBackground(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * .3,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * .35,
                    child: Column(
                      children: [
                        Text('مرحباً',
                            style: TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.bold,
                            )),
                        Text('للإستمرار، قم بتسجيل الدخول.',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            )),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    height: 55,
                    child: BlocConsumer<LoginCubit, LoginStates>(
                      listener: (context, state) async {
                        if (state is UserSuccessState) {
                          Widget nextScreen = await getNextScreen();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => nextScreen,
                            ),
                          );
                        }
                        if (state is UserErrorState) {
                          showToast(
                              errorMessage:
                                  'قم بإختيار حسابك للتسجيل، أو تأكد من إتصالك بالإنترنت');
                        }
                      },
                      builder: (context, state) {
                        var cubit = LoginCubit.get(context);
                        return ElevatedButton(
                          onPressed: () async {
                            cubit.logInWithGoogleAccount();
                          },
                          child: state is UserLoadingState
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/google_icon.png',
                                      height: 32,
                                    ),
                                    const SizedBox(width: 15),
                                    Text(
                                      'تسجيل الدخول',
                                      style: TextStyle(
                                        fontSize: 24,
                                      ),
                                    ),
                                  ],
                                ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
