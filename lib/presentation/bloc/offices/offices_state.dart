part of 'offices_bloc.dart';

sealed class OfficesState {}

class OfficesInitial extends OfficesState {}

class OfficesLoading extends OfficesState {}

class OfficesSuccess extends OfficesState {
  final List<Office> offices;
  OfficesSuccess(this.offices);
}

class OfficesError extends OfficesState {
  final String errorMessage;

  OfficesError({required this.errorMessage});
}
