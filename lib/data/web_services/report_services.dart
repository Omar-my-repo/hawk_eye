import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReportServices {
  var collection = FirebaseFirestore.instance.collection('users');
  var user = FirebaseAuth.instance.currentUser;

  uploadUserReport({required String report, required String date}) async {
    return await collection.doc(user!.uid).collection('reports').add({
      'body': report,
      'date': date,
    });
  }
}
