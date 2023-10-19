import 'package:chat_app/Authentication_Ui.dart/login_page.dart';
import 'package:chat_app/Authentication_Ui.dart/register_page.dart';
import 'package:chat_app/Authentication_Ui.dart/token_code_ui.dart';
import 'package:chat_app/HomePage.dart';
import 'package:chat_app/loginWithEmailData.dart';
import 'package:chat_app/loginWithPhoneNumberData.dart';
import 'package:chat_app/validation.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class PhoneNumberAuth extends StatefulWidget {
  const PhoneNumberAuth({super.key});
  static const pageName = '/PhoneNumberAuth';
  @override
  State<PhoneNumberAuth> createState() => _PhoneNumberAuthState();
}

class _PhoneNumberAuthState extends State<PhoneNumberAuth> {
  late TextEditingController phoneNumberController;
  final phoneformkey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;

  void initState() {
    super.initState();
    phoneNumberController = TextEditingController();
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    super.dispose();
  }

  Country country = Country(
      phoneCode: '92',
      countryCode: 'PK',
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: 'Pak',
      example: 'Pak',
      displayName: 'Pak',
      displayNameNoCountryCode: 'Pak',
      e164Key: "");
  @override
  Widget build(BuildContext context) {
    //MediaQuery...
    final Size size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Expanded(
                        flex: 6,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 13, top: 20),
                            child: SizedBox(
                              width: width,
                              height: height,
                              child: Text(
                                'Login Account',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        )),
                    Expanded(
                        flex: 4,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12, top: 15),
                            child: SizedBox(
                              width: width,
                              height: height,
                              child: Text(
                                'Hello, welcome back to our account',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 15),
                              ),
                            ),
                          ),
                        ))
                  ],
                )),
            // First child column is ended....
            Spacer(
              flex: 1,
            ),
            Expanded(
                flex: 1,
                child: Center(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 12, right: 12, top: 10),
                    child: Opacity(
                      opacity: 0.5,
                      child: Container(
                        width: width,
                        height: height,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 222, 225, 228),
                            borderRadius: BorderRadius.circular(48)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    flex: 5,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => LoginPAge(),
                                            ));
                                      },
                                      child: Container(
                                          width: width * 0.83,
                                          height: height * 0.85,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(34)),
                                          child: SizedBox(
                                              width: width,
                                              height: height,
                                              child: Center(
                                                  child: Text(
                                                'E-mail',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black),
                                              )))),
                                    )),
                                Spacer(
                                  flex: 1,
                                ),
                                Expanded(
                                    flex: 5,
                                    child: InkWell(
                                      onTap: () {},
                                      child: Container(
                                          width: width * 0.85,
                                          height: height * 0.88,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(34)),
                                          child: SizedBox(
                                              width: width,
                                              height: height,
                                              child: Center(
                                                  child: Padding(
                                                padding:
                                                    const EdgeInsets.all(2),
                                                child: Text(
                                                  'phone number',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              )))),
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
            // SECOND CHILD COMPLETE
            Expanded(
                flex: 1,
                child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 25, bottom: 7),
                      child: Text(
                        'Phone Number',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                    ))),
            Expanded(
                flex: 1,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  child: Container(
                    width: width,
                    height: height,
                    child: Form(
                      key: phoneformkey,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: phoneNumberController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter phone number';
                          } else if (!validatePhoneNo(value)) {
                            return 'Enter PhoneNumber with Countery Code';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          fillColor: Color.fromARGB(255, 243, 245, 247),
                          filled: true,
                          prefixIcon: Container(
                            padding:
                                EdgeInsets.only(top: 15, left: 7, right: 8),
                            child: InkWell(
                              child: Text(
                                  '${country.flagEmoji}+${country.phoneCode}'),
                              onTap: () {
                                showCountryPicker(
                                  context: context,
                                  onSelect: (value) {
                                    setState(() {
                                      country = value;
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                          hintText: 'Enter phone number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ),
                )), // TEXT FIELD COMPLETE
            const Spacer(
              flex: 1,
            ),
            Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 10, bottom: 5),
                  child: ElevatedButton(
                      onPressed: () {
                        sendOtp();
                        if (phoneformkey.currentState!.validate()) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text('next')));
                        }
                      },
                      child: Center(
                        child: Text('Request OTP'),
                      )),
                )),
            // OTP CHILD IS COMPLETED
            Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(top: 18, bottom: 18),
                  child: Center(
                    child: Text(
                      '--------------------or sign in with Google--------------------',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 88, 81, 81),
                      ),
                    ),
                  ),
                )),
            //Google sign in button...
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  handleGoogleFunction();
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 1),
                  child: Opacity(
                    opacity: 0.6,
                    child: Container(
                      height: height,
                      width: width,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromARGB(255, 236, 231, 231),
                              spreadRadius: 0.3),
                          BoxShadow(
                              color: Colors.white10,
                              offset: Offset(1, 1),
                              spreadRadius: 0.6)
                        ],
                        borderRadius: BorderRadius.circular(35),
                        border: Border.all(
                          color: Color.fromARGB(255, 244, 241, 241),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                              flex: 7,
                              child: SizedBox(
                                  width: width,
                                  height: height,
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12),
                                        child: Center(
                                          child: Text(
                                            ' Google',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black),
                                          ),
                                        ),
                                      )))),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // GOOGLE BUTTON ENDED
            Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Spacer(
                        flex: 1,
                      ),
                      Expanded(
                          flex: 4,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Not register yet?',
                              style: TextStyle(color: Colors.black87),
                            ),
                          )),
                      Expanded(
                          flex: 4,
                          child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RegisterPage(),
                                    ));
                              },
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Create an Account',
                                    style: TextStyle(color: Colors.red),
                                  )))),
                      Spacer(
                        flex: 1,
                      )
                    ],
                  ),
                )),

            Spacer(
              flex: 1,
            )
          ],
        ),
      ),
    );
  }

  void handleGoogleFunction() {
    signInWithGoogle().then((value) {
      loginWithEmail(context);
    }).onError((error, stackTrace) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Something went wron')));
    });
    ;
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  void sendOtp() {
    String phoneNumber = '+92${phoneNumberController.text.trim()}';
    auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (phoneAuthCredential) {},
      verificationFailed: (error) {},
      codeSent: (verificationId, forceResendingToken) {
        Navigator.pushNamed(context, OtpVerifiedScreen.pageName,
            arguments: verificationId);
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );
  }
}
