// loggedOut Route
// loggedIn Route

import 'package:flutter/material.dart';
import 'package:reddit_app/features/community/screens/edit_community_screen.dart';
import 'package:reddit_app/features/post/screens/add_post_type_screen.dart';
import 'package:reddit_app/features/post/screens/comments_screen.dart';
import 'package:reddit_app/features/user_profile/screens/user_profile_screen.dart';
import 'package:routemaster/routemaster.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/community/screens/add_mods_screen.dart';
import 'features/community/screens/community_screen.dart';
import 'features/community/screens/create_community_screen.dart';
import 'features/community/screens/mod_tools_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'features/user_profile/screens/edit_profile_screen.dart';

final loggedOutRoute = RouteMap(routes: {
  "/": (_) => const MaterialPage(child: LoginScreen()),
});

final loggedInRoute = RouteMap(routes: {
  "/": (_) => const MaterialPage(child: HomeScreen()),
  "/create-community": (_) =>
      const MaterialPage(child: CreateCommunityScreen()),
  "/mod-tools/:name": (route) =>
      MaterialPage(child: ModToolsScreen(name: route.pathParameters["name"]!)),
  "/r/:name": (route) =>
      MaterialPage(child: CommunityScreen(name: route.pathParameters["name"]!)),
  "/edit-community/:name": (route) => MaterialPage(
      child: EditCommunityScreen(name: route.pathParameters["name"]!)),
  "/add-mods/:name": (route) => MaterialPage(
      child: AddModsScreen(name: route.pathParameters["name"]!)),
  "/u/:uid": (route) => MaterialPage(
      child: UserProfileScreen(uid: route.pathParameters["uid"]!)),
  "/edit-profile/:uid": (route) => MaterialPage(
      child: EditProfileScreen(uid: route.pathParameters["uid"]!)),
  "/add-post/:type": (route) => MaterialPage(
      child: AddPostTypeScreen(type: route.pathParameters["type"]!)),
  "/post/:postId/comments": (route) => MaterialPage(
      child: CommentsScreen(postId: route.pathParameters["postId"]!)),
});
