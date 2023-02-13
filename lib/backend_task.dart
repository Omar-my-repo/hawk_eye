import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  Workmanager().executeTask(
    (task, inputData) async {
      await Firebase.initializeApp(); // don't remove
      final String userID = inputData!['userID']!;
      final DateTime now = DateTime.now();
      final DateFormat formatter = DateFormat('dd/MM -- HH:mm');
      final String formatted = formatter.format(now);

      await Geolocator.getCurrentPosition().then(
        (position) async {
          print(
              '--------------location updated background ${position.latitude}');

          //Todo change user id
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userID)
              .update({
            'location': GeoPoint(position.latitude, position.longitude),
            'date_time': formatted,
          });
        },
      );
      return Future.value(true);
    },
  );
}
