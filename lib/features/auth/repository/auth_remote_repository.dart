import 'dart:convert';
import 'package:frontend/core/constants/server_constants.dart';
import 'package:frontend/features/auth/model/user_model.dart';

import '../../../core/failure/failure.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;

class AuthRemoteRepository {
  static Future<Either<FailureRespose, UserModel>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${ServerConstants.ServerUrl}/auth/signup"),
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

  static Future<Either<FailureRespose, UserModel>> signin({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${ServerConstants.ServerUrl}/auth/login"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;
      print('resBodyMap');
      print(resBodyMap);
      if (response.statusCode != 200) {
        return Left(FailureRespose(resBodyMap['detail'].toString()));
      }
      return Right(UserModel.fromMap(resBodyMap['user']));
    } catch (e) {
      return Left(FailureRespose(e.toString()));
    }
  }
}
