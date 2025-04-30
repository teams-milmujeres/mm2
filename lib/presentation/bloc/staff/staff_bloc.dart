import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:milmujeres_app/data/data.dart';
import 'package:milmujeres_app/domain/entities/staff.dart';

part 'staff_state.dart';
part 'staff_event.dart';

class StaffBloc extends Bloc<StaffEvent, StaffState> {
  StaffBloc() : super(StaffInitial()) {
    on<StaffFetchEvent>(_onStaffFetchEvent);
  }

  Future<void> _onStaffFetchEvent(
    StaffFetchEvent event,
    Emitter<StaffState> emit,
  ) async {
    emit(StaffLoading());
    try {
      var client = DioClient();
      final response = await client.dio.get('/staff');

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;

        List<StaffMember> executiveTeam =
            (data['executive_team'] as List)
                .map((item) => StaffMember.fromJson(item))
                .toList();

        List<StaffMember> legalTeam =
            (data['legal_team'] as List)
                .map((item) => StaffMember.fromJson(item))
                .toList();

        emit(
          StaffSuccess(
            staff: Staff(executiveTeam: executiveTeam, legalTeam: legalTeam),
          ),
        );
      } else {
        emit(StaffError(errorMessage: 'Error: ${response.statusCode}'));
      }
    } catch (e) {
      emit(StaffError(errorMessage: 'Excepción: ${e.toString()}'));
    }
  }
}
