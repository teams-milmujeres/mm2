import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:milmujeres_app/data/data.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'case_stage_event.dart';
part 'case_stage_state.dart';

class CaseStageBloc extends Bloc<CaseStageEvent, CaseStageState> {
  final _secureStorage = const FlutterSecureStorage();

  CaseStageBloc() : super(CaseStageInitial()) {
    on<GetCaseStageEvent>(_onGetCaseStages);
  }

  Future<void> _onGetCaseStages(
    GetCaseStageEvent event,
    Emitter<CaseStageState> emit,
  ) async {
    emit(CaseStageLoading());

    try {
      final client = DioClient();
      final token = await _secureStorage.read(key: 'token');

      final response = await client.dio.get(
        '/client-stage',
        queryParameters: {'client_id': event.clientId, 'caase_stage': 1},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final data = List<Map<String, dynamic>>.from(response.data);

      // Filtrar etapas de tipo caase
      final caaseStages = data.where((e) => e['caase_stage'] == true).toList();

      // Agrupar aplicaciones por caase_id y application_id, seleccionando la más reciente
      final Map<int, Map<int, Map<String, dynamic>>> latestApplications = {};

      for (final item in data) {
        if (item['application_stage'] == true) {
          final int caaseId = item['caase_id'];
          final int applicationId = item['application_id'];
          final DateTime date = DateTime.parse(item['date']);

          latestApplications[caaseId] ??= {};
          final current = latestApplications[caaseId]![applicationId];
          if (current == null ||
              date.isAfter(DateTime.parse(current['date']))) {
            latestApplications[caaseId]![applicationId] = item;
          }
        }
      }

      // Construir la lista final con las aplicaciones agrupadas por caase
      final finalStages =
          caaseStages.map<Map<String, dynamic>>((caase) {
            final int caaseId = caase['caase_id'];
            return {
              ...caase,
              'applications':
                  latestApplications[caaseId]?.values.toList() ?? [],
            };
          }).toList();

      emit(CaseStageSuccess(finalStages));
    } catch (e) {
      emit(CaseStageError('Error al cargar etapas del caso'));
    }
  }
}
