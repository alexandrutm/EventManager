import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eventmanager/pages/add_post_page.dart';
import 'package:eventmanager/pages/home_page.dart';
import 'package:eventmanager/pages/profile_page.dart';
import 'package:eventmanager/pages/search_page.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const HomePage(),
  const SearchScreen(),
  const AddPostScreen(),
  const Text('notifications'),
  ProfilePage(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
