import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/core/common/error_text.dart';
import 'package:reddit_app/core/common/loading.dart';
import 'package:reddit_app/features/auth/controller/auth_controller.dart';
import 'package:reddit_app/features/community/controller/community_controller.dart';

class AddModsScreen extends ConsumerStatefulWidget {
  final String name;
  const AddModsScreen({super.key, required this.name});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddModsScreenState();
}

class _AddModsScreenState extends ConsumerState<AddModsScreen> {
  Set<String> mods = {};
  int ctr = 0;

  void addUid(String uid) {
    setState((){
      mods.add(uid);
    });
  }

  void removeUid(String uid) {
    setState((){
      mods.remove(uid);
    });
  }

  void saveMods() {
    ref.read(communityControllerProvider.notifier).addMods(widget.name, mods.toList(), context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
            saveMods();
          }, icon: const Icon(Icons.done))
        ]
      ),
      body: ref.watch(getCommunityByNameProvider(widget.name)).when(data: (community) {
        return ListView.builder(itemBuilder: (BuildContext context, int index) {
          final memberUID = community.members[index];
         return  ref.watch(getUserDataProvider(memberUID)).when(data: (user) {
          if(community.mods.contains(memberUID) && ctr == 0) {
            mods.add(memberUID);
          }
          ctr++;
            return CheckboxListTile(value: mods.contains(user.uid), onChanged: (value){
              if (value!) {
                print(value);
                addUid(user.uid);
              } else {
                removeUid(user.uid);
              }

            }, title: Text(user.name));
          }, error: (error, stackTrace) {
            return ErrorText(error: error.toString());
          }, loading: () {
            return const Loading();
          },);
      
        }, itemCount: community.members.length); 
      }, error: (error, stackTrace) {
        return ErrorText(error: error.toString());
      }, loading: () {
        return const Loading();
      },)
    );
  }
}