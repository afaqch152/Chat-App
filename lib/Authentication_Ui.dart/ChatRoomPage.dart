import 'dart:developer';
import 'dart:io';
import 'package:chat_app/ChatRoomModel.dart';
import 'package:chat_app/MessageModel.dart';
import 'package:chat_app/UiHelper.dart';
import 'package:chat_app/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ChatRoomPage extends StatefulWidget {
  String username;
  String photoUrl;
  ChatRoomModel? chatroom;
  String? sender;

  ChatRoomPage(
      {super.key,
      required this.sender,
      required this.username,
      required this.photoUrl,
      required this.chatroom});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  MessageModel? messageModel;
  var currentUser = FirebaseAuth.instance.currentUser!.uid;
  File? imageFile;

  TextEditingController messageController = TextEditingController();

  void selectImage(ImageSource source) async {
    XFile? pickFile =
        await ImagePicker().pickImage(source: source).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage();
      }
    });
  }

  Future uploadImage() async {
    String? fileName = widget.chatroom!.chatroomid;
    var ref =
        FirebaseStorage.instance.ref().child("images").child("$fileName.jpg");

    var uploadTask = await ref.putFile(imageFile!);
    String imageUrl = await uploadTask.ref.getDownloadURL();
    print(imageUrl);
  }

  // void cropImage(XFile file) async {
  //   final croppedimage = await ImageCropper().cropImage(
  //       sourcePath: file.path,
  //       aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
  //       compressQuality: 15);
  //   if (croppedimage != null) {
  //     setState(() {
  //       imageFile = File(croppedimage.path);
  //     });
  //   }
  // }

  void sendMessage() async {
    String msg = messageController.text.trim();
    messageController.clear();

    if (msg != "") {
      //Send msg
      MessageModel newMessage = MessageModel(
          messageid: uuid.v1(),
          sender: widget.sender,
          createdon: DateTime.now(),
          text: msg,
          type: "text",
          seen: false);
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatroom!.chatroomid)
          .collection("messages")
          .doc(newMessage.messageid)
          .set(newMessage.toMap());
      widget.chatroom!.lastMessage = msg;
      FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(widget.chatroom!.chatroomid)
          .set(widget.chatroom!.toMap());

      log('msg SENT!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 29, 91, 141),
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back),
              ),
              CircleAvatar(
                backgroundImage: NetworkImage(widget.photoUrl),
              ),
              // SizedBox(
              //   width: 10,
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7),
                child: Text(widget.username),
              )
            ],
          )),
      body: SafeArea(
          child: Container(
        child: Column(
          children: [
            //Chat Message Appear...
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                color: Colors.grey.shade200,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('chatrooms')
                      .doc(widget.chatroom!.chatroomid)
                      .collection('messages')
                      .orderBy("createdon", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        QuerySnapshot dataSnapshot =
                            snapshot.data as QuerySnapshot;
                        return ListView.builder(
                          reverse: true,
                          itemCount: dataSnapshot.docs.length,
                          itemBuilder: (context, index) {
                            MessageModel currentMessage = MessageModel.fromMap(
                                dataSnapshot.docs[index].data()
                                    as Map<String, dynamic>);
                            String sender1 =
                                snapshot.data!.docs[index]['sender'].toString();
                            return Row(
                              mainAxisAlignment: sender1 == widget.sender
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                Container(
                                    margin: EdgeInsets.symmetric(vertical: 2),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: sender1 == widget.sender
                                          ? Color.fromARGB(255, 190, 185, 185)
                                          : Colors.blue,
                                    ),
                                    child: InkWell(
                                        onLongPress: () {
                                          var docs =
                                              snapshot.data!.docs[index].data();
                                          UiHelper.deleteDialog(
                                            context,
                                            'Message Delete',
                                            'Are you sure to delete this message',
                                            () {
                                              Navigator.pop(context);
                                              FirebaseFirestore.instance
                                                  .collection('chatrooms')
                                                  .doc(widget
                                                      .chatroom!.chatroomid)
                                                  .collection('messages')
                                                  .doc(messageModel?.messageid)
                                                  .delete();
                                            },
                                          );
                                        },
                                        child: Text(snapshot
                                            .data!.docs[index]['text']
                                            .toString()))),
                              ],
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        const Center(
                          child: Text(
                              'An error occured!Please Check your internet connection'),
                        );
                      } else {
                        return const Center(
                          child: Text('Say hi to you new friends'),
                        );
                      }
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Text('Something went wrong');
                  },
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 5,
              ),
              child: Row(
                children: [
                  Flexible(
                    child: TextField(
                      maxLines: null,
                      controller: messageController,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () {
                              selectImage(ImageSource.gallery);
                            },
                            icon: Icon(Icons.photo)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        hintText: 'Enter message',
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        sendMessage();
                      },
                      icon: Icon(
                        Icons.send,
                        color: Theme.of(context).colorScheme.secondary,
                      ))
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
