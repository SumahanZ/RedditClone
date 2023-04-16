import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/core/constants/constants.dart';
import 'package:reddit_app/features/auth/controller/auth_controller.dart';
import 'package:reddit_app/features/home/delegates/search_community_delegate.dart';
import 'package:reddit_app/features/home/drawers/community_list_drawer.dart';
import 'package:reddit_app/features/home/drawers/profile_drawer.dart';
import 'package:reddit_app/theme/palette.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _pageIndex = 0;
  void displayCommunityDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  void onPageChanged(int pageIndex) {
    setState(() {
      _pageIndex = pageIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    //pretty sure user cant be null when we enter
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    final currentTheme = ref.watch(themeNotifierProvider);
    return Scaffold(
      appBar: AppBar(
          title: const Text("Home"),
          centerTitle: false,
          leading: Builder(
              builder: (context) => IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => displayCommunityDrawer(context),
                  )),
          actions: [
            IconButton(
                onPressed: () {
                  showSearch(
                      context: context, delegate: SearchCommunityDelegate(ref));
                },
                icon: const Icon(Icons.search)),
            Builder(
              builder: (context) => IconButton(
                icon: CircleAvatar(
                    backgroundImage: NetworkImage(user.profilePic)),
                onPressed: () => displayEndDrawer(context),
              ),
            )
          ]),
      body: Constants.tabWidgets[_pageIndex],
      drawer: isGuest ? null : const CommunityListDrawer(),
      endDrawer: const ProfileDrawer(),
      bottomNavigationBar: isGuest ? null : CupertinoTabBar(
        onTap: onPageChanged,
        activeColor: currentTheme.iconTheme.color,
        backgroundColor: currentTheme.scaffoldBackgroundColor,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: ""),
        ],
        currentIndex: _pageIndex,
      ),
    );
  }
}
