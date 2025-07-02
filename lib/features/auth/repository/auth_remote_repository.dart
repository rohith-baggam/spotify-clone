import 'dart:convert';

import 'package:frontend/core/constants/server_constants.dart';

import 'package:frontend/features/auth/model/user_model.dart';

// Ignore warning: direct dependency on generated Riverpod package
// Used to create providers manually
// ignore: depend_on_referenced_packages
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Failure model used to represent API errors
import '../../../core/failure/failure.dart';

import 'package:fpdart/fpdart.dart';

import 'package:http/http.dart' as http;

// Required for Riverpod code generation
part 'auth_remote_repository.g.dart';

/// This is a Riverpod provider that exposes an instance of AuthRemoteRepository.
/// It can be used anywhere in your app via `ref.watch(authRemoteRepositoryProvider)`.
@riverpod
AuthRemoteRepository authRemoteRepository(Ref ref) {
  return AuthRemoteRepository();
}

/// Repository responsible for handling authentication-related HTTP requests
/// like sign-up, login, and getting current user data from the backend.
class AuthRemoteRepository {
  /// Sends a POST request to the /auth/signup endpoint
  /// Creates a new user on the server
  ///
  /// Returns:
  /// - `Right(UserModel)` on success
  /// - `Left(FailureResponse)` on error
  Future<Either<FailureRespose, UserModel>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${ServerConstants.serverUrl}/auth/signup"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );

      final responseBodyMap = jsonDecode(response.body) as Map<String, dynamic>;

      // If signup failed (e.g., email already exists)
      if (response.statusCode != 201) {
        return Left(FailureRespose(responseBodyMap['detail']));
      }

      // On success, convert response JSON to UserModel
      return Right(UserModel.fromJson(response.body));
    } catch (e) {
      // Network/server/parse error
      return Left(FailureRespose(e.toString()));
    }
  }

  /// Sends a POST request to the /auth/login endpoint
  /// Authenticates the user and retrieves user data with token
  ///
  /// Returns:
  /// - `Right(UserModel)` with token on success
  /// - `Left(FailureResponse)` on error
  Future<Either<FailureRespose, UserModel>> signin({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${ServerConstants.serverUrl}/auth/login"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;

      // If authentication fails (e.g., invalid credentials)
      if (response.statusCode != 200) {
        return Left(FailureRespose(resBodyMap['detail'].toString()));
      }

      // Extract user and token from response
      return Right(
        UserModel.fromMap(
          resBodyMap['user'],
        ).copyWith(token: resBodyMap['token']),
      );
    } catch (e) {
      // Handle unexpected errors
      return Left(FailureRespose(e.toString()));
    }
  }

  /// Fetches the current user's data using the stored token
  ///
  /// This is typically used when the app starts, and the token
  /// is retrieved from SharedPreferences to validate and restore the session.
  ///
  /// Returns:
  /// - `Right(UserModel)` on success
  /// - `Left(FailureResponse)` on failure (e.g., token expired)
  Future<Either<FailureRespose, UserModel>> getCurrentUserData(
    String token,
  ) async {
    try {
      // Debug print for verifying token flow
      print('token');
      print(token);

      final response = await http.get(
        Uri.parse("${ServerConstants.serverUrl}/auth/"),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token, // Custom header for authentication
        },
      );

      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;

      // If server responds with an error (e.g., invalid or expired token)
      if (response.statusCode == 200) {
        return Left(FailureRespose(resBodyMap['detail'].toString()));
      }

      // On success, return the user with the same token
      return Right(UserModel.fromMap(resBodyMap).copyWith(token: token));
    } catch (e) {
      return Left(FailureRespose(e.toString()));
    }
  }
}
