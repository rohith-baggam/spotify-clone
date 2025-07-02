// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_user_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentUserNotifierHash() =>
    r'002b81f154e99725514361878fb229b209e96ce9';

/// This class manages the in-memory state of the currently logged-in user
/// It is a global, reactive, app-wide provider using Riverpod
///
/// `@Riverpod` is a Riverpod annotation that tells Riverpod to generate
/// boilerplate code to register and use this Notifier as a provider.
///
/// `keepAlive: true` ensures that the state stays alive throughout the app's lifecycle,
/// even if no widget is currently listening to it (useful for user session)
///
/// Copied from [CurrentUserNotifier].
@ProviderFor(CurrentUserNotifier)
final currentUserNotifierProvider =
    NotifierProvider<CurrentUserNotifier, UserModel?>.internal(
      CurrentUserNotifier.new,
      name: r'currentUserNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$currentUserNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CurrentUserNotifier = Notifier<UserModel?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
