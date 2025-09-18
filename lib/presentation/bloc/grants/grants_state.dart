part of 'grants_bloc.dart';

sealed class GrantsState {}

final class GrantsInitial extends GrantsState {}

final class GrantsLoading extends GrantsState {}

final class GrantsSuccess extends GrantsState {
  final List<Grant> grants;

  GrantsSuccess(this.grants);
}

final class GrantsError extends GrantsState {
  final String message;

  GrantsError(this.message);
}
