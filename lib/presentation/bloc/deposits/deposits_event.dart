part of 'deposits_bloc.dart';

sealed class DepositsEvent {}

class GetDepositsEvent extends DepositsEvent {
  final String clientId;
  GetDepositsEvent(this.clientId);
}
