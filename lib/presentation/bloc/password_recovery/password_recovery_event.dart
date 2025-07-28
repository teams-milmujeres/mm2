part of 'password_recovery_bloc.dart';

abstract class PasswordRecoveryEvent {}

class SubmitUsername extends PasswordRecoveryEvent {
  final String username;
  final String lang;

  SubmitUsername(this.username, {this.lang = 'en'});
}

class SubmitCode extends PasswordRecoveryEvent {
  final String code;

  SubmitCode(this.code);
}

class SubmitNewPassword extends PasswordRecoveryEvent {
  final String code;
  final String password;
  final String confirmation;

  SubmitNewPassword(this.code, this.password, this.confirmation);
}
