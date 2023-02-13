import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maps/screens/home/internet_error.dart';
import 'package:maps/shared_component/drawer_screens/drawer_superadmin.dart';
import 'package:maps/shared_component/shared.dart';

import '../../find_next_screen.dart';

List selectedAdminsIds = [];
List unSelectedAdminsIds = [];

class ManageSuper extends StatefulWidget {
  const ManageSuper({Key? key, required this.role}) : super(key: key);
  final String role;

  @override
  _ManageSuperState createState() => _ManageSuperState();
}

class _ManageSuperState extends State<ManageSuper> {
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
    selectedAdminsIds = [];
    unSelectedAdminsIds = [];
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
            'تعيين مـشرفين',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        drawer: DrawerSuperAdmin(role: this.widget.role),
        body: _connectionStatus != ConnectivityResult.none.toString()
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          ' قم بإختيار المشرفين الجدد.',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        FutureBuilder<QuerySnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('users') //get roles user and admin
                              .where('role', whereIn: ['user', 'admin']).get(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              selectedAdminsIds = [];
                              unSelectedAdminsIds = [];
                              var data = snapshot.data!.docs;
                              if (data.length != 0) {
                                for (int index = 0;
                                    index < data.length;
                                    index++) {
                                  if (data[index]['role'] == 'admin') {
                                    if (!selectedAdminsIds.contains(
                                        data[index]['uid'].toString().trim())) {
                                      selectedAdminsIds.add(
                                          data[index]['uid'].toString().trim());
                                    }
                                  } else {
                                    if (!unSelectedAdminsIds.contains(
                                        data[index]['uid'].toString().trim())) {
                                      unSelectedAdminsIds.add(
                                          data[index]['uid'].toString().trim());
                                    }
                                  }
                                }

                                return DrawThatUser(data: data);
                              }
                              return Expanded(
                                  child: Container(
                                color: Colors.grey[200],
                                child: Center(
                                  child: const Text(
                                    'لا يوجد مستخدمين بعد ',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black45),
                                  ),
                                ),
                              ));

                              // return drawUsers(data);
                            }
                            return Center(child: CircularProgressIndicator());
                          },
                        ),
                      ],
                    ),
                    Positioned(
                      left: 0,
                      bottom: 20,
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            await actionOnSelectedList();
                            await actionOnUnSelected();
                            showToast(errorMessage: 'تمت العملية بنجاح');
                          } catch (e) {
                            showToast(errorMessage: 'حدث خطأ اثناء التحميل');
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Text(
                            'حفظ',
                            style: TextStyle(
                                fontSize: 26, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : InternetError(),
      ),
    );
  }
}

actionOnSelectedList() async {
  for (int i = 0; i < selectedAdminsIds.length; i++) {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(selectedAdminsIds[i])
        .update({
      'role': 'admin',
      'areaAdminID': '',
      'supervisorID': selectedAdminsIds[i], // to be shown on map for himself
    });
  }
}

actionOnUnSelected() async {
  for (int i = 0; i < unSelectedAdminsIds.length; i++) {
    var ref = FirebaseFirestore.instance.collection('users');
    final DocumentSnapshot snap = await ref.doc(unSelectedAdminsIds[i]).get();
    if (snap['role'] == 'admin') {
      await ref.doc(unSelectedAdminsIds[i]).update({
        'role': 'user',
        'supervisorID': '',
        'areaAdminID': '',
        //'area': '',
      }).then((value) async {
        // update supervisor id for the followers to ''
        await ref
            .where('supervisorID', isEqualTo: unSelectedAdminsIds[i])
            .get()
            .then((QuerySnapshot snapshot) => {
                  snapshot.docs.forEach((f) {
                    ref.doc(f.id).update({
                      'supervisorID': '',
                      'areaAdminID': '',
                      //'area': '',
                    });
                  })
                });
      });
    }
  }
}

class DrawThatUser extends StatefulWidget {
  const DrawThatUser({Key? key, required this.data}) : super(key: key);
  final data;

  @override
  _DrawThatUserState createState() => _DrawThatUserState();
}

class _DrawThatUserState extends State<DrawThatUser> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        //color: Colors.grey[200],
        child: ListView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemCount: widget.data.length,
          itemBuilder: (context, index) {
            return CheckboxListTile(
                title: Text(
                  '${widget.data[index]['name']}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${widget.data[index]['area']}',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                // adding trim is important cause some timed data saved in a list with white space000
                value: selectedAdminsIds
                    .contains(widget.data[index]['uid'].toString().trim()),
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (value) {
                  if (selectedAdminsIds
                      .contains(widget.data[index]['uid'].toString().trim())) {
                    selectedAdminsIds
                        .remove(widget.data[index]['uid'].toString().trim());
                    unSelectedAdminsIds
                        .add(widget.data[index]['uid'].toString().trim());
                  } else {
                    selectedAdminsIds
                        .add(widget.data[index]['uid'].toString().trim());
                    unSelectedAdminsIds
                        .remove(widget.data[index]['uid'].toString().trim());
                  }

                  setState(() {});
                });
          },
        ),
      ),
    );
  }
}
