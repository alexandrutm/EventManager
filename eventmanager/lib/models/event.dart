import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String title;
  final String description;
  final String uid;
  final String username;
  final List attendees;
  final String eventId;
  final DateTime datePublished;
  final String postUrl;
  final String profImage;
  final DateTime startDate;
  final DateTime endDate;
  final String location;

  const Event(
      {required this.title,
      required this.description,
      required this.uid,
      required this.username,
      required this.attendees,
      required this.eventId,
      required this.datePublished,
      required this.postUrl,
      required this.profImage,
      required this.startDate,
      required this.endDate,
      required this.location});

  static Event fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Event(
        title: snapshot["title"],
        description: snapshot["description"],
        uid: snapshot["uid"],
        attendees: snapshot["attendees"],
        eventId: snapshot["eventId"],
        datePublished: snapshot["datePublished"],
        username: snapshot["username"],
        postUrl: snapshot['postUrl'],
        profImage: snapshot['profImage'],
        startDate: snapshot['startDate'],
        endDate: snapshot['endDate'],
        location: snapshot['location']);
  }

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "uid": uid,
        "attendees": attendees,
        "username": username,
        "eventId": eventId,
        "datePublished": datePublished,
        'postUrl': postUrl,
        'profImage': profImage,
        'startDate': startDate,
        'endDate': endDate,
        'location': location,
      };
}
