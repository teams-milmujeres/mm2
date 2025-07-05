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
