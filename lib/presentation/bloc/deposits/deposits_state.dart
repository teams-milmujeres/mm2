part of 'deposits_bloc.dart';

sealed class DepositsState {}

class DepositsInitial extends DepositsState {}

class DepositsLoading extends DepositsState {}

class DepositsSuccess extends DepositsState {
  final List<Deposit> deposits;
  DepositsSuccess(this.deposits);
}

class DepositsError extends DepositsState {
  final String message;
  DepositsError(this.message);
}
