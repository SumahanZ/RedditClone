import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/core/common/error_text.dart';
import 'package:reddit_app/core/common/loading.dart';
import 'package:reddit_app/core/common/post_card.dart';
import 'package:reddit_app/features/auth/controller/auth_controller.dart';
import 'package:reddit_app/features/community/controller/community_controller.dart';
import 'package:reddit_app/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

class CommunityScreen extends ConsumerWidget {
  final String name;
  const CommunityScreen({super.key, required this.name});

  //dynamic route

  void navigateToModTools(BuildContext context) {
    Routemaster.of(context).push("/mod-tools/$name");
  }

  void joinCommunity(BuildContext context, WidgetRef ref, Community community) {
    ref
        .read(communityControllerProvider.notifier)
        .joinCommunity(community, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    return Scaffold(
      body: ref.watch(getCommunityByNameProvider(name)).when(
        data: (community) {
          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 150,
                  floating: true,
                  snap: true,
                  flexibleSpace: Stack(children: [
                    Positioned.fill(
                        child:
                            Image.network(community.banner, fit: BoxFit.cover))
                  ]),
                ),
                SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                        delegate: SliverChildListDelegate([
                      Align(
                        alignment: Alignment.topLeft,
                        child: CircleAvatar(
                            backgroundImage: NetworkImage(
                              community.avatar,
                            ),
                            radius: 35),
                      ),
                      const SizedBox(height: 5),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("r/${community.name}",
                                style: const TextStyle(
                                    fontSize: 19, fontWeight: FontWeight.bold)),
                            if (isGuest)
                              community.mods.contains(user.uid)
                                  ? OutlinedButton(
                                      onPressed: () {
                                        navigateToModTools(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25.0)),
                                      child: const Text("Mod Tools"))
                                  : OutlinedButton(
                                      onPressed: () {
                                        joinCommunity(context, ref, community);
                                      },
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25.0)),
                                      child: Text(
                                          community.members.contains(user.uid)
                                              ? "Joined"
                                              : "Join"))
                          ]),
                      Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                          ),
                          child: Text("${community.members.length} members"))
                    ])))
              ];
            },
            body: ref.watch(getCommunityPostsProvider(name)).when(
              data: (data) {
                return ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      final post = data[index];
                      return PostCard(post: post);
                    },
                    itemCount: data.length);
              },
              error: (error, stackTrace) {
                return ErrorText(error: error.toString());
              },
              loading: () {
                return const Loading();
              },
            ),
          );
        },
        error: (error, stackTrace) {
          return ErrorText(
            error: error.toString(),
          );
        },
        loading: () {
          return const Loading();
        },
      ),
    );
  }
}
