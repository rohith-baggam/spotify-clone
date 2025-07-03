import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/providers/current_user_notifier.dart';
import 'package:frontend/core/theme/theme.dart';
import 'package:frontend/features/auth/view/pages/signup_page.dart';
import 'package:frontend/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:frontend/features/home/view/pages/upload_song_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  await container.read(authViewModelProvider.notifier).initSharedPerferences();
  try {
    final userModel = await container
        .read(authViewModelProvider.notifier)
        .getData();
    debugPrint('userModel ${userModel.toString()}');
  } catch (e) {
    debugPrint('main catch ${e.toString()}');
  }

  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserNotifierProvider);
    print(currentUser);
    final isUserLoggedIn = currentUser != null;
    print('isUserLoggedIn ');
    print(isUserLoggedIn);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkThemeModel,
      title: 'Spotify Clone',
      home: isUserLoggedIn ? UploadSongPage() : SignUpPage(),
      // home: SignUpPage(),
    );
  }
}
