part of 'notifications_bloc.dart';

sealed class NotificationEvent {}

class InitializeNotificationsEvent extends NotificationEvent {
  final int clientId;
  InitializeNotificationsEvent(this.clientId);
}

class NewNotificationEvent extends NotificationEvent {
  final RemoteMessage message;
  NewNotificationEvent(this.message);
}

class UpdateTokenEvent extends NotificationEvent {
  final int clientId;
  final String token;
  UpdateTokenEvent(this.clientId, this.token);
}

class GetNotificationsEvent extends NotificationEvent {
  final int clientId;
  GetNotificationsEvent(this.clientId);
}

class ClearNotificationsEvent extends NotificationEvent {}
