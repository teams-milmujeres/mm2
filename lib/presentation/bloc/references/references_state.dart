part of 'references_bloc.dart';

sealed class ReferencesState {}

class ReferencesInitial extends ReferencesState {}

class ReferencesLoading extends ReferencesState {}

class ReferencesSuccess extends ReferencesState {
  final List<Reference> references;

  ReferencesSuccess(this.references);
}

class ReferencesError extends ReferencesState {
  final String message;

  ReferencesError(this.message);
}
