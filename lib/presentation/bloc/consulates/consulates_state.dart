part of 'consulates_bloc.dart';

sealed class ConsulatesState {}

class ConsulatesInitial extends ConsulatesState {}

class ConsulatesLoading extends ConsulatesState {}

class ConsulatesSuccess extends ConsulatesState {
  final List<Office> offices;

  ConsulatesSuccess(this.offices);
}

class ConsulatesError extends ConsulatesState {
  final String message;

  ConsulatesError(this.message);
}
