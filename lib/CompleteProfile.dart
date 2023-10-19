import 'dart:io';
import 'dart:math';

import 'package:chat_app/HomePage.dart';
import 'package:chat_app/UiHelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class CompleteProfile extends StatefulWidget {
  const CompleteProfile({super.key});

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  final auth = FirebaseAuth.instance.currentUser;
  File? imageFile;
  TextEditingController fullNameController = TextEditingController();

  void selectImage(ImageSource source) async {
    XFile? pickFile = await ImagePicker().pickImage(source: source);
    if (pickFile != null) {
      cropImage(pickFile);
    }
  }

  void cropImage(XFile file) async {
    final croppedimage = await ImageCropper().cropImage(
        sourcePath: file.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 15);
    if (croppedimage != null) {
      setState(() {
        imageFile = File(croppedimage.path);
      });
    }
  }

  void showOptionButton() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Upload Profile Picture'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  selectImage(ImageSource.gallery);
                },
                leading: Icon(Icons.photo),
                title: Text('Select from Gallery'),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);

                  selectImage(ImageSource.camera);
                },
                leading: Icon(Icons.camera_alt),
                title: Text('Take a photo'),
              ),
            ],
          ),
        );
      },
    );
  }

  void checkValues() {
    String fullname = fullNameController.text.trim();

    if (fullname == "" || imageFile == null) {
      UiHelper.showAlertDialog(context, "Incomplete Data",
          "Please fill all the fileds and upload a profile picture");
    } else {
      uploadData();
    }
  }

  void uploadData() async {
    UiHelper.showLoadingDialog(context, "Uploading image...");
    UploadTask uploadTask = FirebaseStorage.instance
        .ref('userDp/' + '/${auth!.uid.toString()}')
        .putFile(imageFile!);
    TaskSnapshot snapshot = await uploadTask;
    String imageUrl = await snapshot.ref.getDownloadURL();

    await FirebaseFirestore.instance.collection("users").doc(auth!.uid).update({
      'username': fullNameController.text.trim(),
      'photoUrl': imageUrl
    }).then((value) {
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ));
      print('Data Uploaded');
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Complete Profile'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 19, 91, 150),
      ),
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: ListView(
          children: [
            SizedBox(
              height: height * 0.03,
            ),
            InkWell(
              onTap: () {
                showOptionButton();
              },
              child: CircleAvatar(
                backgroundImage: (imageFile != null)
                    ? FileImage(
                        imageFile!,
                      )
                    : null,
                radius: 60,
                child: (imageFile == null)
                    ? Icon(
                        Icons.person,
                        size: 60,
                      )
                    : null,
              ),
            ),
            SizedBox(
              height: height * 0.03,
            ),
            TextField(
              controller: fullNameController,
              decoration: InputDecoration(hintText: 'Full Name'),
            ),
            SizedBox(
              height: height * 0.03,
            ),
            SizedBox(
              height: height * 0.06,
              child: ElevatedButton(
                onPressed: () {
                  checkValues();
                },
                child: Text('Submit'),
              ),
            )
          ],
        ),
      )),
    );
  }
}
