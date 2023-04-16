import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/core/common/error_text.dart';
import 'package:reddit_app/core/common/loading.dart';
import 'package:reddit_app/core/constants/constants.dart';
import 'package:reddit_app/features/auth/controller/auth_controller.dart';
import 'package:reddit_app/features/community/controller/community_controller.dart';
import 'package:reddit_app/features/post/controller/post_controller.dart';
import 'package:reddit_app/models/post_model.dart';
import 'package:reddit_app/theme/palette.dart';
import 'package:routemaster/routemaster.dart';

class PostCard extends ConsumerWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  void deletePost(WidgetRef ref, BuildContext context) {
    ref.read(postControllerProvider.notifier).deletePost(post, context);
  }

  void upvotePost(WidgetRef ref) {
    ref.read(postControllerProvider.notifier).upvote(post);
  }

  void downvotePost(WidgetRef ref) {
    ref.read(postControllerProvider.notifier).downvote(post);
  }

  void awardPost(WidgetRef ref, String award, BuildContext context) {
    ref.read(postControllerProvider.notifier).awardPost(post, award, context);
  }

  void navigateToUserProfile(BuildContext context) {
    Routemaster.of(context).push("/u/${post.uid}");
  }

  void navigateToCommunity(BuildContext context) {
    Routemaster.of(context).push("/u/${post.communityName}");
  }

  void navigateToComments(BuildContext context) {
    Routemaster.of(context).push("/post/${post.id}/comments");
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeImage = post.type == "image";
    final isTypeText = post.type == "text";
    final isTypeLink = post.type == "link";

    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;

    final currentTheme = ref.watch(themeNotifierProvider);
    return Column(children: [
      Container(
          decoration:
              BoxDecoration(color: currentTheme.drawerTheme.backgroundColor),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(children: [
            Expanded(
              child: Column(children: [
                Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                            .copyWith(right: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => navigateToCommunity(context),
                                  child: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          post.communityProfilePic),
                                      radius: 16),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("r/${post.communityName}",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                        GestureDetector(
                                          onTap: () =>
                                              navigateToUserProfile(context),
                                          child: Text("u/${post.username}",
                                              style: const TextStyle(
                                                fontSize: 12,
                                              )),
                                        )
                                      ],
                                    ))
                              ],
                            ),
                            if (post.id == user.uid)
                              IconButton(
                                  onPressed: () => deletePost(ref, context),
                                  icon: Icon(Icons.delete,
                                      color: Pallete.redColor))
                          ],
                        ),
                        //For multiple widgets needed to be rendered from an if statement
                        if (post.awards.isNotEmpty) ...[
                          const SizedBox(height: 5),
                          SizedBox(
                              height: 25,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    final award = post.awards[index];
                                    return Image.asset(Constants.awards[award]!,
                                        height: 23);
                                  },
                                  itemCount: post.awards.length)),
                        ],
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(post.title,
                              style: const TextStyle(
                                  fontSize: 19, fontWeight: FontWeight.bold)),
                        ),
                        // if (isTypeImage) ...[
                        // ]
                        // else ...[],
                        if (isTypeImage)
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.35,
                              width: double.infinity,
                              child:
                                  Image.network(post.link!, fit: BoxFit.cover)),
                        if (isTypeLink)
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18),
                              child: AnyLinkPreview(
                                  displayDirection:
                                      UIDirection.uiDirectionHorizontal,
                                  link: post.link!)),
                        if (isTypeText)
                          Container(
                            alignment: Alignment.bottomLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Text(post.description!,
                                style: const TextStyle(color: Colors.grey)),
                          )
                      ],
                    )),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: isGuest
                              ? () {}
                              : () {
                                  upvotePost(ref);
                                },
                          icon: Icon(Constants.up,
                              size: 30,
                              color: post.upvotes.contains(user.uid)
                                  ? Pallete.redColor
                                  : null)),
                      Text(
                          "${post.upvotes.length - post.downvotes.length == 0 ? 'Vote' : post.upvotes.length - post.downvotes.length}",
                          style: const TextStyle(fontSize: 17)),
                      IconButton(
                          onPressed: isGuest
                              ? () {}
                              : () {
                                  downvotePost(ref);
                                },
                          icon: Icon(Constants.down,
                              size: 30,
                              color: post.downvotes.contains(user.uid)
                                  ? Pallete.blueColor
                                  : null))
                    ]),
                Row(children: [
                  IconButton(
                      onPressed: () {
                        navigateToComments(context);
                      },
                      icon: Icon(Icons.comment,
                          size: 30,
                          color: post.upvotes.contains(user.uid)
                              ? Pallete.redColor
                              : null)),
                  Text(
                      "${post.commentCount == 0 ? 'Comment' : post.commentCount}",
                      style: const TextStyle(fontSize: 17)),
                ]),
                ref.watch(getCommunityByNameProvider(post.communityName)).when(
                  data: (data) {
                    if (data.mods.contains(user.uid)) {
                      return IconButton(
                          onPressed: () {
                            deletePost(ref, context);
                          },
                          icon: const Icon(Icons.admin_panel_settings));
                    } else {
                      return const SizedBox();
                    }
                  },
                  error: (error, stackTrace) {
                    return ErrorText(error: error.toString());
                  },
                  loading: () {
                    return const Loading();
                  },
                ),
                IconButton(
                    onPressed: isGuest
                        ? () {}
                        : () {
                            showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                    child: Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: GridView.builder(
                                            //shrink to the height of the child
                                            shrinkWrap: true,
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 4),
                                            itemBuilder: (context, index) {
                                              final award = user.awards[index];
                                              return GestureDetector(
                                                onTap: () => awardPost(
                                                    ref, award, context),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Image.asset(
                                                      Constants.awards[award]!),
                                                ),
                                              );
                                            },
                                            itemCount: user.awards.length))));
                          },
                    icon: const Icon(Icons.card_giftcard_outlined))
              ]),
            )
          ])),
      const SizedBox(height: 10),
    ]);
  }
}
