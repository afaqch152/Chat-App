import 'package:chat_app/Authentication_Ui.dart/register_page.dart';
import 'package:chat_app/HomePage.dart';
import 'package:chat_app/UiHelper.dart';
import 'package:chat_app/forgetPasswordScreen.dart';
import 'package:chat_app/loginWithEmailData.dart';
import 'package:chat_app/loginWithPhoneNumberData.dart';
import 'package:chat_app/validation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPAge extends StatefulWidget {
  static const pageName = '/LoginPAge';

  const LoginPAge({super.key});

  @override
  State<LoginPAge> createState() => _LoginPAgeState();
}

class _LoginPAgeState extends State<LoginPAge> {
  late TextEditingController userNameController;
  late TextEditingController passwordController;

  final Loginformkey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userNameController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final hight = size.height;
    final width = size.width;
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 17, 103, 174),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 135),
                      child: Text(
                        "Don't have an account?",
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterPage(),
                            ));
                      },
                      child: Text("Sing Up"))
                ],
              ),
              Spacer(
                flex: 1,
              ),
              Center(
                child: Form(
                  child: Container(
                    width: 310,
                    height: 490,
                    decoration: BoxDecoration(
                        // image: DecorationImage(image: AssetImage('assets/imag.jpg')),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          'Login',
                          style: TextStyle(color: Colors.black, fontSize: 30),
                        ),
                        Text("Let's get to work"),

                        //TextFormField...
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: TextFormField(
                            controller: userNameController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter Email';
                              }
                              //else if (!validateEmail(value)) {
                              //   return 'Enter Vaild Email';
                              // }
                              else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                                hintText: 'Username...',
                                prefix: Icon(Icons.person),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15))),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: TextFormField(
                              controller: passwordController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter Password';
                                } else if (!validatePassword(value)) {
                                  return 'Password contain atleast \n one special char,numb,lower or upper case';
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                  hintText: 'Password...',
                                  prefix: Icon(Icons.lock),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(15)))),
                        ),
                        InkWell(
                          onTap: () {
                            login();
                          },
                          child: Container(
                            width: 270,
                            height: 50,
                            child: Center(
                                child: Text(
                              'Sign in',
                              style: TextStyle(color: Colors.white),
                            )),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 120),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ForgetPasswordScreen(),
                                  ));
                            },
                            child: const Text('Forget your password?'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Spacer(
                flex: 1,
              )
            ],
          ),
        ));
  }

  login() async {
    UserCredential? credential;
    UiHelper.showLoadingDialog(context, 'Loading...');
    try {
      credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: userNameController.text, password: passwordController.text)
          .then((value) {
        Navigator.pop(context);
      });
      loginWithEmail(context);
    } on FirebaseAuthException catch (ex) {
      //Cloase the loading dialog...
      Navigator.pop(context);
      UiHelper.showAlertDialog(context, "An error occured", ex.toString());
    }
  }
}
//Forget password...

resetPassword({required String email, required BuildContext context}) async {
  UserCredential? credential;
  try {
    credential = await FirebaseAuth.instance
        .sendPasswordResetEmail(email: email)
        .then((value) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPAge()));
    });
  } on FirebaseAuthException catch (e) {
    UiHelper.showAlertDialog(context, 'An error occured', e.toString());
  }
}
