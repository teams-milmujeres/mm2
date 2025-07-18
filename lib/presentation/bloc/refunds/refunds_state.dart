part of 'refunds_bloc.dart';

sealed class RefundsState {}

class RefundsInitial extends RefundsState {}

class RefundsLoading extends RefundsState {}

class RefundsSuccess extends RefundsState {
  final List<Refund> refunds;
  RefundsSuccess(this.refunds);
}

class RefundsError extends RefundsState {
  final String message;
  RefundsError(this.message);
}
