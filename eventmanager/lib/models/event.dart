import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String title;
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

  const Event({
    required this.title,
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
  });

  static Event fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Event(
      title: snapshot["title"],
      description: snapshot["description"],
      uid: snapshot["uid"],
      likes: snapshot["likes"],
      eventId: snapshot["eventId"],
      datePublished: snapshot["datePublished"],
      username: snapshot["username"],
      postUrl: snapshot['postUrl'],
      profImage: snapshot['profImage'],
      startDate: snapshot['startDate'],
      endDate: snapshot['endDate'],
    );
  }

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "uid": uid,
        "likes": likes,
        "username": username,
        "eventId": eventId,
        "datePublished": datePublished,
        'postUrl': postUrl,
        'profImage': profImage,
        'startDate': startDate,
        'endDate': endDate,
      };
}
