import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mm/data/data.dart';
import 'package:mm/domain/entities/rating.dart';

part 'rating_event.dart';
part 'rating_state.dart';

class RatingBloc extends Bloc<RatingEvent, RatingState> {
  final FlutterSecureStorage _secureStorage;

  RatingBloc({FlutterSecureStorage? secureStorage})
    : _secureStorage = secureStorage ?? const FlutterSecureStorage(),
      super(RatingInitial()) {
    on<GetRatingEvent>(_onGetRating);
    on<SendRatingEvent>(_onSendRating);
  }

  Future<void> _onGetRating(
    GetRatingEvent event,
    Emitter<RatingState> emit,
  ) async {
    emit(RatingLoading());
    try {
      final token = await _secureStorage.read(key: 'token');
      if (token == null) throw Exception('Token not found');

      final client = DioClient();

      final response = await client.dio.get(
        '/get_rate_service',
        queryParameters: {'client_id': event.clientId},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final rating = Rating.fromJson(response.data);

      emit(RatingSuccess(rating));
    } catch (e) {
      emit(RatingError(e.toString()));
    }
  }

  Future<void> _onSendRating(
    SendRatingEvent event,
    Emitter<RatingState> emit,
  ) async {
    emit(RatingLoading());
    try {
      final token = await _secureStorage.read(key: 'token');
      if (token == null) throw Exception('Token not found');

      final client = DioClient();

      final rating = Rating(
        clientId: event.clientId,
        rating: event.rating,
        comment: event.comment,
        isRating: true,
      );

      final response = await client.dio.post(
        '/rate_service',
        data: rating.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      emit(RatingSend(response.data['message']));
      await Future.delayed(Duration(milliseconds: 100));
      add(GetRatingEvent(clientId: event.clientId));
    } catch (e) {
      emit(RatingError(e.toString()));
    }
  }
}
