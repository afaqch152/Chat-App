import 'package:chat_app/HomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

loginWithPhoneNumber(BuildContext context) async {
  final auth = FirebaseAuth.instance;
  final user = auth.currentUser;

  if (user != null) {
    QuerySnapshot<Map<String, dynamic>> result = await FirebaseFirestore
        .instance
        .collection('users')
        .where('id', isEqualTo: user.uid)
        .get();
    List<DocumentSnapshot> doucument = result.docs;
    if (doucument.isEmpty) {
      FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'username': user.displayName,
        'phoneNumber': user.phoneNumber,
        'photoUrl': user.photoURL,
        'id': user.uid
      });
    }
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ));
  }
}
