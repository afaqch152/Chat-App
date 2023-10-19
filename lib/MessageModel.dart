// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MessageModel {
  String? messageid;
  String? sender;
  String? text;
  bool? seen;
  String? type;
  DateTime? createdon;
  MessageModel(
      {this.sender,
      this.text,
      this.seen,
      this.createdon,
      this.messageid,
      this.type});

  MessageModel.fromMap(Map<String, dynamic> map) {
    sender = map["sender"];
    messageid = map["messageid"];
    text = map["text"];
    seen = map["seen"];
    createdon = map["creatdon"];
    type = map["type"];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'messageid': messageid,
      'sender': sender,
      'text': text,
      'seen': seen,
      'createdon': createdon?.millisecondsSinceEpoch,
      'type': type,
    };
  }

  @override
  String toString() {
    return 'MessageModel(sender: $sender, text: $text, seen: $seen, createdon: $createdon)';
  }

  @override
  bool operator ==(covariant MessageModel other) {
    if (identical(this, other)) return true;

    return other.sender == sender &&
        other.text == text &&
        other.seen == seen &&
        other.createdon == createdon;
  }

  @override
  int get hashCode {
    return sender.hashCode ^ text.hashCode ^ seen.hashCode ^ createdon.hashCode;
  }
}
