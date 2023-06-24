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

  static Event fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    return Event(
      title: data["title"],
      description: data["description"],
      uid: data["uid"],
      attendees: List<String>.from(data["attendees"]),
      eventId: data["eventId"],
      datePublished: (data["datePublished"] as Timestamp).toDate(),
      username: data["username"],
      postUrl: data['postUrl'],
      profImage: data['profImage'],
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      location: data['location'],
    );
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
