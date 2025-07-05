part of 'auth_bloc.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;
  final String token;
  AuthAuthenticated(this.user, this.token);
}

class AuthUnauthenticated extends AuthState {}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}

class PreferenceReadSuccess extends AuthState {
  final String value;
  PreferenceReadSuccess(this.value);
}
