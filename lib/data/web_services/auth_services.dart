//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:workmanager/workmanager.dart';

class AuthServices {
  final _auth = FirebaseAuth.instance;

  final googleSignIn = GoogleSignIn();

  Future<bool> logInWithGoogleAccount() async {
    // Trigger the authentication flow

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return false;
      } else {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await _auth.signInWithCredential(credential);

        return true;
      }
    } on PlatformException catch (e) {
      print(e.toString());
      return false;
    }
  }

  logOut() async {
    Workmanager().cancelAll();
    await googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
  }

// String verificationId = '';

// Future<UserCredential> signUp(
//     {required String mail,
//     required String password,
//     required String name}) async {
//   var result = await _auth.createUserWithEmailAndPassword(
//       email: mail, password: password);
//
//   var user = FirebaseAuth.instance.currentUser;
//
//   await FirebaseFirestore.instance.collection('users').doc(user!.uid).set(
//     {
//       'uid': user.uid,
//       'email': user.email,
//       'name': name,
//       'role': 'user',
//       'location': GeoPoint(30.033333, 31.233334),
//       'report': '',
//     },
//   );
//
//   return result;
// }
//
// Future<UserCredential> logIn(
//     {required String mail, required String password}) async {
//   var result =
//       await _auth.signInWithEmailAndPassword(email: mail, password: password);
//   return result;
// }

// Future<void> signOut() async {
//   await _auth.signOut();
// }

//////////////////////////

//  Future<bool> logInWithGoogleAccount() async {
//   final user = await googleSignIn.signIn();
//   if (user == null) {
//     return false;
//   } else {
//     final googleAuth = await user.authentication;
//
//     final credential = GoogleAuthProvider.credential(
//       accessToken: googleAuth.accessToken,
//       idToken: googleAuth.idToken,
//     );
//    final UserCredential authResult= await FirebaseAuth.instance.signInWithCredential(credential);
//
//     final User? user =authResult.user;
//     if(authResult.additionalUserInfo!.isNewUser){
//         if(user!=null){
//           var user = FirebaseAuth.instance.currentUser;
//           await FirebaseFirestore.instance
//               .collection('users')
//               .doc(user!.uid)
//               .set(
//             {
//               'uid': user.uid,
//               'email': user.email,
//               'name': user.displayName,
//               'location': '',
//               'supervisorID':'',
//               'role':'',
//               'date_time':'',
//             },
//           );
//         }
//     }
//
//     return true;
//   }
// }

// Future<bool> loginUser(String phone,  context) async{
//   _auth.verifyPhoneNumber(
//       phoneNumber: phone,
//       timeout: Duration(seconds: 60),
//       verificationCompleted: (AuthCredential credential) async{
//         Navigator.of(context).pop();
//
//         UserCredential result = await _auth.signInWithCredential(credential);
//         User? user = result.user;
//         if(user != null){
//           Navigator.push(context, MaterialPageRoute(
//               builder: (context) => UserScreen()
//           ));
//         }else{
//           print("Error");
//         }
//
//         //This callback would gets called when verification is done automatically
//       },
//       verificationFailed: (FirebaseAuthException exception){
//         print(exception);
//       },
//       codeSent: (String verificationId, int? resendToken) {
//         showDialog(
//             context: context,
//             barrierDismissible: false,
//             builder: (context) {
//               return AlertDialog(
//                 title: Text("Give the code?"),
//                 content: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: <Widget>[
//                     TextField(
//                       controller: _codeController,
//                     ),
//                   ],
//                 ),
//                 actions: <Widget>[
//                   TextButton(
//                     child: Text("Confirm"),
//                     onPressed: () async{
//                       final code = _codeController.text.trim();
//                       AuthCredential credential = PhoneAuthProvider.getCredential(verificationId: verificationId, smsCode: code);
//
//                       AuthResult result = await _auth.signInWithCredential(credential);
//
//                       FirebaseUser user = result.user;
//
//                       if(user != null){
//                         Navigator.push(context, MaterialPageRoute(
//                             builder: (context) => HomeScreen(user: user,)
//                         ));
//                       }else{
//                         print("Error");
//                       }
//                     },
//                   )
//                 ],
//               );
//             }
//         );
//       },
//   codeAutoRetrievalTimeout: (String verificationId) {
//         this.verificationId = verificationId;
//       },
//   );
// }

// verifyPhoneNumber(String phone) async {
//   await FirebaseAuth.instance.verifyPhoneNumber(
//     phoneNumber: '02$phone',
//     verificationCompleted: (PhoneAuthCredential credential) async {
//
//       await _auth.signInWithCredential(credential);
//     },
//     verificationFailed: (FirebaseAuthException e) {
//       if (e.code == 'invalid-phone-number') {
//         print('The provided phone number is not valid.');
//       }
//     },
//     codeSent: (String verificationId, int? resendToken) {
//       this.verificationId = verificationId;
//       print('message sent');
//     },
//     codeAutoRetrievalTimeout: (String verificationId) {
//       this.verificationId = verificationId;
//     },
//     timeout: Duration(seconds: 60),
//   );
// }
//
// verifyOTP(String otp) async {
//   await _auth.signInWithCredential(PhoneAuthProvider.credential(
//       verificationId: this.verificationId, smsCode: otp));
//
// }
}
