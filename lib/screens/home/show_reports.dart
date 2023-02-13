import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:maps/shared_component/drawer_screens/drawer_admin.dart';
import 'package:maps/shared_component/drawer_screens/drawer_area_admin.dart';
import 'package:maps/shared_component/drawer_screens/drawer_superadmin.dart';

import '../../find_next_screen.dart';
import 'internet_error.dart';

class ShowReports extends StatefulWidget {
  ShowReports({Key? key, required this.role}) : super(key: key);
  final String role;

  @override
  _ShowReportsState createState() => _ShowReportsState();
}

class _ShowReportsState extends State<ShowReports> {
  DateTime todayDate = DateTime.now();
  DateFormat formatter = DateFormat('dd/MM/yyyy');
  late String selectedDate = formatter.format(todayDate).toString();
  var user = FirebaseAuth.instance.currentUser;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: todayDate,
        firstDate: DateTime(2021, 8),
        lastDate: DateTime.now());
    if (picked != null && picked != todayDate)
      setState(() {
        todayDate = picked;
        selectedDate = formatter.format(todayDate);
      });
  }

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
    //late String selectedDate = formatter.format(todayDate).toString();
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
              'عرض التقارير',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          drawer: widget.role == 'super_admin'
              ? DrawerSuperAdmin(role: widget.role)
              : widget.role == 'area_admin'
                  ? DrawerAreaAdmin(role: widget.role)
                  : DrawerAdmin(role: widget.role),
          //drawer: widget.role=='super_admin'? DrawerSuperAdmin(role: widget.role,):DrawerAdmin(role: widget.role,),
          body: _connectionStatus != ConnectivityResult.none.toString()
              ? Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: ElevatedButton(
                              onPressed: () => _selectDate(context),
                              child: Container(
                                width: MediaQuery.of(context).size.width * .5,
                                height: 50,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.date_range_rounded),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text('تحديد التاريخ',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          drawTheScreen(),
                        ],
                      ),
                    ),
                  ],
                )
              : InternetError()),
    );
  }

  Widget drawTheScreen() {
    if (widget.role == 'admin') {
      return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'user')
            .where('supervisorID', isEqualTo: user!.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<String> ids = [];
            for (var doc in snapshot.data!.docs) {
              ids.add(doc.id);
            }
            if (ids.isEmpty) {
              return Column(
                children: [
                  Container(height: 50),
                  Container(
                    width: double.infinity,
                    child: Text(
                      'لا يوجود مندوبين تابعين لك فى الوقت الحالي',
                      style: TextStyle(fontSize: 22),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              );
            }
            return ListView.builder(
                // scrollDirection: Axis.vertical,
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, ind) {
                  return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(ids[ind])
                          .collection('reports')
                          .where('date', isEqualTo: selectedDate)
                          .snapshots(),
                      builder: (context, snap) {
                        if (snap.hasData) {
                          if (snap.data!.docs.length != 0) {
                            return ListView.builder(
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                                // scrollDirection: Axis.vertical,
                                itemCount: snap.data!.docs.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 8),
                                    child: Card(
                                      child: ListTile(
                                        // إضهار علامة غير نشط بجانب الموظف الغير نشط
                                        leading: (snapshot.data!.docs[ind]
                                                    ['active'] ==
                                                true)
                                            ? Icon(
                                                Icons.work,
                                                color: Colors.green,
                                              )
                                            : Icon(
                                                Icons.work_off,
                                                color: Colors.red,
                                              ),
                                        title: Text(
                                            //also show active or not
                                            snapshot.data!.docs[ind]['name'],
                                            style: TextStyle(fontSize: 18)),
                                        subtitle: Text(
                                            snap.data!.docs[index]['body'],
                                            style: TextStyle(fontSize: 18),
                                            textAlign: TextAlign.right),
                                      ),
                                    ),
                                  );
                                });
                          }
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            child: Card(
                              child: ListTile(
                                title: Text(snapshot.data!.docs[ind]['name'],
                                    style: TextStyle(fontSize: 18)),
                                subtitle: Text(
                                  'لا يوجد تقارير مسجلة لهذا اليوم',
                                  style: TextStyle(fontSize: 18),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                          );
                        }
                        return Center(child: Container());
                      });
                });
          }
          return Center(child: CircularProgressIndicator());
        },
      );
    } else if (widget.role == 'area_admin') {
      return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .where('areaAdminID', isEqualTo: user!.uid)
            .where('role', whereIn: ['user', 'admin']).get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<String> ids = [];
            for (var doc in snapshot.data!.docs) {
              ids.add(doc.id);
            }
            if (ids.isEmpty) {
              return Column(
                children: [
                  Container(height: 50),
                  Container(
                    width: double.infinity,
                    child: Text(
                      'لا يوجود مشرفين أو مندوبين تابعين لك فى الوقت الحالي',
                      style: TextStyle(fontSize: 22),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              );
            }
            return ListView.builder(
                // scrollDirection: Axis.vertical,
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, ind) {
                  return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(ids[ind])
                          .collection('reports')
                          .where('date', isEqualTo: selectedDate)
                          .snapshots(),
                      builder: (context, snap) {
                        if (snap.hasData) {
                          if (snap.data!.docs.length != 0) {
                            return ListView.builder(
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                                // scrollDirection: Axis.vertical,
                                itemCount: snap.data!.docs.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 8),
                                    child: Card(
                                      child: ListTile(
                                        title: Text(
                                            '${snapshot.data!.docs[ind]['name']} - ${snapshot.data!.docs[ind]['role'] == 'user' ? 'مندوب' : 'مشرف'}',
                                            //snapshot.data!.docs[ind]['name'],
                                            style: TextStyle(fontSize: 18)),
                                        subtitle: Text(
                                            snap.data!.docs[index]['body'],
                                            style: TextStyle(fontSize: 18),
                                            textAlign: TextAlign.right),
                                      ),
                                    ),
                                  );
                                });
                          }
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            child: Card(
                              child: ListTile(
                                title: Text(snapshot.data!.docs[ind]['name'],
                                    style: TextStyle(fontSize: 18)),
                                subtitle: Text(
                                  'لا يوجد تقارير مسجلة لهذا اليوم',
                                  style: TextStyle(fontSize: 18),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                          );
                        }
                        return Center(child: Container());
                      });
                });
          }
          return Center(child: CircularProgressIndicator());
        },
      );
    } else {
      //super_admin
      return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .where('role', whereIn: ['user', 'admin'])
            //corresponding to
            //.where('role',isEqualTo:'user')
            //.where('role' ,isEqualTo: 'admin')
            //.where('role', whereNotIn: ['super_admin', 'area_admin'])
            //corresponding to
            //.where('role', isNotEqualTo: 'super_admin')
            //.where('role', isNotEqualTo: 'area_admin')
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<String> ids = [];
            for (var doc in snapshot.data!.docs) {
              ids.add(doc.id);
            }
            if (ids.isEmpty) {
              return Column(
                children: [
                  Container(height: 50),
                  Container(
                    width: double.infinity,
                    child: Text(
                      'لا يوجود مشرفين أو مندوبين في الوقت الحالي',
                      style: TextStyle(fontSize: 22),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              );
            }
            return ListView.builder(
                // scrollDirection: Axis.vertical,
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, ind) {
                  return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(ids[ind])
                          .collection('reports')
                          .where('date', isEqualTo: selectedDate)
                          .snapshots(),
                      builder: (context, snap) {
                        if (snap.hasData) {
                          if (snap.data!.docs.length != 0) {
                            return ListView.builder(
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                                // scrollDirection: Axis.vertical,
                                itemCount: snap.data!.docs.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 8),
                                    child: Card(
                                      child: ListTile(
                                        title: Text(
                                            '${snapshot.data!.docs[ind]['name']} - ${snapshot.data!.docs[ind]['role'] == 'user' ? 'مندوب' : 'مشرف'}',
                                            //snapshot.data!.docs[ind]['name'],
                                            style: TextStyle(fontSize: 18)),
                                        subtitle: Text(
                                            snap.data!.docs[index]['body'],
                                            style: TextStyle(fontSize: 18),
                                            textAlign: TextAlign.right),
                                      ),
                                    ),
                                  );
                                });
                          }
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            child: Card(
                              child: ListTile(
                                title: Text(snapshot.data!.docs[ind]['name'],
                                    style: TextStyle(fontSize: 18)),
                                subtitle: Text(
                                  'لا يوجد تقارير مسجلة لهذا اليوم',
                                  style: TextStyle(fontSize: 18),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                          );
                        }
                        return Center(child: Container());
                      });
                });
          }
          return Center(child: CircularProgressIndicator());
        },
      );
    }
  }
}
