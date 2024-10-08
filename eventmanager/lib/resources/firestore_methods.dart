import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventmanager/models/event.dart';
import 'package:eventmanager/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadEvent(
      String title,
      String description,
      Uint8List file,
      String uid,
      String username,
      String profImage,
      DateTime startDate,
      DateTime endDate,
      String location) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('events', file, true);
      String eventId = const Uuid().v1(); // creates unique id based on time
      Event post = Event(
        title: title,
        description: description,
        uid: uid,
        username: username,
        attendees: [],
        eventId: eventId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        startDate: startDate,
        endDate: endDate,
        location: location,
      );
      _firestore.collection('events').doc(eventId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> attendToEvent(
      String eventId, String uid, List attendees) async {
    String res = "Some error occurred";
    try {
      if (attendees.contains(uid)) {
        // if the attendees list contains the user uid, we need to remove it
        _firestore.collection('events').doc(eventId).update({
          'attendees': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the attendees array
        _firestore.collection('events').doc(eventId).update({
          'attendees': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Post comment
  Future<String> postComment(String eventId, String text, String uid,
      String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
        _firestore
            .collection('events')
            .doc(eventId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Delete Post
  Future<String> deletePost(String eventId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('events').doc(eventId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      // print(e.toString());
    }
  }
}
