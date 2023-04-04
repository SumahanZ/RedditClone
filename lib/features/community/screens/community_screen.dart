import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/core/common/error_text.dart';
import 'package:reddit_app/core/common/loading.dart';
import 'package:reddit_app/features/community/controller/community_controller.dart';

class CommunityScreen extends ConsumerWidget {
  final String name;
  const CommunityScreen({super.key, required this.name});

  //dynamic route

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ref.watch(getCommunityByNameProvider(name)).when(data: (community) {
        // return NestedScrollView(headerSliverBuilder: (context,innerBoxIsScrolled) {}, body: const Text("Displaying post of community"),);
      }, error: (error, stackTrace) {
        return ErrorText(error: error.toString(),);
      }, loading: () {
        return const Loading();
      },)
    );
  }
}