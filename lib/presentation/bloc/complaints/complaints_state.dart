part of 'complaints_bloc.dart';

sealed class ComplaintsState {}

class ComplaintsInitial extends ComplaintsState {}

class ComplaintsLoading extends ComplaintsState {}

class ComplaintsSucess extends ComplaintsState {
  final String message;

  ComplaintsSucess(this.message);
}

class ComplaintsError extends ComplaintsState {
  final String message;

  ComplaintsError(this.message);
}
