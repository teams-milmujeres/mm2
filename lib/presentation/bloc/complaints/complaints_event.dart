part of 'complaints_bloc.dart';

sealed class ComplaintsEvent {}

class SubmitComplaint extends ComplaintsEvent {
  final Complaint complaint;
  final String token;
  SubmitComplaint(this.complaint, this.token);
}
