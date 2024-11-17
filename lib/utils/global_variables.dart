import 'package:flutter/material.dart';
import 'package:insta_clone/Screens/Search_Screen.dart';
import 'package:insta_clone/Screens/add_post_screen.dart';
import 'package:insta_clone/Screens/feed_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const FeedScreen(),
  SearchScreen(),
  const AddPostScreen(),
  const Text('notifications'),
  const Text('profile'),

];