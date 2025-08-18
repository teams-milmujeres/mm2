import 'package:bloc/bloc.dart';
import 'package:mm/data/helpers/dio_client.dart';
import 'package:mm/domain/entities/citizenship.dart';
import 'package:mm/domain/entities/country.dart';

part 'countries_event.dart';
part 'countries_state.dart';

// countries_bloc.dart
class CountriesBloc extends Bloc<CountriesEvent, CountriesState> {
  CountriesBloc() : super(CountriesInitial()) {
    on<GetCountriesAndCitizenships>(_onLoadData);
  }

  Future<void> _onLoadData(
    GetCountriesAndCitizenships event,
    Emitter<CountriesState> emit,
  ) async {
    emit(CountriesLoading());

    try {
      final client = DioClient();
      final response = await client.dio.get('/get_citizenships_countries');

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;

        final countries =
            (data['countries'] as List)
                .map((item) => Country.fromJson(item))
                .toList();

        final citizenships =
            (data['citizenship'] as List)
                .map((item) => Citizenship.fromJson(item))
                .toList();

        emit(CountriesSucess(countries: countries, citizenships: citizenships));
      } else {
        emit(CountriesError('Error: respuesta inválida del servidor'));
      }
    } catch (e) {
      emit(CountriesError('Error: ${e.toString()}'));
    }
  }
}
