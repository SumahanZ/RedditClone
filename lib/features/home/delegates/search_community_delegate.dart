import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/core/common/error_text.dart';
import 'package:reddit_app/core/common/loading.dart';
import 'package:reddit_app/features/community/controller/community_controller.dart';
import 'package:routemaster/routemaster.dart';

class SearchCommunityDelegate extends SearchDelegate {
  final WidgetRef ref;

  SearchCommunityDelegate(this.ref);
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            //searchdelegate is stateless no need setState
            query = "";
          },
          icon: const Icon(Icons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    //no leading
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ref.watch(searchCommunityProvider(query)).when(
      data: (communities) {
        return ListView.builder(
          itemCount: communities.length,
          itemBuilder: (context, index) {
            final community = communities[index];
            return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(community.avatar),
                ),
                title: Text("r/${community.name}"),
                onTap: () {
                  navigateToCommunity(context, community.name);
                });
          },
        );
      },
      error: (error, stackTrace) {
        return ErrorText(error: error.toString());
      },
      loading: () {
        return const Loading();
      },
    );
  }

  void navigateToCommunity(BuildContext context, String communityName) {
    Routemaster.of(context).push("/r/$communityName");
  }
}
