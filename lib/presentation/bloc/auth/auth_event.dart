part of 'auth_bloc.dart';

abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final Map<String, dynamic> credentials;
  LoginRequested(this.credentials);
}

class TryToken extends AuthEvent {
  final String token;
  final bool bd;
  TryToken({required this.token, this.bd = false});
}

class CheckToken extends AuthEvent {}

class LogoutRequested extends AuthEvent {}

class ReadPreferencesRequested extends AuthEvent {
  final String preference;
  ReadPreferencesRequested(this.preference);
}

class SetPreferenceRequested extends AuthEvent {
  final String preference;
  final String value;
  SetPreferenceRequested(this.preference, this.value);
}

class EditProfileRequested extends AuthEvent {
  final String userId;
  final Map<String, dynamic> userData;
  EditProfileRequested(this.userId, this.userData);
}

class DeleteItemRequested extends AuthEvent {
  final int userId;
  final String type; // 'emails', 'phones', 'address'
  final int index;

  DeleteItemRequested({
    required this.userId,
    required this.type,
    required this.index,
  });
}
