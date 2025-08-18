import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm/data/data.dart';
import 'package:mm/domain/entities/staff.dart';

part 'staff_state.dart';
part 'staff_event.dart';

class StaffBloc extends Bloc<StaffEvent, StaffState> {
  StaffBloc() : super(StaffInitial()) {
    on<StaffFetchEvent>(_onStaffFetchEvent);
  }

  Future<String?> _checkImage(int userId) async {
    var client = DioClient();
    final url = '/staff_img/$userId';

    try {
      final response = await client.dio.head(url);
      if (response.statusCode == 200 &&
          response.headers.value('content-type')?.startsWith('image/') ==
              true) {
        return Uri.parse(
          client.dio.options.baseUrl,
        ).resolve('/api/staff_img/$userId').toString();
      }
    } catch (_) {}

    return null;
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

        final executiveTeam = await Future.wait(
          (data['executive_team'] as List).map((item) async {
            final member = StaffMember.fromJson(item);
            final imageUrl = await _checkImage(member.userId);
            return member.copyWith(imageUrl: imageUrl);
          }),
        );

        final legalTeam = await Future.wait(
          (data['legal_team'] as List).map((item) async {
            final member = StaffMember.fromJson(item);
            final imageUrl = await _checkImage(member.userId);
            return member.copyWith(imageUrl: imageUrl);
          }),
        );

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
