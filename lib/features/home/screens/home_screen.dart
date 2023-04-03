import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/features/auth/controller/auth_controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //pretty sure user cant be null when we enter
    final user = ref.watch(userProvider)!;
    return Scaffold(
      body: Center(child: Text(user.name))
    );
  }
}