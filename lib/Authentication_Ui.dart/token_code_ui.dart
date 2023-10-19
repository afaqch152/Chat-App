// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/CompleteProfile.dart';
import 'package:chat_app/HomePage.dart';

class OtpVerifiedScreen extends StatefulWidget {
  String verificationId;
  OtpVerifiedScreen({
    Key? key,
    required this.verificationId,
  }) : super(key: key);
  static const pageName = '/OtpVerifiedScreen';

  @override
  State<OtpVerifiedScreen> createState() => _OtpVerifiedScreenState();
}

class _OtpVerifiedScreenState extends State<OtpVerifiedScreen> {
  late TextEditingController otpController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    otpController = TextEditingController();
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  void otpHandle() async {
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId, smsCode: otpController.text);
    await FirebaseAuth.instance
        .signInWithCredential(phoneAuthCredential)
        .then((value) {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return CompleteProfile();
        },
      ));
    }).onError((error, stackTrace) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Something went wrong')));
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
              flex: 1,
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.arrow_back_sharp,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const Expanded(
                    flex: 5,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'OTP',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 34),
                      ),
                    ),
                  )
                ],
              )),
          // FIRST CHILD IS COMPLETE
          Expanded(
            flex: 3,
            child: ClipOval(
                child: Container(
              child: Image.asset('assets/images'),
              color: Colors.black,
            )),
          ),
          Expanded(
              flex: 1,
              child: SizedBox(
                height: height,
                width: width,
                child: const Center(
                  child: Text(
                    'Verification code',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 26,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              )),
          Expanded(
              flex: 1,
              child: SizedBox(
                height: height,
                width: width,
                child: const Center(
                  child: Text(
                    'We have sent the code verification to \n       Your Mobile Number',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w700),
                  ),
                ),
              )),
          Expanded(
              flex: 1,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: SizedBox(
                  width: width,
                  height: height,
                  child: TextField(
                    controller: otpController,
                    decoration: InputDecoration(
                      fillColor: Color.fromARGB(255, 195, 203, 209),
                      filled: true,
                      prefixIcon: Icon(
                        Icons.verified,
                        color: Colors.deepPurple,
                      ),
                      hintText: 'verification code',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(49),
                      ),
                    ),
                  ),
                ),
              )), // TEXT FIELD ENDED
          const Spacer(
            flex: 1,
          ),
          Expanded(
              flex: 1,
              child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 18),
                  child: ElevatedButton(
                      onPressed: () {
                        otpHandle();
                      },
                      child: Text('Verify')))),
          // OTP CHILD IS COMPLETED
          const Spacer(
            flex: 1,
          )
        ],
      )),
    );
  }
}
