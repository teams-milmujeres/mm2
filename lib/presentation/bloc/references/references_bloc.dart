import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:mm/data/data.dart';
import 'package:mm/domain/entities/reference.dart';

part 'references_event.dart';
part 'references_state.dart';

class ReferencesBloc extends Bloc<ReferencesEvent, ReferencesState> {
  ReferencesBloc() : super(ReferencesInitial()) {
    on<GetReferencesEvent>(_onGetReferencesEvent);
    on<GetReferenceByIdEvent>(_onGetReferenceByIdEvent);
    on<FindReferencesEvent>(_onFindReferencesEvent);
  }

  Future<void> _onGetReferencesEvent(
    GetReferencesEvent event,
    Emitter<ReferencesState> emit,
  ) async {
    emit(ReferencesLoading());
    try {
      var client = DioClient();
      final response = await client.dio.get('/get_references');

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        final references =
            (data as List)
                .map((item) => Reference.fromJson(item['data']))
                .toList();
        emit(ReferencesSuccess(references));
      } else {
        emit(ReferencesError('Failed to load references'));
      }
    } catch (e) {
      emit(ReferencesError(e.toString()));
    }
  }

  Future<void> _onGetReferenceByIdEvent(
    GetReferenceByIdEvent event,
    Emitter<ReferencesState> emit,
  ) async {
    emit(ReferencesLoading());
    try {
      var client = DioClient();
      final response = await client.dio.get('/get_office/${event.id}');

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        final reference = Reference.fromJson(data['data']);
        emit(ReferencesSuccess([reference]));
      } else {
        emit(ReferencesError('Failed to load reference'));
      }
    } catch (e) {
      emit(ReferencesError(e.toString()));
    }
  }

  Future<void> _onFindReferencesEvent(
    FindReferencesEvent event,
    Emitter<ReferencesState> emit,
  ) async {
    emit(ReferencesLoading());
    try {
      final client = DioClient();
      final response = await client.dio.post(
        '/find_reference',
        data: {'search': event.query},
        options: Options(headers: {'Authorization': 'Bearer ${event.token}'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        final references =
            (data as List).map((item) => Reference.fromJson(item)).toList();
        emit(ReferencesSuccess(references));
      } else {
        emit(ReferencesError('Failed to load references'));
      }
    } catch (e) {
      emit(ReferencesError(e.toString()));
    }
  }
}
