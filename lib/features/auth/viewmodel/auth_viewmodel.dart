// Flutter foundation for debug logging
import 'package:flutter/foundation.dart';

// Functional programming tools, especially Either type
import 'package:fpdart/fpdart.dart';

// Provider for tracking the current user in memory
import 'package:frontend/core/providers/current_user_notifier.dart';

// Model for user data
import 'package:frontend/features/auth/model/user_model.dart';

// Handles storing token locally
import 'package:frontend/features/auth/repository/auth_local_repository.dart';

// Handles HTTP calls for login/signup
import 'package:frontend/features/auth/repository/auth_remote_repository.dart';

// Riverpod annotations for generating boilerplate
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Required for Riverpod code generation
part 'auth_viewmodel.g.dart';

/// Riverpod ViewModel for managing authentication state
/// Exposes functions like login, signup, and get user
@riverpod
class AuthViewModel extends _$AuthViewModel {
  // Remote API repository (signup/login/get user)
  late AuthRemoteRepository _authRemoteRepository;

  // Local token storage (SharedPreferences)
  late AuthLocalRepository _authLocalRepository;

  // In-memory current user provider
  late CurrentUserNotifier _currentUserNotifier;

  /// Initializes the ViewModel with required repositories and providers.
  /// Called when the provider is first accessed.
  @override
  AsyncValue<UserModel>? build() {
    _authRemoteRepository = ref.watch(authRemoteRepositoryProvider);
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);

    // Avoid linter warning: using the generated provider directly
    // This gets the current user notifier to store user in memory
    // after login or getData
    _currentUserNotifier = ref.watch(currentUserNotifierProvider.notifier);

    // Initialize SharedPreferences instance
    _authLocalRepository.init();

    // Initial state is null (not loading or errored)
    return null;
  }

  /// Used if you need to re-init preferences manually
  Future<void> initSharedPerferences() async {
    await _authLocalRepository.init();
  }

  /// Registers a new user using signup API
  /// Updates Riverpod state with loading → error/success
  Future<void> signUpUser({
    required String name,
    required String email,
    required String password,
  }) async {
    // Set loading state
    state = const AsyncValue.loading();

    // Make API call
    final res = await _authRemoteRepository.signup(
      name: name,
      email: email,
      password: password,
    );

    // Handle result using pattern matching
    final val = switch (res) {
      Left(value: final l) => state = AsyncValue.error(
        l.message,
        StackTrace.current,
      ),
      Right(value: final r) => state = AsyncValue.data(r),
    };

    // Debug output (in development)
    if (kDebugMode) {
      print('SignUpUser $val');
    }
  }

  /// Helper to handle login success:
  /// 1. Store token locally
  /// 2. Add user to CurrentUserNotifier (in-memory)
  /// 3. Return AsyncValue with user
  AsyncValue<UserModel>? _loginSuccess(UserModel user) {
    _authLocalRepository.setToken(user.token);
    _currentUserNotifier.addUser(user);
    return state = AsyncValue.data(user);
  }

  /// Logs in the user by calling the API and storing the token + user
  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    // Show loading state
    state = const AsyncValue.loading();

    // API call
    final res = await _authRemoteRepository.signin(
      email: email,
      password: password,
    );

    // Handle result
    final val = switch (res) {
      Left(value: final l) => state = AsyncValue.error(
        l.message,
        StackTrace.current,
      ),
      Right(value: final r) => _loginSuccess(r),
    };

    if (kDebugMode) {
      print('SignInUser $val');
    }
  }

  /// Called when app starts to check if user is already logged in
  /// Uses stored token to fetch user details
  Future<UserModel?> getData() async {
    // Show loading
    state = const AsyncValue.loading();

    // Read token from SharedPreferences
    final token = _authLocalRepository.getToken();

    if (token != null) {
      // Call API to validate token and get user info
      final res = await _authRemoteRepository.getCurrentUserData(token);

      // Handle response
      final val = switch (res) {
        Left(value: final l) => state = AsyncValue.error(
          l.message,
          StackTrace.current,
        ),
        Right(value: final r) => _getDataSuccess(r),
      };

      // Return the UserModel if successful
      return val.value;
    }

    // No token found → not logged in
    return null;
  }

  /// Called when token is valid and user info is retrieved
  /// Stores user in memory and updates state
  AsyncValue<UserModel> _getDataSuccess(UserModel user) {
    _currentUserNotifier.addUser(user);
    return state = AsyncValue.data(user);
  }
}
