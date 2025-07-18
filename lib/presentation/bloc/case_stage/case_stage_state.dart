part of 'case_stage_bloc.dart';

sealed class CaseStageState {}

class CaseStageInitial extends CaseStageState {}

class CaseStageLoading extends CaseStageState {}

class CaseStageSuccess extends CaseStageState {
  final List<Map<String, dynamic>> stages;

  CaseStageSuccess(this.stages);
}

class CaseStageError extends CaseStageState {
  final String message;

  CaseStageError(this.message);
}
