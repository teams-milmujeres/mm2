part of 'references_bloc.dart';

sealed class ReferencesEvent {}

class GetReferencesEvent extends ReferencesEvent {}

class GetReferenceByIdEvent extends ReferencesEvent {
  final String id;

  GetReferenceByIdEvent(this.id);
}
