import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_fields/form_fields.dart';
import 'package:notifications_repository/notifications_repository.dart';
import 'package:powersync_repository/powersync_repository.dart';
import 'package:shared/shared.dart';
import 'package:user_repository/user_repository.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignupState> {
  SignUpCubit({
    required UserRepository userRepository,
    required NotificationsRepository notificationsRepository,
  }) : _userRepository = userRepository,
       _notificationsClient = notificationsRepository,
       super(const SignupState.initial());

  final UserRepository _userRepository;
  final NotificationsRepository _notificationsClient;

  void changePasswordVisibility() =>
      emit(state.copyWith(showPassword: !state.showPassword));

  void resetState() => emit(const SignupState.initial());

  void onEmailChanged(String newValue) {
    final shouldValidate = state.email.invalid;
    final newEmailState = shouldValidate
        ? Email.dirty(newValue)
        : Email.pure(newValue);
    emit(state.copyWith(email: newEmailState));
  }

  void onEmailUnfocused() {
    final newEmailState = Email.dirty(state.email.value);
    emit(state.copyWith(email: newEmailState));
  }

  void onPasswordChanged(String newValue) {
    final shouldValidate = state.password.invalid;
    final newPasswordState = shouldValidate
        ? Password.dirty(newValue)
        : Password.pure(newValue);
    emit(state.copyWith(password: newPasswordState));
  }

  void onPasswordUnfocused() {
    final newPasswordState = Password.dirty(state.password.value);
    emit(state.copyWith(password: newPasswordState));
  }

  void onFullNameChanged(String newValue) {
    final shouldValidate = state.fullName.invalid;
    final newFullNameState = shouldValidate
        ? FullName.dirty(newValue)
        : FullName.pure(newValue);
    emit(state.copyWith(fullName: newFullNameState));
  }

  void onFullNameUnfocused() {
    final newFullNameState = FullName.dirty(state.fullName.value);
    emit(state.copyWith(fullName: newFullNameState));
  }

  void onUsernameChanged(String newValue) {
    final shouldValidate = state.username.invalid;
    final newUsernameState = shouldValidate
        ? Username.dirty(newValue)
        : Username.pure(newValue);
    emit(state.copyWith(username: newUsernameState));
  }

  void onUsernameUnfocused() {
    final newUsernameState = Username.dirty(state.username.value);
    emit(state.copyWith(username: newUsernameState));
  }

  Future<void> onSubmit({File? avatarFile}) async {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final fullName = FullName.dirty(state.fullName.value);
    final username = Username.dirty(state.username.value);
    final isFormValid = FormzValid([email, password, fullName, username]).isFormValid;

    emit(state.copyWith(
      email: email,
      password: password,
      fullName: fullName,
      username: username,
      submissionStatus: isFormValid ? SignUpSubmissionStatus.inProgress : null,
    ));

    if (!isFormValid) return;

    try {
      String? imageUrlResponse;
      if (avatarFile != null) {
        final imageBytes = await PickImage().imageBytes(file: File(avatarFile.path));
        final avatarsStorage = Supabase.instance.client.storage.from('avatars');
        final fileExt = avatarFile.path.split('.').last.toLowerCase();
        final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
        
        await avatarsStorage.uploadBinary(
          fileName,
          imageBytes,
          fileOptions: FileOptions(contentType: 'image/$fileExt', cacheControl: '360000'),
        );
        imageUrlResponse = await avatarsStorage.createSignedUrl(fileName, 60 * 60 * 24 * 365 * 10);
      }

      final pushToken = await _notificationsClient.fetchToken();

      await _userRepository.signUpWithPassword(
        email: email.value,
        password: password.value,
        fullName: fullName.value,
        username: username.value,
        avatarUrl: imageUrlResponse,
        pushToken: pushToken,
      );

      if (isClosed) return;
      emit(state.copyWith(submissionStatus: SignUpSubmissionStatus.success));
    } catch (e, stackTrace) {
      _errorFormatter(e, stackTrace);
    }
  }

  void _errorFormatter(Object e, StackTrace stackTrace) {
    addError(e, stackTrace);
    print("🚨 SIGNUP ERROR LOG: $e");
    emit(state.copyWith(submissionStatus: SignUpSubmissionStatus.error));
  }
}
