// loggedOut Route
// loggedIn Route

import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/community/screens/community_screen.dart';
import 'features/community/screens/create_community_screen.dart';
import 'features/home/screens/home_screen.dart';

final loggedOutRoute = RouteMap(routes: {
  "/": (_) => const MaterialPage(child: LoginScreen()),
});

final loggedInRoute = RouteMap(routes: {
  "/": (_) => const MaterialPage(child: HomeScreen()),
  "/create-community": (_) => const MaterialPage(child: CreateCommunityScreen()),
  "r/:name": (route) => MaterialPage(child: CommunityScreen(
    name: route.pathParameters["name"]!
  ))
}); 
