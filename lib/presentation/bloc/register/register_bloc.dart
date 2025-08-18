import 'package:bloc/bloc.dart';
import 'package:mm/data/data.dart';
import 'package:mm/domain/entities/user.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitial()) {
    on<SubmitRegisterEvent>(_onSubmitRegisterEvent);
  }

  Future<void> _onSubmitRegisterEvent(
    SubmitRegisterEvent event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoading());
    try {
      final client = DioClient();
      final userJson = event.user.toJson();

      userJson.addAll({'office_id': 1, 'lang': event.locale});

      final res = await client.dio.post('/new_register', data: userJson);
      if (res.data['status'] == 1) {
        emit(RegisterSuccess(res.data['msg']));
      } else {
        emit(RegisterError(res.data['msg']));
      }
    } catch (e) {
      emit(RegisterError('Error inesperado: $e'));
    }
  }
}
