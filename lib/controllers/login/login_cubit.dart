import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps/data/web_services/auth_services.dart';
//import 'package:maps/shared_component/shared.dart';

import 'login_states.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(InitialState());

  bool isPasswordShown = false;
  bool isConfirmPasswordShown = false;

  static LoginCubit get(context) => BlocProvider.of(context);

  void changePasswordState() {
    isPasswordShown = !isPasswordShown;
    emit(ChangePasswordState());
  }

  void changeConfirmPasswordState() {
    isConfirmPasswordShown = !isConfirmPasswordShown;
    emit(ChangeConfirmPasswordState());
  }

  final AuthServices _auth = AuthServices();

  // void loginWithUserAccount(email, password) async {
  //   emit(UserLoadingState());
  //
  //   _auth.logIn(mail: email, password: password).then((value) {
  //     emit(UserSuccessState());
  //   }).catchError((e) {
  //     emit(UserErrorState());
  //   });
  // }

  // void signUpWithUserAccount(
  //     {required email, required password, required userName}) {
  //   emit(UserLoadingState());
  //   _auth
  //       .signUp(
  //     mail: email,
  //     password: password,
  //     name: userName,
  //   )
  //       .then((value) {
  //     emit(UserSuccessState());
  //   }).catchError((e) {
  //     showToast(errorMessage: errorHandle(e.code));
  //     emit(UserErrorState());
  //   });
  // }
  bool isUserEntered = false;

  logInWithGoogleAccount() async {
    emit(UserLoadingState());
    await _auth.logInWithGoogleAccount().then((value) {
      if (value) {
        emit(UserSuccessState());
      } else {
        emit(UserErrorState());
      }
    });
  }

// errorHandle(String code) {
//   switch (code) {
//     // errors messages for when user try to login
//     case "invalid-email":
//       return "Your email address badly formatted.";
//
//     case "user-not-found":
//       return "this mail no long to any user, try register first.";
//
//     case "wrong-password":
//       return "your password is wrong.";
//
//     // errors messages for when user register new account
//     case "email-already-in-use":
//       return "The email address is already in use by another account.";
//
//     case "weak-password":
//       return "your password is weak.";
//
//     case "operation-not-allowed":
//       return "User with this email has been disabled.";
//     default:
//       return "An undefined Error happened, check internet connection and try again ";
//   }
// }
}
