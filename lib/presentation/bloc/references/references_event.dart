part of 'references_bloc.dart';

sealed class ReferencesEvent {}

class GetReferencesEvent extends ReferencesEvent {}

class GetReferenceByIdEvent extends ReferencesEvent {
  final String id;

  GetReferenceByIdEvent(this.id);
}

class FindReferencesEvent extends ReferencesEvent {
  final String query;
  final String token;

  FindReferencesEvent(this.query, this.token);
}
