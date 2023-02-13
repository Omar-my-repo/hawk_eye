import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maps/screens/home/user_screen.dart';

//import 'package:maps/shared_component/logo_background.dart';
import 'package:maps/shared_component/shared.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

var formKey = GlobalKey<FormState>();
final firstNameController = TextEditingController();
final secondNameController = TextEditingController();
final thirdNameController = TextEditingController();
final phoneNumberController = TextEditingController();
final areaController = TextEditingController();
bool isLoading = false;

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Stack(
        children: [
          //LogoBackground(),
          Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * .2,
                    ),
                    defaultTextField(
                      labelText: 'الاسم الأول',
                      controller: firstNameController,
                      prefixIcon: Icons.person_add,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'رجاءً قم بكتابة اسمك الاول';
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    defaultTextField(
                      labelText: 'الاسم الأوسط',
                      controller: secondNameController,
                      prefixIcon: Icons.person_add,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'رجاءً قم بكتابة اسمك الاوسط';
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    defaultTextField(
                      labelText: 'الاسم الأخير',
                      controller: thirdNameController,
                      prefixIcon: Icons.person_add,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'رجاءً قم بكتابة اسمك الاخير';
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    defaultTextField(
                      labelText: 'اسم المنطقة التابع لها',
                      controller: areaController,
                      prefixIcon: Icons.location_on_outlined,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'رجاءً قم بكتابة المنطقة التابع لها';
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    defaultTextField(
                      labelText: 'رقم الهاتف',
                      controller: phoneNumberController,
                      prefixIcon: Icons.phone_callback_outlined,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'رجاءً قم بكتابة رقم الهاتف';
                        }
                        if (value.length != 11 || !value.startsWith('01')) {
                          return 'تأكد من صحة رقم الهاتف كما يجب ان يكون بالإنجليزية';
                        }
                      },
                    ),
                    const SizedBox(height: 50),
                    Container(
                      //color: ,
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            FocusScope.of(context).unfocus();
                            setState(() {
                              isLoading = true;
                            });
                            String fullName =
                                '${firstNameController.text} ${secondNameController.text} ${thirdNameController.text}';

                            try {
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user!.uid)
                                  .set(
                                {
                                  'uid': user.uid,
                                  'email': user.email,
                                  'name': fullName,
                                  'phone': phoneNumberController.text,
                                  'location': '',
                                  'supervisorID': '',
                                  'role': 'user',
                                  'date_time': '',
                                  'area': areaController.text,
                                  'areaAdminID': '',
                                  'active': true
                                  // 'super_admin':false,
                                },
                              ).then((_) {
                                setState(() {
                                  isLoading = false;
                                });
                                firstNameController.clear();
                                secondNameController.clear();
                                thirdNameController.clear();
                                phoneNumberController.clear();
                                areaController.clear();
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => UserScreen()));
                              });
                            } catch (e) {
                              setState(() {
                                isLoading = false;
                                showToast(
                                    errorMessage:
                                        'حدث خطأ اثناء التسجيل, يرجى المحاوله في وقت لاحق');
                              });
                            }
                          }
                        },
                        child: isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                                'تسجيل',
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * .1,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
