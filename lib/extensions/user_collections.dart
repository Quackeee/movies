import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

extension UserCollections on User {
  CollectionReference<Map<String, dynamic>> get movies =>
      FirebaseFirestore.instance.collection("user_data")
          .doc(this.uid)
          .collection("user_movies");
}