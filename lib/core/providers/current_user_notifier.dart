// Import the UserModel which represents the authenticated user
import 'package:frontend/features/auth/model/user_model.dart';

// Import Riverpod's annotations for code generation
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Required for Riverpod code generation (will generate current_user_notifier.g.dart)
part 'current_user_notifier.g.dart';

/// This class manages the in-memory state of the currently logged-in user
/// It is a global, reactive, app-wide provider using Riverpod
///
/// `@Riverpod` is a Riverpod annotation that tells Riverpod to generate
/// boilerplate code to register and use this Notifier as a provider.
///
/// `keepAlive: true` ensures that the state stays alive throughout the app's lifecycle,
/// even if no widget is currently listening to it (useful for user session)
@Riverpod(keepAlive: true)
class CurrentUserNotifier extends _$CurrentUserNotifier {
  /// This is the method that defines the initial state of the provider.
  /// In this case, we start with `null` meaning no user is logged in initially.
  @override
  UserModel? build() {
    return null; // Initial state: no user
  }

  /// This method allows setting the logged-in user into memory.
  /// It will trigger reactive rebuilds in any widgets or services that are
  /// watching this provider.
  ///
  /// Typically called after a successful login or session restoration.
  void addUser(UserModel user) {
    state = user;
  }
}
