import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/features/auth/controller/auth_controller.dart';
import 'package:reddit_app/router.dart';
import 'package:reddit_app/theme/palette.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:routemaster/routemaster.dart';
import 'core/common/error_text.dart';
import 'core/common/loading.dart';
import 'firebase_options.dart';
import 'models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //ProviderScope is a storehouse which keeps track of all the providers that is available
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  UserModel? userModel;

  void getData(WidgetRef ref, User authChange) async {
    userModel = await ref
        .watch(authControllerProvider.notifier)
        .getUserData(authChange.uid)
        .first;
    ref.read(userProvider.notifier).update((state) => userModel);
  }

  @override
  Widget build(BuildContext context) {
    final authChanges = ref.watch(authStateChangeProvider);
    return authChanges.when(
      data: (authChange) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Reddit Tutorial',
          theme:
              Pallete.darkModeAppTheme, //theme doesnt work without a scaffold
          routerDelegate: RoutemasterDelegate(
            routesBuilder: (context) {
              if (authChange != null) {
                getData(ref, authChange);
                if (userModel != null) {
                  return loggedInRoute;
                }
              }
              return loggedOutRoute;
          }),
          routeInformationParser: const RoutemasterParser(),
        );
      },
      error: (error, stackTrace) => ErrorText(error: error.toString()),
      loading: () => const Loading(),
    );
  }
}
