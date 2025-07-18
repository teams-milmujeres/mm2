part of 'case_stage_bloc.dart';

sealed class CaseStageEvent {}

class GetCaseStageEvent extends CaseStageEvent {
  final String clientId;

  GetCaseStageEvent(this.clientId);
}
