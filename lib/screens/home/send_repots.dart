import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//import 'package:maps/shared_component/shared.dart';
//import 'package:workmanager/workmanager.dart';
import 'package:intl/intl.dart';
import 'package:maps/controllers/map_drawer/map_cubit.dart';
import 'package:maps/controllers/map_drawer/map_states.dart';

//import 'package:maps/data/web_services/auth_services.dart';
//import 'package:maps/screens/auth/login_screen.dart';
import 'package:maps/screens/home/internet_error.dart';

//import 'package:maps/screens/home/user_screen.dart';
import 'package:maps/shared_component/drawer_screens/drawer_admin.dart';
import 'package:maps/shared_component/drawer_screens/drawer_user.dart';

import '../../find_next_screen.dart';

class SendReports extends StatefulWidget {
  SendReports({Key? key, required this.role}) : super(key: key);
  final String role;

  @override
  _SendReportsState createState() => _SendReportsState();
}

class _SendReportsState extends State<SendReports> {
  final TextEditingController reportController = TextEditingController();

  final DateTime now = DateTime.now();

  final DateFormat formatter = DateFormat('dd/MM/yyyy');

  final _formKey = GlobalKey<FormState>();

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  String _connectionStatus = 'Unknown';

  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        setState(() => _connectionStatus = result.toString());
        break;
      default:
        setState(() => _connectionStatus = 'Failed to get connectivity.');
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String formatted = formatter.format(now);

    return WillPopScope(
      onWillPop: () async {
        Widget nextScreen = await getNextScreen();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => nextScreen));
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'إرسال تقرير',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        drawer: widget.role == 'admin'
            ? DrawerAdmin(
                role: widget.role,
              )
            : DrawerUser(),
        //drawer: DrawerUser(),
        //عدم إظهار الشاشة إذا كان الموظف غير مفعل
        body: _connectionStatus != ConnectivityResult.none.toString()
            ? SingleChildScrollView(
                child: BlocProvider(
                  create: (context) => MapCubit(),
                  child: BlocConsumer<MapCubit, MapStates>(
                    listener: (context, state) {
                      if (state is UpdateReportSuccessState) {
                        setState(() {
                          reportController.clear();
                        });
                      }
                    },
                    builder: (context, state) {
                      var cubit = MapCubit.get(context);
                      return Padding(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 40),
                        child: Stack(children: [
                          Column(
                            children: [
                              Form(
                                key: _formKey,
                                child: TextFormField(
                                  controller: reportController,
                                  maxLines: 11,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'لا يمكن إرسال تقرير فارغ';
                                    }
                                  },
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.right,
                                  decoration: InputDecoration(
                                    //labelText: 'Today\'s Report',
                                    hintText: 'التقرير اليومي ',
                                    hintStyle: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),

                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors.blue, width: 2.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors.blue, width: 2.0),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Container(
                                height: 50,
                                width: double.infinity,
                                child: ElevatedButton(
                                  child: cubit is! UpdateReportLoadingState
                                      ? Text(
                                          'إرسال',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        )
                                      : CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                  onPressed: () async {
                                    FocusScope.of(context).unfocus();
                                    if (_formKey.currentState!.validate()) {
                                      cubit.uploadUserReport(
                                          report: reportController.text,
                                          date: formatted);
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ]),
                      );
                    },
                  ),
                ),
              )
            : InternetError(),
      ),
    );
  }
}
