part of 'alliances_bloc.dart';

sealed class AlliancesEvent {}

class FindAlliancesEvent extends AlliancesEvent {
  final String query;
  final String token;

  FindAlliancesEvent(this.query, this.token);
}
