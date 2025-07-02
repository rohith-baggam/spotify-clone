import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/theme.dart';
import 'package:frontend/features/auth/view/pages/signup_page.dart';
import 'package:frontend/features/auth/viewmodel/auth_viewmodel.dart';

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
    // final currentUser = ref.watch(currentUserNotifierProvider);

    // final isUserLoggedIn = currentUser != null;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkThemeModel,
      title: 'Spotify Clone',
      home: const SignUpPage(),
    );
  }
}
