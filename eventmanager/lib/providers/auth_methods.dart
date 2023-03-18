import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eventmanager/models/user.dart' as model;
import 'package:eventmanager/resources/storage_methods.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';

class AuthMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // get user details
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(documentSnapshot);
  }

  // Signing Up User
  Future<String> registerUser({
    required String email,
    required String password,
    required String firstname,
    required String lastname,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // registering user in auth with email and password
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePictures', file, false);

        model.User user = model.User(
          mFirstName: firstname,
          mLastName: lastname,
          uid: cred.user!.uid,
          photoUrl: photoUrl,
          email: email,
          bio: bio,
          followers: [],
          following: [],
        );

        // adding user in our database
        await _firestore
            .collection("users")
            .doc(cred.user!.uid)
            .set(user.toJson());

        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  // logging in user
  static Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error Occurred";

    // logging in user with email and password
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      res = "success";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        res = "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        res = "Wrong password provided for that user.";
      }
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<String> signInWithGoogle() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final UserCredential firebaseUser;

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        firebaseUser = await auth.signInWithPopup(authProvider);

        List<String> spiltName = firebaseUser.user!.displayName!.split(" ");

        model.User user = model.User(
          mFirstName: spiltName.first,
          mLastName: spiltName.last,
          uid: firebaseUser.user!.uid,
          photoUrl: firebaseUser.user!.photoURL.toString(),
          email: firebaseUser.user!.email.toString(),
          bio: "",
          followers: [],
          following: [],
        );

        // adding user in our database
        await _firestore
            .collection("users")
            .doc(firebaseUser.user!.uid)
            .set(user.toJson());
        return "success";
      } catch (e) {
        print(e);
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          firebaseUser = await auth.signInWithCredential(credential);

          List<String> spiltName = firebaseUser.user!.displayName!.split(" ");

          model.User user = model.User(
            mFirstName: spiltName.first,
            mLastName: spiltName.last,
            uid: firebaseUser.user!.uid,
            photoUrl: firebaseUser.user!.photoURL.toString(),
            email: firebaseUser.user!.email.toString(),
            bio: "",
            followers: [],
            following: [],
          );

          // adding user in our database
          await _firestore
              .collection("users")
              .doc(firebaseUser.user!.uid)
              .set(user.toJson());

          return "success";
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            // ...
          } else if (e.code == 'invalid-credential') {
            // ...
          }
        } catch (e) {
          // ...
        }
      }
    }
    return "userdata";
  }
}
