import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/core/common/error_text.dart';
import 'package:reddit_app/core/common/loading.dart';
import 'package:reddit_app/core/common/post_card.dart';
import 'package:reddit_app/features/auth/controller/auth_controller.dart';
import 'package:reddit_app/features/community/controller/community_controller.dart';
import 'package:reddit_app/features/post/controller/post_controller.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;

    if (!isGuest) {
      return ref.watch(userCommunitiesProvider).when(
        data: (communities) {
          return ref.watch(userPostsProvider(communities)).when(data: (data) {
            return ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  final post = data[index];
                  return PostCard(post: post);
                },
                itemCount: data.length);
          }, error: (error, stackTrace) {
            return ErrorText(error: error.toString());
          }, loading: () {
            return const Loading();
          });
        },
        error: (error, stackTrace) {
          return ErrorText(error: error.toString());
        },
        loading: () {
          return const Loading();
        },
      );
    }
    return ref.watch(userCommunitiesProvider).when(
      data: (communities) {
        return ref.watch(fetchGuestPostsProvider).when(data: (data) {
          return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                final post = data[index];
                return PostCard(post: post);
              },
              itemCount: data.length);
        }, error: (error, stackTrace) {
          return ErrorText(error: error.toString());
        }, loading: () {
          return const Loading();
        });
      },
      error: (error, stackTrace) {
        return ErrorText(error: error.toString());
      },
      loading: () {
        return const Loading();
      },
    );
  }
}
