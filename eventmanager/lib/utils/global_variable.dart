import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eventmanager/pages/add_post_screen.dart';
import 'package:eventmanager/pages/feed_screen.dart';
import 'package:eventmanager/pages/profile_screen.dart';
import 'package:eventmanager/pages/search_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const Text('notifications'),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
