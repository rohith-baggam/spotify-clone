// ignore: depend_on_referenced_packages is used to suppress linter warnings for internal dependency usage.
import 'package:riverpod/riverpod.dart';

// Import for Riverpod code generation using annotations.
import 'package:riverpod_annotation/riverpod_annotation.dart';

// SharedPreferences is used for storing data locally on the device.
import 'package:shared_preferences/shared_preferences.dart';

// Required for Riverpod code generation; this file will be generated automatically
part 'auth_local_repository.g.dart';

/// A Riverpod provider for the AuthLocalRepository class.
/// `keepAlive: true` ensures the provider is not disposed when not used.
/// This is useful because the token might be needed any time during the app session.
@Riverpod(keepAlive: true)
AuthLocalRepository authLocalRepository(Ref ref) {
  return AuthLocalRepository();
}

/// This class provides a wrapper around SharedPreferences for local
/// storage of authentication-related data, particularly the auth token.
///
/// It acts as a local layer to:
/// - Store the token after login
/// - Retrieve the token for authenticated API calls
/// - Maintain session persistence across app restarts
class AuthLocalRepository {
  /// The underlying SharedPreferences instance used for persistent storage.
  late SharedPreferences _sharedPreferences;

  /// Initializes the SharedPreferences instance asynchronously.
  /// This must be called before any get/set operations.
  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  /// Stores the token string in local storage with a key: 'x-auth-token'.
  /// This is typically called after a successful login.
  void setToken(String? token) {
    if (token != null) {
      _sharedPreferences.setString('x-auth-token', token);
    }
  }

  /// Retrieves the saved token from local storage.
  /// Returns `null` if the token was not previously saved or has been cleared.
  String? getToken() {
    return _sharedPreferences.getString('x-auth-token');
  }
}
