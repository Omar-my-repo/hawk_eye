import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maps/shared_component/drawer_screens/drawer_area_admin.dart';
import 'package:maps/shared_component/logo_background.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../find_next_screen.dart';
import '../../shared_component/drawer_screens/drawer_admin.dart';
import '../../shared_component/drawer_screens/drawer_superadmin.dart';
import '../../shared_component/drawer_screens/drawer_user.dart';
//import 'internet_error.dart';

class AdminContacts extends StatefulWidget {
  AdminContacts({Key? key, required this.role}) : super(key: key);
  final role;

  @override
  _AdminContactsState createState() => _AdminContactsState();
}

class _AdminContactsState extends State<AdminContacts> {
  var user = FirebaseAuth.instance.currentUser;

  Future<ConnectivityResult> getInternetResult() async {
    return await Connectivity().checkConnectivity();
  }

  //
  // final Connectivity _connectivity = Connectivity();
  // late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  // String _connectionStatus = 'Unknown';
  //
  // Future<void> initConnectivity() async {
  //   ConnectivityResult result = ConnectivityResult.none;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     result = await _connectivity.checkConnectivity();
  //   } on PlatformException catch (e) {
  //     print(e.toString());
  //   }
  //
  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   if (!mounted) {
  //     return Future.value(null);
  //   }
  //
  //   return _updateConnectionStatus(result);
  // }
  //
  // Future<void> _updateConnectionStatus(ConnectivityResult result) async {
  //   switch (result) {
  //     case ConnectivityResult.wifi:
  //     case ConnectivityResult.mobile:
  //     case ConnectivityResult.none:
  //       setState(() => _connectionStatus = result.toString());
  //       break;
  //     default:
  //       setState(() => _connectionStatus = 'Failed to get connectivity.');
  //       break;
  //   }
  // }
  //
  //
  //
  // @override
  // void initState() {
  // ignore: todo
  //   // TODO: implement initState
  //   super.initState();
  //   initConnectivity();
  //   _connectivitySubscription =
  //       _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  //
  //
  // }
  //
  // @override
  // void dispose() {
  // ignore: todo
  //   // TODO: implement dispose
  //   super.dispose();
  //   _connectivitySubscription.cancel();
  // }

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
              'تواصل',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          drawer: checkRole(),
          // body:_connectionStatus!=ConnectivityResult.none.toString() ?
          body: Stack(
            children: [
              LogoBackground(),
              SingleChildScrollView(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                //child: drawBodyByRole(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'مديري المناطق',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .where('role', isEqualTo: 'area_admin')
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var data = snapshot.data!.docs;
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return drawContacts(
                                  name: data[index]['name'],
                                  phone: data[index]['phone'],
                                  area: data[index]['area']);
                            },
                          );
                        }
                        return Center(child: CircularProgressIndicator());
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'الـمشرفين',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .where('role', isEqualTo: 'admin')
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var data = snapshot.data!.docs;
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return drawContacts(
                                  name: data[index]['name'],
                                  phone: data[index]['phone'],
                                  area: data[index]['area']);
                            },
                          );
                        }
                        return Center(child: CircularProgressIndicator());
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'المندوبين',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .where('role', isEqualTo: 'user')
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var data = snapshot.data!.docs;
                          return ListView.builder(
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return drawContacts(
                                name: data[index]['name'],
                                phone: data[index]['phone'],
                                area: data[index]['area'],
                              );
                            },
                          );
                        }
                        return Center(child: CircularProgressIndicator());
                      },
                    ),
                  ],
                ),
              )),
            ],
          )
          // : InternetError()
          ),
    );
  }

  Widget checkRole() {
    if (widget.role == 'super_admin') {
      return DrawerSuperAdmin(role: this.widget.role);
    } else if (widget.role == 'admin') {
      return DrawerAdmin(role: this.widget.role);
    } else if (widget.role == 'area_admin') {
      return DrawerAreaAdmin(role: this.widget.role);
    } else {
      return DrawerUser();
    }
  }

/*  Widget drawBodyByRole() {
    if (widget.role == 'super_admin') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text(
            'مديري المناطق',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .where('role', isEqualTo: 'area_admin')
                .get(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data!.docs;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return drawContacts(
                        name: data[index]['name'],
                        phone: data[index]['phone'],
                        area: data[index]['area']);
                  },
                );
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'الـمشرفين',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .where('role', isEqualTo: 'admin')
                .get(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data!.docs;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return drawContacts(
                        name: data[index]['name'],
                        phone: data[index]['phone'],
                        area: data[index]['area']);
                  },
                );
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'المندوبين',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .where('role', isEqualTo: 'user')
                .get(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data!.docs;
                return ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return drawContacts(
                      name: data[index]['name'],
                      phone: data[index]['phone'],
                      area: data[index]['area'],
                    );
                  },
                );
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        ],
      );
    } else if (widget.role == 'area_admin') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text(
            'الـمشرفين',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .where('role', isEqualTo: 'admin')
                .where('areaAdminID', isEqualTo: user!.uid)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data!.docs;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return drawContacts(
                        name: data[index]['name'],
                        phone: data[index]['phone'],
                        area: data[index]['area']);
                  },
                );
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'المندوبين',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .where('role', isEqualTo: 'user')
                .where('areaAdminID', isEqualTo: user!.uid)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data!.docs;
                return ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return drawContacts(
                      name: data[index]['name'],
                      phone: data[index]['phone'],
                      area: data[index]['area'],
                    );
                  },
                );
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        ],
      );
    } else if (widget.role == 'admin') {
      return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .where('supervisorID', isEqualTo: user!.uid)
            //.where('email',isNotEqualTo: user!.email)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.docs.length != 0) {
              var data = snapshot.data!.docs;
              if (data.length == 1 && data[0]['email'] == user!.email) {
                return Column(
                  children: [
                    SizedBox(
                      height: 70,
                    ),
                    Center(
                        child: Text(
                      'لا يوجد مندوبين لديك.',
                      style: TextStyle(fontSize: 24),
                    )),
                  ],
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  if (data[index]['email'] == user!.email) {
                    return Container();
                  }
                  return drawContacts(
                      name: data[index]['name'],
                      phone: data[index]['phone'],
                      area: data[index]['area']);
                },
              );
            }
          }
          return Center(child: CircularProgressIndicator());
        },
      );
    } else {
      return FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('users').doc(user!.uid).get(),
        builder: (context, snap) {
          if (snap.hasData) {
            if (snap.data!['supervisorID'] != '') {
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(snap.data!['supervisorID'])
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // return widget(child: Text(snapshot.data!['name']));
                    return ListView.builder(
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return drawContacts(
                          name: snapshot.data!['name'],
                          phone: snapshot.data!['phone'],
                          area: snapshot.data!['area'],
                        );
                      },
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              );
            } else {
              return Column(
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  Container(
                    width: double.infinity,
                    child: Text('انت غير مسجل لدي أي مشرف',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24)),
                  ),
                ],
              );
            }
          }
          return Center(child: CircularProgressIndicator());
        },
      );
    }
  }*/

  Widget drawContacts(
      {required String name, required String phone, required String area}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
      ),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: Colors.black26,
            width: .5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              const SizedBox(height: 15),
              Row(
                children: [
                  Icon(Icons.person),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      '$name', //and email
                      style: TextStyle(
                        fontSize: 22,
                        // fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.house),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      '$area',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  launch("tel:$phone");
                },
                child: Row(
                  children: [
                    Icon(Icons.phone),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        '$phone',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
