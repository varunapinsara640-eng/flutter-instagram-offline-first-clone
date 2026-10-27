import 'dart:async';
import 'package:authentication_client/authentication_client.dart';

/// ලොගින් පියවර බයිපාස් (bypass) කර කෙලින්ම ඇතුල් වීම සඳහා සාදන ලද Dummy Authentication Client.
class DummyAuthenticationClient implements AuthenticationClient {
  
  // Named parameters වෙනුවට positional arguments විදිහට values කෙලින්ම ලබා දී ඇත
  static const _dummyUser = AuthenticationUser(
    'dummy-user-id-12345',
    'dummy.developer@example.com',
    'Varuna Pinsara',
  );

  final _userStreamController = StreamController<AuthenticationUser>.broadcast();

  DummyAuthenticationClient() {
    _userStreamController.add(_dummyUser);
  }

  @override
  Stream<AuthenticationUser> get user {
    Timer.run(() => _userStreamController.add(_dummyUser));
    return _userStreamController.stream;
  }

  @override
  Future<void> logInWithPassword({
    required String password,
    String? email,
    String? phone,
  }) async {
    _userStreamController.add(_dummyUser);
  }

  @override
  Future<void> logInWithGoogle() async {
    _userStreamController.add(_dummyUser);
  }

  @override
  Future<void> logInWithGithub() async {
    _userStreamController.add(_dummyUser);
  }

  @override
  Future<void> signUpWithPassword({
    required String password,
    required String fullName,
    required String username,
    String? avatarUrl,
    String? email,
    String? phone,
    String? pushToken,
  }) async {
    _userStreamController.add(_dummyUser);
  }

  @override
  Future<void> sendPasswordResetEmail({
    required String email,
    String? redirectTo,
  }) async {}

  @override
  Future<void> resetPassword({
    required String token,
    required String email,
    required String newPassword,
  }) async {}

  @override
  Future<void> logOut() async {
    _userStreamController.add(AuthenticationUser.anonymous);
  }

  void dispose() {
    _userStreamController.close();
  }
}
