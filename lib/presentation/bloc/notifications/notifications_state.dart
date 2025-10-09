part of 'notifications_bloc.dart';

abstract class NotificationState {
  final bool hasNewNotification;
  const NotificationState({this.hasNewNotification = false});
}

class NotificationInitial extends NotificationState {
  const NotificationInitial({super.hasNewNotification});
}

class NotificationLoading extends NotificationState {
  const NotificationLoading({super.hasNewNotification});
}

class NotificationReceived extends NotificationState {
  final RemoteMessage message;
  const NotificationReceived(this.message, {super.hasNewNotification});
}

class NotificationError extends NotificationState {
  final String errorMessage;
  const NotificationError(this.errorMessage, {super.hasNewNotification});
}

class NotificationSuccess extends NotificationState {
  final List<Notification> notifications;
  const NotificationSuccess(this.notifications, {super.hasNewNotification});
}

class NotificationUpdated extends NotificationState {
  const NotificationUpdated({required bool hasNewNotification})
      : super(hasNewNotification: hasNewNotification);
}
