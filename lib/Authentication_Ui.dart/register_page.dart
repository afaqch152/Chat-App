import 'package:chat_app/Authentication_Ui.dart/login_page.dart';
import 'package:chat_app/CompleteProfile.dart';
import 'package:chat_app/HomePage.dart';
import 'package:chat_app/UiHelper.dart';
import 'package:chat_app/validation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class RegisterPage extends StatefulWidget {
  static const pageName = '/RegisterPage';

  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => RegisterPage1();
}

class RegisterPage1 extends State<RegisterPage> {
  late TextEditingController FullNameController;
  late TextEditingController EmailAddressController;
  late TextEditingController PasswordController;

  final Registerformkey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FullNameController = TextEditingController();
    EmailAddressController = TextEditingController();
    PasswordController = TextEditingController();
  }

  @override
  void dispose() {
    FullNameController.dispose();
    EmailAddressController.dispose();

    PasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final hight = size.height;
    final width = size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Form(
          key: Registerformkey,
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 140),
                      child: Text("Already have an account?"),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPAge(),
                              ));
                        },
                        child: Text('Login')),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(right: 70, top: 25),
                  child: Text(
                    'Create your free account...',
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      'Full name',
                      style: TextStyle(
                          fontSize: 20, color: Color.fromARGB(255, 78, 77, 77)),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 1),
                  child: TextFormField(
                    controller: FullNameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter full name';
                      } else if (!validateUserName(value)) {
                        return 'Enter Vaild name';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        hintText: 'Your name', border: OutlineInputBorder()),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 11, horizontal: 14),
                    child: Text(
                      'Email address',
                      style: TextStyle(
                          fontSize: 20, color: Color.fromARGB(255, 78, 77, 77)),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 1),
                  child: TextFormField(
                    controller: EmailAddressController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Email';
                      } else if (!validateEmail(value)) {
                        return 'Enter Vaild Email';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        hintText: 'Example@gmail.com',
                        border: OutlineInputBorder()),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 11, horizontal: 14),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Password',
                      style: TextStyle(
                          fontSize: 20, color: Color.fromARGB(255, 78, 77, 77)),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 1),
                  child: TextFormField(
                    controller: PasswordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Password';
                        // } else if (!validatePassword(value)) {
                        //   return 'Password contain atleast \n one special char,numb,lower or upper case';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        suffixIcon: Icon(Icons.remove_red_eye),
                        hintText: 'Enter password',
                        border: OutlineInputBorder()),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  child: SizedBox(
                    width: width * 0.9,
                    height: hight,
                    child: ElevatedButton(
                        onPressed: () {
                          createAccount();
                          if (Registerformkey.currentState!.validate()) {
                            createAccount();
                          }
                        },
                        child: Text('Create your account')),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                flex: 1,
                child: Text(
                    'By signing up,you agree to our communication and usage \n terms Already have an account?'),
              ),
              InkWell(
                onTap: () {},
                child: Text(
                  'Sign in',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              Spacer(
                flex: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void createAccount() async {
    UserCredential? userCredential;
    String email = EmailAddressController.text.trim();
    String password = PasswordController.text.trim();

    UiHelper.showLoadingDialog(context, "Creating new account...");

    //Create new account
    try {
      userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPAge(),
          ));
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      UiHelper.showAlertDialog(context, "An error occured", e.toString());
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Something went wrong')));
    }
  }
}
