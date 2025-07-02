import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/providers/current_user_notifier.dart';

class HomePage extends ConsumerWidget {
  final String email;
  const HomePage({super.key, this.email = "Anonymous user"});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserNotifierProvider);
    print('homestart');
    print('currentUser $currentUser');

    String? name = currentUser?.name;
    print('name $name');
    print('Homeend');
    return Scaffold(body: Center(child: Text('Hello $email')));
  }
}
