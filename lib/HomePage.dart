import 'dart:developer';

import 'package:chat_app/Authentication_Ui.dart/ChatRoomPage.dart';
import 'package:chat_app/ChatRoomModel.dart';
import 'package:chat_app/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var currentUserId = FirebaseAuth.instance.currentUser!.uid;
  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  Future<ChatRoomModel?> getChatroomModel(String targetUserId) async {
    ChatRoomModel? chatroom;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where("participants.${currentUserId}", isEqualTo: true)
        .where("participants.${targetUserId}", isEqualTo: true)
        .get();

    if (snapshot.docs.length > 0) {
      var docData = snapshot.docs[0].data();
      ChatRoomModel existingChatroom =
          ChatRoomModel.fromMap(docData as Map<String, dynamic>);
      chatroom = existingChatroom;
    } else {
      //Create new chat...
      ChatRoomModel newchatRoom =
          ChatRoomModel(chatroomid: uuid.v1(), lastMessage: "", participants: {
        currentUserId: true,
        targetUserId: true,
      });
      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(newchatRoom.chatroomid)
          .set(newchatRoom.toMap());
      chatroom = newchatRoom;
      log("new chat room created");
    }
    return chatroom;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(left: 18, top: 8),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Chats',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                      filled: true,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {});
                        },
                        icon: Icon(Icons.search),
                        color: Colors.black,
                      ),
                      labelText: 'Search',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(12)))),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('username', isEqualTo: searchController.text)
                    .where('id',
                        isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.docs.length > 0) {
                        return ListTile(
                          onTap: () async {
                            ChatRoomModel? chatroomModel =
                                await getChatroomModel(
                                    snapshot.data!.docs[0]["id"].toString());
                            if (getChatroomModel(
                                    snapshot.data!.docs[0]["id"].toString()) !=
                                null) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatRoomPage(
                                      sender: currentUserId,
                                      username: snapshot
                                          .data!.docs[0]["username"]
                                          .toString(),
                                      photoUrl: snapshot
                                          .data!.docs[0]["photoUrl"]
                                          .toString(),
                                      chatroom: chatroomModel,
                                    ),
                                  ));
                            }
                          },
                          title: Text(
                              snapshot.data!.docs[0]["username"].toString()),
                          subtitle: Text(snapshot.data!.docs[0]["emailAccount"]
                              .toString()),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                snapshot.data!.docs[0]["photoUrl"].toString()),
                            backgroundColor: Colors.grey,
                          ),
                          trailing: Icon(Icons.keyboard_arrow_right),
                        );
                      } else {
                        return Container();
                      }
                    } else if (snapshot.hasError) {
                      return Text(
                          'An error occured!${snapshot.error.toString()}');
                    } else {
                      return Text('No result found');
                    }
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ),
            Expanded(
                flex: 1,
                child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 11),
                      child: Text(
                        'Recent Chats',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400),
                      ),
                    ))),
            Expanded(
              flex: 7,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('chatrooms')
                    .where("participants.$currentUserId", isEqualTo: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      var ChatRoomsnapshot = snapshot.data;
                      return ListView.builder(
                        itemCount: ChatRoomsnapshot!.docs.length,
                        itemBuilder: (context, index) {
                          ChatRoomModel chatRoomModel1 = ChatRoomModel.fromMap(
                              ChatRoomsnapshot.docs[index].data()
                                  as Map<String, dynamic>);
                          Map<String, dynamic> participant =
                              chatRoomModel1.participants!;
                          List<String> participantsKey =
                              participant.keys.toList();
                          participantsKey.remove(currentUserId);
                          return StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .where('id', isNotEqualTo: currentUserId)
                                .where('id', isEqualTo: participantsKey[0])
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        snapshot.data!.docs[0]['photoUrl']),
                                  ),
                                  title:
                                      Text(snapshot.data!.docs[0]['username']),
                                  subtitle: Text(
                                      chatRoomModel1.lastMessage.toString()),
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) {
                                        return ChatRoomPage(
                                            sender: currentUserId,
                                            username: snapshot.data!.docs[0]
                                                ['username'],
                                            photoUrl: snapshot.data!.docs[0]
                                                ['photoUrl'],
                                            chatroom: chatRoomModel1);
                                      },
                                    ));
                                  },
                                );
                              } else {
                                return Text(snapshot.error.toString());
                              }
                            },
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    } else {
                      return Center(
                        child: Text('No Chats'),
                      );
                    }
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            Spacer(
              flex: 2,
            )
          ],
        ),
      ),
    );
  }
}
