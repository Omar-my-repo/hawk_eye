import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maps/screens/home/show_supervised_users.dart';
import 'package:maps/shared_component/drawer_screens/drawer_superadmin.dart';
import 'package:maps/shared_component/shared.dart';

import '../../find_next_screen.dart';
import 'internet_error.dart';

List selectedUsersIds = [];
//List unSelectedUsersIds = [];
int _value = -1;
String supervisorID = '';
String supervisorArea = '';

class ManageDelegates extends StatefulWidget {
  const ManageDelegates({Key? key, required this.role}) : super(key: key);
  final String role;

  @override
  _ManageDelegatesState createState() => _ManageDelegatesState();
}

class _ManageDelegatesState extends State<ManageDelegates> {
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
    selectedUsersIds = [];
    //unSelectedUsersIds = [];
    _value = -1;
    supervisorArea = '';
    supervisorID = '';
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
            'إختيار المندوبين',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        drawer: DrawerSuperAdmin(role: widget.role),
        body: _connectionStatus != ConnectivityResult.none.toString()
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'رجاءً قم بتحديد المشرف ',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .where('role', isEqualTo: 'admin')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var data = snapshot.data!.docs;
                              return DrawThatAdmin(data: data);
                            }
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          ' قم بإختيار المندوبين ثم إضغط حفظ ',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          textDirection: TextDirection.rtl,
                        ),
                        const Text(
                          'مندوبيين لهم مشرفين',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                          textDirection: TextDirection.rtl,
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .where('role', isEqualTo: 'user')
                              .where('supervisorID', isNotEqualTo: '')
                              .snapshots(),
                          builder: (context, snap) {
                            if (snap.hasData) {
                              var data = snap.data!.docs;
                              return DrawThatUser(data: data);
                            }
                            return CircularProgressIndicator();
                          },
                        ),
                        const Text(
                          'مندوبيين بدون مشرف',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                          textDirection: TextDirection.rtl,
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .where('role', isEqualTo: 'user')
                              .where('supervisorID', isEqualTo: '')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var data = snapshot.data!.docs;
                              return DrawThatUser(data: data);
                            }
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                        const SizedBox(height: 25),
                      ],
                    ),
                    Positioned(
                      left: 0,
                      bottom: 20,
                      child: Column(
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              try {
                                if (supervisorID != '') {
                                  await actionOnSelectedList();
                                } else {
                                  showToast(
                                      errorMessage: 'يجب إختيار مشرف أولاً');
                                }
                              } catch (e) {
                                showToast(
                                    errorMessage:
                                        'حدث خطأ اثناء التعديل، حاول مرة اخري');
                              }

                              setState(() {
                                _value = -1;
                                selectedUsersIds = [];
                                supervisorID = '';
                                supervisorArea = '';
                              });
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6.0),
                              child: Text(
                                'حفظ',
                                style: TextStyle(
                                    fontSize: 26, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            : InternetError(),
      ),
    );
  }

  actionOnSelectedList() async {
    for (int i = 0; i < selectedUsersIds.length; i++) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(selectedUsersIds[i])
          .update({
        'supervisorID': supervisorID,
        'area': supervisorArea,
      }).then((value) => showToast(errorMessage: 'تم إضافة المندوبين بنجاح'));
    }
  }
}

class DrawThatAdmin extends StatefulWidget {
  const DrawThatAdmin({Key? key, required this.data}) : super(key: key);
  final data;

  @override
  _DrawThatAdminState createState() => _DrawThatAdminState();
}

class _DrawThatAdminState extends State<DrawThatAdmin> {
  @override
  Widget build(BuildContext context) {
    if (widget.data.length != 0) {
      return Expanded(
          child: Container(
        height: MediaQuery.of(context).size.height * .18,
        //color: Colors.grey[200],
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemCount: widget.data.length,
          itemBuilder: (context, index) {
            return Row(
              children: [
                Expanded(
                  child: ListTile(
                    onTap: () {
                      setState(() {
                        _value = index;
                        supervisorID = widget.data[index]['uid'];
                        supervisorArea = widget.data[index]['area'];
                      });
                    },
                    title: Text(
                      '${widget.data[index]['name']}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${widget.data[index]['area']}',
                      style: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.normal),
                    ),
                    leading: Radio(
                      value: index,
                      activeColor: Colors.blue,
                      onChanged: (int? value) {
                        setState(() {
                          _value = value!;
                          supervisorID = widget.data[index]['uid'];
                          supervisorArea = widget.data[index]['area'];
                        });
                      },
                      groupValue: _value,
                    ),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ShowSupervisedUsers(
                              role: 'super_admin',
                              adminID: widget.data[index]['uid'],
                              adminName: widget.data[index]['name'])));
                    },
                    child: Icon(Icons.people))
              ],
            );
          },
        ),
      ));
    }
    return Expanded(
      child: Container(
        //color: Colors.grey[200],
        child: Center(
          child: const Text(
            'لا يوجد مشرفين',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black45),
          ),
        ),
      ),
    );
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
    if (widget.data.length != 0) {
      return Expanded(
        child: Container(
          //color: Colors.blueGrey,
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
                  //all are unchecked because selectedUsersIds is empty, we must fill it with users under selected supervisors
                  value: selectedUsersIds
                      .contains(widget.data[index]['uid'].toString().trim()),
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (value) {
                    if (selectedUsersIds.contains(
                        widget.data[index]['uid'].toString().trim())) {
                      selectedUsersIds
                          .remove(widget.data[index]['uid'].toString().trim());
//                      unSelectedUsersIds
//                          .add(widget.data[index]['uid'].toString().trim());
                    } else {
                      selectedUsersIds
                          .add(widget.data[index]['uid'].toString().trim());
//                      unSelectedUsersIds
//                          .remove(widget.data[index]['uid'].toString().trim());
                    }
                    setState(() {});
                  });
            },
          ),
        ),
      );
    }
    return Expanded(
      child: Container(
        //color: Colors.grey[200],
        child: Center(
          child: const Text(
            'لا يوجد مندوبين',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black45),
          ),
        ),
      ),
    );
  }
}
