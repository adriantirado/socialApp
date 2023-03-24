import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_pet/screen/add_post.dart';
import 'package:social_pet/screen/feed_screen.dart';
import 'package:social_pet/screen/home_Screen.dart';
import 'package:social_pet/screen/profile_screen.dart';
import 'package:social_pet/screen/search_screen.dart';

List<Widget> HomeScreemItems = [
 const FeedScreen(),
 const SearchScreen(),
 const AddPostScreen(),
  Text("Favoritos"),
 ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
];
