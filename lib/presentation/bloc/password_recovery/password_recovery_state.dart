abstract class PasswordRecoveryState {}

class RecoveryInitial extends PasswordRecoveryState {}

class RecoveryLoading extends PasswordRecoveryState {}

class RecoveryStep1 extends PasswordRecoveryState {} // Código enviado

class RecoveryStep2 extends PasswordRecoveryState {} // Nueva contraseña

class RecoverySuccess extends PasswordRecoveryState {} // Éxito final

class RecoveryFailure extends PasswordRecoveryState {
  final String message;

  RecoveryFailure(this.message);
}
