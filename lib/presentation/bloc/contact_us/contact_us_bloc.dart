import 'package:bloc/bloc.dart';
import 'package:milmujeres_app/data/data.dart';
import 'package:milmujeres_app/domain/entities/contact_us.dart';

part 'contact_us_event.dart';
part 'contact_us_state.dart';

class ContactUsBloc extends Bloc<ContactUsEvent, ContactUsState> {
  ContactUsBloc() : super(ContactUsInitial()) {
    on<SubmitContactUsEvent>(_onSubmitContactUs); // ← Aquí se conecta bien
  }

  Future<void> _onSubmitContactUs(
    SubmitContactUsEvent event,
    Emitter<ContactUsState> emit,
  ) async {
    emit(ContactUsLoading());
    try {
      final client = DioClient();
      final res = await client.dio.post(
        '/contact',
        data: event.contact.toJson(),
      );

      if (res.data['status'] == 1) {
        emit(ContactUsSuccess(res.data['msg']));
      } else {
        emit(ContactUsError(res.data['msg']));
      }
    } catch (e) {
      emit(ContactUsError('Error inesperado: $e'));
    }
  }
}
