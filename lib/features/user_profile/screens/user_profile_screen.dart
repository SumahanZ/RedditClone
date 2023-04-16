import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/core/common/error_text.dart';
import 'package:reddit_app/core/common/loading.dart';
import 'package:reddit_app/core/common/post_card.dart';
import 'package:reddit_app/features/auth/controller/auth_controller.dart';
import 'package:reddit_app/features/user_profile/controllers/user_profile_controller.dart';
import 'package:routemaster/routemaster.dart';

class UserProfileScreen extends ConsumerWidget {
  final String uid;
  const UserProfileScreen({super.key, required this.uid});

  void navigateToEditUser(BuildContext context) {
    Routemaster.of(context).push("/edit-profile/$uid");
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return Scaffold(
        body: ref.watch(getUserDataProvider(uid)).when(
      data: (user) {
        return NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 250,
                floating: true,
                snap: true,
                flexibleSpace: Stack(children: [
                  Positioned.fill(
                      child: Image.network(user.banner, fit: BoxFit.cover)),
                  Container(
                      padding: const EdgeInsets.all(20).copyWith(bottom: 70),
                      child: CircleAvatar(
                          backgroundImage: NetworkImage(user.profilePic),
                          radius: 45)),
                  Container(
                    alignment: Alignment.bottomLeft,
                    padding: const EdgeInsets.all(20),
                    child: OutlinedButton(
                        onPressed: () {
                          navigateToEditUser(context);
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25)),
                        child: const Text("Edit Profile")),
                  )
                ]),
              ),
              SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                      delegate: SliverChildListDelegate([
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("u/${user.name}",
                              style: const TextStyle(
                                  fontSize: 19, fontWeight: FontWeight.bold)),
                        ]),
                    Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: Text("${user.karma} karma")),
                    const SizedBox(height: 10),
                    const Divider(thickness: 2)
                  ])))
            ];
          },
          body: ref.watch(getUserPostsProvider(uid)).when(
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
    ));
  }
}
