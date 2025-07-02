import 'dart:convert';
import 'package:frontend/core/constants/server_constants.dart';
import 'package:frontend/features/auth/model/user_model.dart';
// ignore: depend_on_referenced_packages
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/failure/failure.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;

part 'auth_remote_repository.g.dart';

@riverpod
AuthRemoteRepository authRemoteRepository(Ref ref) {
  return AuthRemoteRepository();
}

class AuthRemoteRepository {
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
      if (response.statusCode != 201) {
        return Left(FailureRespose(responseBodyMap['detail']));
      }

      return Right(UserModel.fromJson(response.body));
    } catch (e) {
      return Left(FailureRespose(e.toString()));
    }
  }

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
      if (response.statusCode != 200) {
        return Left(FailureRespose(resBodyMap['detail'].toString()));
      }

      return Right(
        UserModel.fromMap(
          resBodyMap['user'],
        ).copyWith(token: resBodyMap['token']),
      );
    } catch (e) {
      return Left(FailureRespose(e.toString()));
    }
  }

  Future<Either<FailureRespose, UserModel>> getCurrentUserData(
    String token,
  ) async {
    try {
      print('token');
      print(token);
      final response = await http.get(
        Uri.parse("${ServerConstants.serverUrl}/auth/"),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      );

      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        return Left(FailureRespose(resBodyMap['detail'].toString()));
      }

      return Right(UserModel.fromMap(resBodyMap).copyWith(token: token));
    } catch (e) {
      return Left(FailureRespose(e.toString()));
    }
  }
}
