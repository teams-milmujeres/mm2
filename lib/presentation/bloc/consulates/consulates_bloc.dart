import 'package:bloc/bloc.dart';
import 'package:mm/data/data.dart';
import 'package:mm/domain/entities/office.dart';

part 'consulates_event.dart';
part 'consulates_state.dart';

class ConsulatesBloc extends Bloc<ConsulatesEvent, ConsulatesState> {
  ConsulatesBloc() : super(ConsulatesInitial()) {
    on<GetConsulatesEvent>(_onGetConsulatesEvent);
  }

  Future<void> _onGetConsulatesEvent(
    GetConsulatesEvent event,
    Emitter<ConsulatesState> emit,
  ) async {
    emit(ConsulatesLoading());

    try {
      final client = DioClient();
      final response = await client.dio.get('/get_cities_consulates');

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as List;

        final offices = data.map((item) => Office.fromFullJson(item)).toList();

        emit(ConsulatesSuccess(offices));
      } else {
        emit(ConsulatesError('Failed to load consulates'));
      }
    } catch (e) {
      emit(ConsulatesError(e.toString()));
    }
  }
}
