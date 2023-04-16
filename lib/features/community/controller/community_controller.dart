import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_app/core/constants/constants.dart';
import 'package:reddit_app/core/failure.dart';
import 'package:reddit_app/core/providers/storage_repository_provider.dart';
import 'package:reddit_app/core/utils.dart';
import 'package:reddit_app/features/auth/controller/auth_controller.dart';
import 'package:reddit_app/features/community/repository/community_repository.dart';
import 'package:reddit_app/models/community_model.dart';
import 'package:reddit_app/models/post_model.dart';
import 'package:routemaster/routemaster.dart';

final communityControllerProvider =
    StateNotifierProvider<CommunityController, bool>((ref) {
  return CommunityController(
      storageRepository: ref.watch(storageRepositoryProvider),
      communityRepository: ref.watch(communityRepositoryProvider),
      ref: ref);
});

final userCommunitiesProvider = StreamProvider((ref) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.getUserCommunities();
});

final getCommunityByNameProvider = StreamProvider.family((ref, String name) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.getCommunityByName(name);
});

final searchCommunityProvider = StreamProvider.family((ref, String query) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.searchCommunity(query);
});

final getCommunityPostsProvider = StreamProvider.family((ref, String name) {
  return ref.read(communityControllerProvider.notifier).getCommunityPosts(name);
});

class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  CommunityController(
      {required CommunityRepository communityRepository,
      required Ref ref,
      required StorageRepository storageRepository})
      : _communityRepository = communityRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void createCommunity(String name, BuildContext context) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? "";
    Community community = Community(
        id: name,
        name: name,
        banner: Constants.bannerDefault,
        avatar: Constants.avatarDefault,
        members: [uid],
        mods: [uid]);
    final createdResponse =
        await _communityRepository.createCommunity(community);
    state = false;
    createdResponse.fold((error) => showSnackBar(context, error.message), (r) {
      showSnackBar(context, "Community  created successfully!");
      Routemaster.of(context).pop();
    });
  }

  void joinCommunity(Community community, BuildContext context) async {
    final uid = _ref.read(userProvider)!.uid;

    Either<Failure, void> res;
    if (community.members.contains(uid)) {
      res = await _communityRepository.leaveCommunity(community.name, uid);
    } else {
      res = await _communityRepository.joinCommunity(community.name, uid);
    }
    res.fold((l) => showSnackBar(context, l.message), (r) {
      if (community.members.contains(uid)) {
        showSnackBar(context, "Community left successfully");
      } else {
        showSnackBar(context, "Community joined successfully");
      }
    });
  }

  Stream<List<Community>> getUserCommunities() {
    final uid = _ref.read(userProvider)!.uid;
    return _communityRepository.getUserCommunities(uid);
  }

  Stream<Community> getCommunityByName(String name) {
    return _communityRepository.getCommunityByName(name);
  }

  void editCommunity(
      {required File? profileFile,
      required File? bannerFile,
      required BuildContext context,
      //communityModel we have right now
      required Community community}) async {
    state = true;
    if (profileFile != null) {
      //communities/profile/memes (image saved in the path in the left)
      final res = await _storageRepository.storeFile(
          path: "communities/profile", id: community.name, file: profileFile);
      res.fold((l) => showSnackBar(context, l.message),
          (r) => community = community.copyWith(avatar: r));
    }

    if (bannerFile != null) {
      //communities/banner/memes (image saved in the path in the left)
      final res = await _storageRepository.storeFile(
          path: "communities/banner", id: community.name, file: bannerFile);
      res.fold((l) => showSnackBar(context, l.message),
          (r) => community = community.copyWith(banner: r));
    }
    final res = await _communityRepository.editCommunity(community);
    state = false;
    res.fold((l) => showSnackBar(context, l.message),
        (r) => Routemaster.of(context).pop());
  }

  Stream<List<Community>> searchCommunity(String query) {
    return _communityRepository.searchCommunity(query);
  }

  void addMods(
      String communityName, List<String> mods, BuildContext context) async {
    final res = await _communityRepository.addMods(communityName, mods);
    res.fold((l) => showSnackBar(context, l.message),
        (r) => Routemaster.of(context).pop());
  }

  Stream<List<Post>> getCommunityPosts(String name) {
    return _communityRepository.getCommunityPosts(name);
  }

}
