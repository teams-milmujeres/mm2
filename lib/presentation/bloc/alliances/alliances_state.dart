part of 'alliances_bloc.dart';

sealed class AlliancesState {}

class AlliancesInitial extends AlliancesState {}

class AlliancesLoading extends AlliancesState {}

class AlliancesSuccess extends AlliancesState {
  final List<Alliance> alliances;

  AlliancesSuccess(this.alliances);
}

class AlliancesError extends AlliancesState {
  final String message;

  AlliancesError(this.message);
}
