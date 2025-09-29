import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:mm/data/data.dart';
import 'package:mm/domain/entities/deposit.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'deposits_event.dart';
part 'deposits_state.dart';

class DepositsBloc extends Bloc<DepositsEvent, DepositsState> {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  DepositsBloc() : super(DepositsInitial()) {
    on<GetDepositsEvent>(_onGetDepositsEvent);
  }
  Future<void> _onGetDepositsEvent(
    GetDepositsEvent event,
    Emitter<DepositsState> emit,
  ) async {
    emit(DepositsLoading());
    try {
      final client = DioClient();
      final token = await _secureStorage.read(key: 'token');

      final res = await client.dio.post(
        '/app-deposits',
        data: {'client_id': event.clientId},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (res.statusCode == 200 && res.data != null) {
        final data = res.data;
        final deposits =
            (data as List).map((item) => Deposit.fromJson(item)).toList();
        emit(DepositsSuccess(deposits));
      } else {
        emit(DepositsError('Failed to load deposits'));
      }
    } catch (e) {
      emit(DepositsError(e.toString()));
    }
  }
}
