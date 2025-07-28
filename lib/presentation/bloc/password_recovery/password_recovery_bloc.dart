// account_recovery_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:milmujeres_app/data/data.dart';

part 'password_recovery_event.dart';
part 'password_recovery_state.dart';

class PasswordRecoveryBloc
    extends Bloc<PasswordRecoveryEvent, PasswordRecoveryState> {
  PasswordRecoveryBloc() : super(RecoveryInitial()) {
    on<SubmitUsername>(_onSubmitUsername);
    on<SubmitCode>(_onSubmitCode);
    on<SubmitNewPassword>(_onSubmitNewPassword);
  }

  Future<void> _onSubmitUsername(
    SubmitUsername event,
    Emitter<PasswordRecoveryState> emit,
  ) async {
    emit(RecoveryLoading());
    try {
      final client = DioClient();
      final res = await client.dio.post(
        '/recovery_finder',
        data: {'username': event.username, 'lang': event.lang},
      );

      if (res.data['status'] == 1) {
        emit(RecoveryStep1());
      } else {
        emit(RecoveryFailure(res.data['msg']));
        emit(RecoveryInitial());
      }
    } catch (e) {
      emit(RecoveryFailure('Error inesperado: $e'));
      emit(RecoveryInitial());
    }
  }

  Future<void> _onSubmitCode(
    SubmitCode event,
    Emitter<PasswordRecoveryState> emit,
  ) async {
    emit(RecoveryLoading());
    try {
      final client = DioClient();
      final res = await client.dio.post(
        '/recovery_account',
        data: {'code': event.code},
      );

      if (res.data['status'] == 1) {
        emit(RecoveryStep2());
      } else {
        emit(RecoveryFailure(res.data['msg']));
        emit(RecoveryStep1());
      }
    } catch (e) {
      emit(RecoveryFailure('Error inesperado: $e'));
      emit(RecoveryStep1());
    }
  }

  Future<void> _onSubmitNewPassword(
    SubmitNewPassword event,
    Emitter<PasswordRecoveryState> emit,
  ) async {
    emit(RecoveryLoading());
    try {
      final client = DioClient();
      final res = await client.dio.post(
        '/recovery_update_password',
        data: {
          'code': event.code,
          'password': event.password,
          'confirmation': event.confirmation,
        },
      );

      if (res.data['status'] == 1) {
        emit(RecoverySuccess());
      } else {
        emit(RecoveryFailure(res.data['msg']));
        emit(RecoveryStep2());
      }
    } catch (e) {
      emit(RecoveryFailure('Error inesperado: $e'));
      emit(RecoveryStep2());
    }
  }
}
