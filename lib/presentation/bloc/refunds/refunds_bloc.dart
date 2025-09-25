import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:mm/data/data.dart';
import 'package:mm/domain/entities/refund.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'refunds_event.dart';
part 'refunds_state.dart';

class RefundsBloc extends Bloc<RefundsEvent, RefundsState> {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  RefundsBloc() : super(RefundsInitial()) {
    on<GetRefundsEvent>(_onGetRefundsEvent);
  }

  Future<void> _onGetRefundsEvent(
    GetRefundsEvent event,
    Emitter<RefundsState> emit,
  ) async {
    emit(RefundsLoading());
    try {
      final client = DioClient();
      final token = await _secureStorage.read(key: 'token');

      final res = await client.dio.post(
        '/refunds',
        data: {'client_id': event.clientId},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (res.statusCode == 200 && res.data != null) {
        final data = res.data;
        final refunds =
            (data as List).map((item) => Refund.fromJson(item)).toList();
        emit(RefundsSuccess(refunds));
      } else {
        emit(RefundsError('Failed to load refunds'));
      }
    } catch (e) {
      emit(RefundsError(e.toString()));
    }
  }
}
