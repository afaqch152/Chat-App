import 'package:chat_app/Authentication_Ui.dart/phone_number_auth.dart';
import 'package:chat_app/HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

final auth = FirebaseAuth.instance;

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  checkScreen() async {
    final user = auth.currentUser;
    if (user != null) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ));
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PhoneNumberAuth(),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("First"),
      ),
      body: Container(
        color: Colors.black,
        child: Center(
          child: ElevatedButton(
              onPressed: () {
                checkScreen();
              },
              child: Text("Click")),
        ),
      ),
    );
  }
}
