// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ChatRoomModel {
  String? chatroomid;
  Map<String, dynamic>? participants;
  String? lastMessage;
  ChatRoomModel({this.chatroomid, this.participants, this.lastMessage});

  ChatRoomModel.fromMap(Map<String, dynamic> map) {
    chatroomid = map["chatroomid"];
    participants = map["participants"];
    lastMessage = map["lastMessage"];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'chatroomid': chatroomid,
      'participants': participants,
      'lastMessage': lastMessage,
    };
  }

  @override
  String toString() =>
      'ChatRoomModel(chatroomid: $chatroomid, participants: $participants)';

  @override
  bool operator ==(covariant ChatRoomModel other) {
    if (identical(this, other)) return true;

    return other.chatroomid == chatroomid && other.participants == participants;
  }

  @override
  int get hashCode => chatroomid.hashCode ^ participants.hashCode;
}
