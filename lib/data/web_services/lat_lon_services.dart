import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class LatLongServices {
  var collection = FirebaseFirestore.instance.collection('users');
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('dd/MM -- HH:mm');

  Future<void> updateUserGeoPoint(lat, long) async {
    var user = FirebaseAuth.instance.currentUser;
    final String formatted = formatter.format(now);

    return await collection
        .doc(user!.uid)
        .update({'location': GeoPoint(lat, long), 'date_time': formatted})
        .then((value) => print("location Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }
}
