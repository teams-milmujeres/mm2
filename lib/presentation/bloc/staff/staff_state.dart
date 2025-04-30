part of 'staff_bloc.dart';

sealed class StaffState {}

class StaffInitial extends StaffState {}

class StaffLoading extends StaffState {}

final class StaffSuccess extends StaffState {
  final Staff staff;

  StaffSuccess({required this.staff});
}

class StaffError extends StaffState {
  final String errorMessage;

  StaffError({required this.errorMessage});
}
