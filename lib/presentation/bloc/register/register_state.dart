part of 'register_bloc.dart';

sealed class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final String message;

  RegisterSuccess(this.message);
}

class RegisterError extends RegisterState {
  final String message;

  RegisterError(this.message);
}
