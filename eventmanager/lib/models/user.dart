import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String photoUrl;
  final String mFirstName;
  final String mLastName;
  final String bio;
  final List followers;
  final List following;
  final List mFullName;

  const User(
      {required this.mFirstName,
      required this.mLastName,
      required this.uid,
      required this.email,
      this.photoUrl = 'https://i.stack.imgur.com/34AD2.jpg',
      this.bio = "About you",
      required this.followers,
      required this.following,
      required this.mFullName});

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      mFirstName: snapshot["firstname"],
      mLastName: snapshot["lastname"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      photoUrl: snapshot["photoUrl"],
      bio: snapshot["bio"],
      followers: snapshot["followers"],
      following: snapshot["following"],
      mFullName: snapshot["fullname"],
    );
  }

  Map<String, dynamic> toJson() => {
        "firstname": mFirstName,
        "lastname": mLastName,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "bio": bio,
        "followers": followers,
        "following": following,
        "fullname": mFullName,
      };
}
