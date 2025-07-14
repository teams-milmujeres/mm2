part of 'register_bloc.dart';

sealed class RegisterEvent {}

class SubmitRegisterEvent extends RegisterEvent {
  final User user;
  final String locale;
  SubmitRegisterEvent(this.user, this.locale);
}
