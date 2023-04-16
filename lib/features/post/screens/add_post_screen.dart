import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/theme/palette.dart';
import 'package:routemaster/routemaster.dart';

class AddPostScreen extends ConsumerWidget {
  const AddPostScreen({super.key});

  void navigateToType(String type, BuildContext context) {
    Routemaster.of(context).push("/add-post/$type");
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const double cardHeightWidth = 120;
    const double iconSize = 60;
    final currentTheme = ref.watch(themeNotifierProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: (){
            navigateToType("image", context);
          },
          child: SizedBox(
            height: cardHeightWidth,
            width: cardHeightWidth,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              color: currentTheme.colorScheme.background,
              elevation: 16,
              child: const Center(
                child: Icon(Icons.image_outlined, size: iconSize)
              ),
            ),
          ),
        ),

        GestureDetector(
          onTap: (){
            navigateToType("text", context);
          },
          child: SizedBox(
            height: cardHeightWidth,
            width: cardHeightWidth,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              color: currentTheme.colorScheme.background,
              elevation: 16,
              child: const Center(
                child: Icon(Icons.font_download_outlined, size: iconSize)
              ),
            ),
          ),
        ),

        GestureDetector(
          onTap: (){
            navigateToType("link", context);
          },
          child: SizedBox(
            height: cardHeightWidth,
            width: cardHeightWidth,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              color: currentTheme.colorScheme.background,
              elevation: 16,
              child: const Center(
                child: Icon(Icons.link_outlined, size: iconSize)
              ),
            ),
          ),
        ),
      ]
    );
  }
}