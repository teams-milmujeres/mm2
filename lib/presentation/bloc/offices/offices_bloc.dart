import 'package:bloc/bloc.dart';
import 'package:milmujeres_app/domain/entities/office.dart';
import 'package:milmujeres_app/data/data.dart';
part 'offices_event.dart';
part 'offices_state.dart';

class OfficesBloc extends Bloc<OfficesEvent, OfficesState> {
  OfficesBloc() : super(OfficesInitial()) {
    on<GetOfficesEvent>(_onGetOfficesEvent);
  }

  Future<String?> _checkImage(int officeId) async {
    var client = DioClient();
    final url = '/office_img/$officeId';

    try {
      final response = await client.dio.head(url);
      if (response.statusCode == 200 &&
          response.headers.value('content-type')?.startsWith('image/') ==
              true) {
        return Uri.parse(
          client.dio.options.baseUrl,
        ).resolve('/api/office_img/$officeId').toString();
      }
    } catch (_) {}

    return null;
  }

  Future<void> _onGetOfficesEvent(
    GetOfficesEvent event,
    Emitter<OfficesState> emit,
  ) async {
    emit(OfficesLoading());
    try {
      var client = DioClient();
      final response = await client.dio.get('/get_offices');

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        final offices = await Future.wait(
          (data as List).map((item) async {
            final office = Office.fromFullJson(item);

            final imageUrl = await _checkImage(office.id);
            return office.copyWith(imageUrl: imageUrl);
          }),
        );

        print("Total oficinas cargadas: ${offices.length}");
        print(offices.map((e) => e.name).toList());

        emit(OfficesSuccess(offices));
      } else {
        emit(OfficesError(errorMessage: 'Failed to load offices'));
      }
    } catch (e) {
      emit(OfficesError(errorMessage: e.toString()));
    }
  }
}
