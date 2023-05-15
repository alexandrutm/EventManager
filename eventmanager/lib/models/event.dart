import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Event {
  final String description;
  final String uid;
  final String username;
  final dynamic likes;
  final String eventId;
  final DateTime datePublished;
  final String postUrl;
  final String profImage;
  final DateTime startDate;
  final DateTime endDate;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  const Event({
    required this.description,
    required this.uid,
    required this.username,
    required this.likes,
    required this.eventId,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
  });

  static Event fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Event(
      description: snapshot["description"],
      uid: snapshot["uid"],
      likes: snapshot["likes"],
      eventId: snapshot["postId"],
      datePublished: snapshot["datePublished"],
      username: snapshot["username"],
      postUrl: snapshot['postUrl'],
      profImage: snapshot['profImage'],
      startDate: snapshot['startDate'],
      endDate: snapshot['endDate'],
      startTime: snapshot['startTime'],
      endTime: snapshot['endTime'],
    );
  }

  Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "likes": likes,
        "username": username,
        "postId": eventId,
        "datePublished": datePublished,
        'postUrl': postUrl,
        'profImage': profImage,
        'startDate': startDate,
        'endDate': endDate,
        'startTime': startTime,
        'endTime': endTime
      };
}
