import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/core/common/error_text.dart';
import 'package:reddit_app/core/common/loading.dart';
import 'package:reddit_app/features/community/controller/community_controller.dart';
import 'package:routemaster/routemaster.dart';

class CommunityListDrawer extends ConsumerWidget {
  const CommunityListDrawer({super.key});

  void navigateToCreateCommunity(BuildContext context) {
    Routemaster.of(context).push("/create-community");
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
        child: SafeArea(
            child: Column(children: [
      ListTile(
          title: const Text("Create a community"),
          leading: const Icon(Icons.add),
          onTap: () {
            navigateToCreateCommunity(context);
          }),
      ref.watch(userCommunitiesProvider).when(
        data: (communities) {
          return Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                final community = communities[index];
                return ListTile(
                    leading: CircleAvatar(
                        backgroundImage: NetworkImage(community.avatar)),
                    title: Text("r/${community.name}"),
                    onTap: () {});
              },
              itemCount: communities.length,
            ),
          );
        },
        error: (error, stackTrace) {
          return ErrorText(error: error.toString());
        },
        loading: () {
          return const Loading();
        },
      )
    ])));
  }
}
