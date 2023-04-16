import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/core/common/error_text.dart';
import 'package:reddit_app/core/common/loading.dart';
import 'package:reddit_app/core/common/post_card.dart';
import 'package:reddit_app/features/auth/controller/auth_controller.dart';
import 'package:reddit_app/features/post/controller/post_controller.dart';
import 'package:reddit_app/features/post/widgets/comment_card.dart';
import 'package:reddit_app/models/post_model.dart';

class CommentsScreen extends ConsumerStatefulWidget {
  //passing string not the whole model because more convenient for the web part
  final String postId;
  const CommentsScreen({super.key, required this.postId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends ConsumerState<CommentsScreen> {
  final commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  void addComment(Post post) {
    ref
        .read(postControllerProvider.notifier)
        .addComment(commentController.text.trim(), context, post);
    setState(() {
      commentController.text = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;

    return Scaffold(
        appBar: AppBar(),
        body: ref.watch(getPostByIdProvider(widget.postId)).when(
          data: (data) {
            return Column(
              children: [
                PostCard(post: data),
                if (!isGuest)
                  TextField(
                      onSubmitted: (value) {
                        addComment(data);
                      },
                      controller: commentController,
                      decoration: const InputDecoration(
                          hintText: "What are your thoughts?",
                          filled: true,
                          border: InputBorder.none)),
                          
                ref.watch(fetchPostCommentsProvider(widget.postId)).when(
                  data: (data) {
                    return Expanded(
                      child: ListView.builder(
                          itemBuilder: (context, index) {
                            final comment = data[index];
                            return CommentCard(
                              comment: comment,
                            );
                          },
                          itemCount: data.length),
                    );
                  },
                  error: (error, stackTrace) {
                    return ErrorText(error: error.toString());
                  },
                  loading: () {
                    return const Loading();
                  },
                )
              ],
            );
          },
          error: (error, stackTrace) {
            return ErrorText(error: error.toString());
          },
          loading: () {
            return const Loading();
          },
        ));
  }
}
