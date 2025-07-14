import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:milmujeres_app/data/data.dart';
import 'package:milmujeres_app/domain/entities/complaint.dart';

part 'complaints_event.dart';
part 'complaints_state.dart';

class ComplaintsBloc extends Bloc<ComplaintsEvent, ComplaintsState> {
  ComplaintsBloc() : super(ComplaintsInitial()) {
    on<SubmitComplaint>(_onSubmitComplaint);
  }

  Future<void> _onSubmitComplaint(
    SubmitComplaint event,
    Emitter<ComplaintsState> emit,
  ) async {
    emit(ComplaintsLoading());
    try {
      final client = DioClient();
      final res = await client.dio.post(
        '/complaint',
        data: event.complaint.toJson(),
        options: Options(headers: {'Authorization': 'Bearer ${event.token}'}),
      );

      if (res.data['status'] == 1) {
        emit(ComplaintsSucess(res.data['msg']));
      } else {
        emit(ComplaintsError(res.data['msg']));
      }
    } catch (e) {
      emit(ComplaintsError('Error inesperado: $e'));
    }
  }
}
