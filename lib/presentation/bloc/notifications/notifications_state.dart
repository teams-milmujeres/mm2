part of 'notifications_bloc.dart';

sealed class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationReceived extends NotificationState {
  final RemoteMessage message;
  NotificationReceived(this.message);
}

class NotificationError extends NotificationState {
  final String errorMessage;
  NotificationError(this.errorMessage);
}
