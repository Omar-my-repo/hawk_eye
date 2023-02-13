import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maps/shared_component/drawer_screens/drawer_superadmin.dart';
import 'package:maps/shared_component/shared.dart';

import '../../find_next_screen.dart';
import 'internet_error.dart';

class DeleteUsers extends StatefulWidget {
  const DeleteUsers({Key? key, required this.role}) : super(key: key);
  final role;

  @override
  _DeleteUsersState createState() => _DeleteUsersState();
}

final Connectivity _connectivity = Connectivity();
late StreamSubscription<ConnectivityResult> _connectivitySubscription;
String _connectionStatus = 'Unknown';

class _DeleteUsersState extends State<DeleteUsers> {
  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }
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
    // ignore: todo
    // TODO: implement initState
    print('');
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
            'إلغاء تنشيط موظفين', //
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        drawer: DrawerSuperAdmin(role: this.widget.role),
        body: _connectionStatus != ConnectivityResult.none.toString()
            ? StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('role', isNotEqualTo: 'super_admin')
                    //.where('active', isEqualTo: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var data = snapshot.data!.docs;
                    return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10),
                            child: Card(
                              elevation: 5,
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: ListTile(
                                    title: Text('${data[index]['name']}',
                                        style: TextStyle(fontSize: 18)),
                                    subtitle: Text(
                                      //'${data[index]['area']}',
                                      '${data[index]['area']} - ${data[index]['role'] == 'user' ? 'مندوب' : {
                                          data[index]['role'] == 'admin'
                                              ? 'مشرف'
                                              : 'مدير منطقة'
                                        }}',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.blueAccent,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    leading: (data[index]['active'] == true)
                                        ? Icon(
                                            //active
                                            Icons.delete_forever,
                                            color: Colors.red, size: 30,
                                            textDirection: TextDirection.rtl,
                                          )
                                        : Icon(
                                            //inActive
                                            Icons.block,
                                            color: Colors.green, size: 30,
                                            textDirection: TextDirection.rtl,
                                          ),
//                                    Icon(
//                                      Icons.delete_forever,
//                                      color: Colors.red,
//                                      size: 30,
//                                      textDirection: TextDirection.rtl,
//                                    ),
                                    onTap: (data[index]['active'] == true)
                                        ? () {
                                            showAlertDialog(
                                                context,
                                                data[index]['uid']
                                                    .toString()
                                                    .trim());
                                          }
                                        : null, //disabled , or () {} to do nothing when clicked
                                  )),
                            ),
                          );
                        });
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              )
            : InternetError(),
      ),
    );
  }

  showAlertDialog(BuildContext context, String id) {
    //print(id);
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("إلغاء",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "تأكيد",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      onPressed: () async {
        var ref = FirebaseFirestore.instance.collection('users');
        final DocumentSnapshot snap = await ref.doc(id).get();
        if (snap.exists) {
          if (snap['role'] == 'admin') {
            await ref
                .where('supervisorID', isEqualTo: id)
                .get()
                .then((QuerySnapshot snapshot) => {
                      snapshot.docs.forEach((f) {
                        ref.doc(f.id).update({
                          'supervisorID': '',
                        });
                      })
                    });
          }
          if (snap['role'] == 'area_admin') {
            await ref
                .where('areaAdminID', isEqualTo: id)
                .get()
                .then((QuerySnapshot snapshot) => {
                      snapshot.docs.forEach((f) {
                        ref.doc(f.id).update({
                          'areaAdminID': '',
                        });
                      })
                    });
          }
          //do not delete user or reports, just make user inactive
//          if (snap['active'] == true) {
//            await ref.doc(id).update({'active': false}).then((value) {
//              showToast(errorMessage: 'تم إلغاء التنشيط بنجاح');
//            });
//            Navigator.pop(context);
//          } else {
//            await ref.doc(id).update({'active': true}).then((value) {
//              showToast(errorMessage: 'تم التنشيط بنجاح');
//            });
//            Navigator.pop(context);
//          }
          await ref.doc(id).update({'active': false}).then((value) {
            showToast(errorMessage: 'تمت العملية بنجاح');
          });
          Navigator.pop(context);
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("تنبيه!"),
      content: Text(
          "سيتم إلغاء تنشيط الموظف مع بقاء بياناته وتقاريره. هل أنت متأكد من ذلك؟"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
