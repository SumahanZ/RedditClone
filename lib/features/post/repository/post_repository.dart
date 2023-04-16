import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_app/core/constants/firebase_constants.dart';
import 'package:reddit_app/core/failure.dart';
import 'package:reddit_app/core/providers/firebase_providers.dart';
import 'package:reddit_app/core/type_defs.dart';
import 'package:reddit_app/models/community_model.dart';
import 'package:reddit_app/models/post_model.dart';

import '../../../models/comment_model.dart';

final postRepositoryProvider = Provider((ref) {
  return PostRepository(firestore: ref.watch(firestoreProvider));
});

class PostRepository {
  final FirebaseFirestore _firestore;
  PostRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _posts =>
      _firestore.collection(FirebaseConstants.postsCollection);
  CollectionReference get _comments =>
      _firestore.collection(FirebaseConstants.commentsCollection);
  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  FutureVoid addPost(Post post) async {
    try {
      return right(_posts.doc(post.id).set(post.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //If you also try to order your results, another index is required
  Stream<List<Post>> fetchUserPosts(List<Community> communities) {
    return _posts
        .where("communityName",
            whereIn: communities.map((e) => e.name).toList())
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((event) => event.docs
            .map((ed) => Post.fromMap(ed.data() as Map<String, dynamic>))
            .toList());
  }

  FutureVoid deletePost(Post post) async {
    try {
      return right(_posts.doc(post.id).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //we dont wanna handle the error because in case we get error we dont wanna show anything because its not how it works
  //Feature logic so put in repository
  void upvote(Post post, String userId) async {
    //Remove downvote if in downvote state and turn into neutral state
    if (post.downvotes.contains(userId)) {
      _posts.doc(post.id).update({
        'downvotes': FieldValue.arrayRemove([userId]),
      });
    }

    //Remove upvote if already in upvote state
    if (post.upvotes.contains(userId)) {
      _posts.doc(post.id).update({
        'upvotes': FieldValue.arrayRemove([userId]),
      });
      //Add upvote and turn into upvote state from neutral state
    } else {
      _posts.doc(post.id).update({
        'upvotes': FieldValue.arrayUnion([userId]),
      });
    }
  }

  void downvote(Post post, String userId) {
    //Remove upvote if in upvote state and turn into neutral state
    if (post.upvotes.contains(userId)) {
      _posts.doc(post.id).update({
        'upvotes': FieldValue.arrayRemove([userId]),
      });
    }
    //Remove downvote if in downvote state and turn into neutral state
    if (post.downvotes.contains(userId)) {
      _posts.doc(post.id).update({
        'downvotes': FieldValue.arrayRemove([userId]),
      });
      //
    } else {
      _posts.doc(post.id).update({
        'downvotes': FieldValue.arrayUnion([userId]),
      });
    }
  }

  Stream<Post> getPostById(String postId) {
    return _posts
        .doc(postId)
        .snapshots()
        .map((event) => Post.fromMap(event.data() as Map<String, dynamic>));
  }

  FutureVoid addComment(Comment comment) async {
    try {
      await _comments.doc(comment.id).set(comment.toMap());
      return right(_posts
          .doc(comment.postId)
          .update({"commentCount": FieldValue.increment(1)}));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Comment>> fetchPostComments(String postId) {
    return _comments
        .where("postId", isEqualTo: postId)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((event) => event.docs
            .map((ed) => Comment.fromMap(ed.data() as Map<String, dynamic>))
            .toList());
  }

  FutureVoid awardPost(Post post, String award, String senderId) async {
    try {
      _posts.doc(post.id).update({
        "awards": FieldValue.arrayUnion([award])
      });

      _users.doc(senderId).update({
        "awards": FieldValue.arrayRemove([award])
      });
      return right(_users.doc(post.uid).update({
        "awards": FieldValue.arrayUnion([award])
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Post>> fetchGuestPosts() {
    return _posts
        .orderBy("createdAt", descending: true)
        .limit(10)
        .snapshots()
        .map((event) => event.docs
            .map((ed) => Post.fromMap(ed.data() as Map<String, dynamic>))
            .toList());
  }
}
