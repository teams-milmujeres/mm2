part of 'countries_bloc.dart';

sealed class CountriesState {}

class CountriesInitial extends CountriesState {}

class CountriesLoading extends CountriesState {}

class CountriesSucess extends CountriesState {
  final List<Country> countries;
  final List<Citizenship> citizenships;

  CountriesSucess({required this.countries, required this.citizenships});
}

class CountriesError extends CountriesState {
  final String message;

  CountriesError(this.message);
}
