import 'package:chat_app/Authentication_Ui.dart/FirstPage.dart';
import 'package:chat_app/Authentication_Ui.dart/login_page.dart';
import 'package:chat_app/Authentication_Ui.dart/phone_number_auth.dart';
import 'package:chat_app/Authentication_Ui.dart/register_page.dart';
import 'package:chat_app/Authentication_Ui.dart/token_code_ui.dart';
import 'package:chat_app/CompleteProfile.dart';
import 'package:chat_app/HomePage.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/route_setting.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'forgetPasswordScreen.dart';

var uuid = Uuid();
final auth = FirebaseAuth.instance;
final user = auth.currentUser;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        home: user != null ? HomePage() : PhoneNumberAuth());
  }
}

// class MyAppLogin extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'Flutter Demo',
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//         ),
//         home: // ChatScreen(),
//             FirstPage()
//         // CompleteProfile(),
//         );
//   }
// }
