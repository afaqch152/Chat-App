import 'package:chat_app/Authentication_Ui.dart/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  late TextEditingController forgetPassowrdController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    forgetPassowrdController = TextEditingController();
  }

  @override
  void dispose() {
    forgetPassowrdController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final hight = size.height;
    final width = size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Forget passowrd ',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: SizedBox(
              width: width * 0.8,
              height: hight,
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 30, left: 60, right: 45),
                  child: Image.asset(
                    'assets/images/download.png',
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10, top: 25),
              child: Text(
                "Did someone forget their password?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "                            That's ok...\n Just enter the email address you've used to \n register with us ans we'll send you a reset link!",
              style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 135, 132, 132),
                  fontWeight: FontWeight.w400),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(26),
            child: TextField(
              controller: forgetPassowrdController,
              decoration: InputDecoration(
                  hintText: "Email ID", border: OutlineInputBorder()),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: SizedBox(
                  width: width * 0.9,
                  height: hight * 0.07,
                  child: ElevatedButton(
                      onPressed: () {
                        resetPassword(
                            email: forgetPassowrdController.text,
                            context: context);
                      },
                      child: Text(" Submit "))),
            ),
          ),
          Spacer(
            flex: 2,
          )
        ],
      ),
    );
  }
}
