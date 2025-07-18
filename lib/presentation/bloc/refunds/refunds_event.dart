part of 'refunds_bloc.dart';

sealed class RefundsEvent {}

class GetRefundsEvent extends RefundsEvent {
  final String clientId;
  GetRefundsEvent(this.clientId);
}
