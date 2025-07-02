import 'package:fpdart/fpdart.dart';
import 'package:frontend/core/providers/current_user_notifier.dart';
import 'package:frontend/features/auth/model/user_model.dart';
import 'package:frontend/features/auth/repository/auth_local_repository.dart';
import 'package:frontend/features/auth/repository/auth_remote_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  late AuthRemoteRepository _authRemoteRepository;
  late AuthLocalRepository _authLocalRepository;
  late CurrentUserNotifier _currentUserNotifier;
  @override
  AsyncValue<UserModel>? build() {
    _authRemoteRepository = ref.watch(authRemoteRepositoryProvider);

    _authLocalRepository = ref.watch(authLocalRepositoryProvider);
    // ignore: avoid_manual_providers_as_generated_provider_dependency
    _currentUserNotifier = ref.watch(currentUserNotifierProvider.notifier);
    _authLocalRepository.init();
    return null;
  }

  Future<void> initSharedPerferences() async {
    await _authLocalRepository.init();
  }

  Future<void> signUpUser({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final res = await _authRemoteRepository.signup(
      name: name,
      email: email,
      password: password,
    );
    final val = switch (res) {
      Left(value: final l) => state = AsyncValue.error(
        l.message,
        StackTrace.current,
      ),
      Right(value: final r) => state = AsyncValue.data(r),
    };
    print('SignUpUser $val');
  }

  AsyncValue<UserModel>? _loginSuccess(UserModel user) {
    _authLocalRepository.setToken(user.token);
    _currentUserNotifier.addUser(user);
    return state = AsyncValue.data(user);
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final res = await _authRemoteRepository.signin(
      email: email,
      password: password,
    );
    final val = switch (res) {
      Left(value: final l) => state = AsyncValue.error(
        l.message,
        StackTrace.current,
      ),
      Right(value: final r) => _loginSuccess(r),
    };
    print('SignInUser $val');
  }

  Future<UserModel?> getData() async {
    print(1);
    state = const AsyncValue.loading();
    print(2);
    final token = _authLocalRepository.getToken();
    print(3);
    if (token != null) {
      print(4);
      final res = await _authRemoteRepository.getCurrentUserData(token);
      print(5);
      final val = switch (res) {
        Left(value: final l) => state = AsyncValue.error(
          l.message,
          StackTrace.current,
        ),
        Right(value: final r) => _getDataSuccess(r),
      };
      print(6);
      print('val.value.runtimeType ${val.runtimeType}');
      print('val.value.runtimeType ${val}');
      return val.value;
    }
    print(7);
    return null;
  }

  AsyncValue<UserModel> _getDataSuccess(UserModel user) {
    _currentUserNotifier.addUser(user);
    return state = AsyncValue.data(user);
  }
}
