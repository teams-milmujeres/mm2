import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:milmujeres_app/data/data.dart';

import 'package:milmujeres_app/domain/entities/alliance.dart';

part 'alliances_event.dart';
part 'alliances_state.dart';

class AlliancesBloc extends Bloc<AlliancesEvent, AlliancesState> {
  AlliancesBloc() : super(AlliancesInitial()) {
    on<FindAlliancesEvent>(_onFindAlliancesEvent);
  }

  Future<void> _onFindAlliancesEvent(
    FindAlliancesEvent event,
    Emitter<AlliancesState> emit,
  ) async {
    emit(AlliancesLoading());
    try {
      final client = DioClient();
      final response = await client.dio.post(
        '/find_alliance',
        data: {'search': event.query},
        options: Options(headers: {'Authorization': 'Bearer ${event.token}'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        final alliances =
            (data as List).map((item) => Alliance.fromJson(item)).toList();
        emit(AlliancesSuccess(alliances));
      } else {
        emit(AlliancesError('Failed to load alliances'));
      }
    } catch (e) {
      emit(AlliancesError(e.toString()));
    }
  }
}
