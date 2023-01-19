import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventmanager/providers/auth_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthService {
  //Google sign in

  static Future<Map<String, dynamic>> signInWithGoogle(
      {required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final UserCredential firebaseUser;
    final Map<String, dynamic> userdata = {};

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        firebaseUser = await auth.signInWithPopup(authProvider);
        Map<String, dynamic> userdata = {
          'useremail': firebaseUser.user!.email,
          'displayname': firebaseUser.user!.displayName,
          'photoUrl': firebaseUser.user!.photoURL,
          'userid': firebaseUser.user!.uid,
        };
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

          Map<String, dynamic> userdata = {
            'useremail': firebaseUser.user!.email,
            'displayname': firebaseUser.user!.displayName,
            'photoUrl': firebaseUser.user!.photoURL,
            'userid': firebaseUser.user!.uid,
          };
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

    return userdata;
  }
}
