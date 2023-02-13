import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maps/screens/home/show_area_supervisors.dart';
import 'package:maps/shared_component/drawer_screens/drawer_superadmin.dart';
import 'package:maps/shared_component/shared.dart';

import '../../find_next_screen.dart';
import 'internet_error.dart';

List selectedUsersIds = [];
List unSelectedUsersIds = [];
int _value = -1;
String areaAdminId = '';
String area = '';

class ManageAreaSupervisors extends StatefulWidget {
  const ManageAreaSupervisors({Key? key, required this.role}) : super(key: key);
  final String role;

  @override
  _ManageAreaSupervisorsState createState() => _ManageAreaSupervisorsState();
}

class _ManageAreaSupervisorsState extends State<ManageAreaSupervisors> {
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
    unSelectedUsersIds = [];
    _value = -1;
    area = '';
    areaAdminId = '';
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
            'إختيار مشرفي المناطق',
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
                          'رجاءً قم بتحديد مدير المنطقة ',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .where('role', isEqualTo: 'area_admin')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var data = snapshot.data!.docs;
                              return DrawThatAreaAdmin(data: data);
                            }
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          ' قم بإختيار المشرفين ثم إضغط حفظ ',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          textDirection: TextDirection.rtl,
                        ),
                        const Text(
                          'مشرفين مدرجين علي مناطق',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                          textDirection: TextDirection.rtl,
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .where('role', isEqualTo: 'admin')
                              .where('areaAdminID',
                                  isNotEqualTo: '') // or area != ''
                              .snapshots(),
                          builder: (context, snap) {
                            if (snap.hasData) {
                              var data = snap.data!.docs;
                              return DrawThatSupervisor(data: data);
                            }
                            return CircularProgressIndicator();
                          },
                        ),
                        const Text(
                          'مشرفين غير مدرجين علي مناطق',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                          textDirection: TextDirection.rtl,
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .where('role', isEqualTo: 'admin')
                              .where('areaAdminID', isEqualTo: '')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var data = snapshot.data!.docs;
                              return DrawThatSupervisor(data: data);
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
                                if (areaAdminId != '') {
                                  await actionOnSelectedList();
                                  //await actionOnUnSelectedList();
                                } else {
                                  showToast(
                                      errorMessage:
                                          'يجب إختيار مدير المنطقة أولاً');
                                }
                              } catch (e) {
                                showToast(
                                    errorMessage:
                                        'حدث خطأ اثناء التعديل، حاول مرة اخري');
                              }

                              setState(() {
                                _value = -1;
                                selectedUsersIds = [];
                                areaAdminId = '';
                                area = '';
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
        'areaAdminID': areaAdminId,
        'area': area,
      }).then((value) =>
              showToast(errorMessage: 'تم إدراج المشرفين لهذه المنطقة بنجاح'));
    }
  }

  actionOnUnSelectedList() async {
    //do not call this because unselected supervisors may be follow another area admin
    //if unselected supervisor has areaAdminId == areaAdminID
    //make it ''
    //if either leave it
    for (int i = 0; i < unSelectedUsersIds.length; i++) {
      final DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(unSelectedUsersIds[i])
          .get();
      if (snap['areaAdminID'] == areaAdminId) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(unSelectedUsersIds[i])
            .update({
          'areaAdminID': '',
          //'area': '',
        });
      }
    }
  }
}

class DrawThatAreaAdmin extends StatefulWidget {
  const DrawThatAreaAdmin({Key? key, required this.data}) : super(key: key);
  final data;

  @override
  _DrawThatAreaAdminState createState() => _DrawThatAreaAdminState();
}

class _DrawThatAreaAdminState extends State<DrawThatAreaAdmin> {
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
                          areaAdminId = widget.data[index]['uid'];
                          area = widget.data[index]['area'];
                        });
                      },
                      title: Text(
                        '${widget.data[index]['name']}',
                        // - ${widget.data[index]['area']}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
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
                            areaAdminId = widget.data[index]['uid'];
                            area = widget.data[index]['area'];
                          });
                        },
                        groupValue: _value,
                      ),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ShowAreaSupervisors(
                                // show supervisors for that area
                                role: 'super_admin',
                                areaAdminID: widget.data[index]['uid'],
                                areaAdminName: widget.data[index]['name'])));
                      },
                      child: Icon(Icons.people))
                ],
              );
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
            'لا يوجد مديري مناطق',
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

class DrawThatSupervisor extends StatefulWidget {
  const DrawThatSupervisor({Key? key, required this.data}) : super(key: key);
  final data;

  @override
  _DrawThatSupervisorState createState() => _DrawThatSupervisorState();
}

class _DrawThatSupervisorState extends State<DrawThatSupervisor> {
  @override
  Widget build(BuildContext context) {
    if (widget.data.length != 0) {
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
                    // - ${widget.data[index]['area']}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${widget.data[index]['area']}',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                  ),
                  // adding trim is important cause some timed data saved in a list with white space000
                  //all are unchecked because selectedUsersIds is empty, we must fill it with supervisors under selected area admin
                  value: selectedUsersIds
                      .contains(widget.data[index]['uid'].toString().trim()),
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (value) {
                    if (selectedUsersIds.contains(
                        widget.data[index]['uid'].toString().trim())) {
                      selectedUsersIds
                          .remove(widget.data[index]['uid'].toString().trim());
                      unSelectedUsersIds
                          .add(widget.data[index]['uid'].toString().trim());
                    } else {
                      selectedUsersIds
                          .add(widget.data[index]['uid'].toString().trim());
                      unSelectedUsersIds
                          .remove(widget.data[index]['uid'].toString().trim());
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
