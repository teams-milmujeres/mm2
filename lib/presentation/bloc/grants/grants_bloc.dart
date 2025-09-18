import 'package:bloc/bloc.dart';
import 'package:mm/data/data.dart';
import 'package:mm/domain/entities/grant.dart';

part 'grants_event.dart';
part 'grants_state.dart';

class GrantsBloc extends Bloc<GrantsEvent, GrantsState> {
  GrantsBloc() : super(GrantsInitial()) {
    on<GetGrantsEvent>(_onGetGrantsEvent);
  }

  Future<void> _onGetGrantsEvent(
    GetGrantsEvent event,
    Emitter<GrantsState> emit,
  ) async {
    emit(GrantsLoading());

    try {
      final client = DioClient();
      final response = await client.dio.get('/get_grants');

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as List;
        final grants = data.map((item) => Grant.fromJson(item)).toList();

        emit(GrantsSuccess(grants));
      } else {
        emit(GrantsError('Failed to load grants'));
      }
    } catch (e) {
      emit(GrantsError(e.toString()));
    }
  }
}
