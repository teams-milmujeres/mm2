import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm/l10n/app_localizations.dart';
import 'package:mm/presentation/bloc/auth/auth_bloc.dart';
import 'package:mm/presentation/bloc/notifications/notifications_bloc.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context)!;
    final authState = context.watch<AuthBloc>().state;

    if (authState is! AuthAuthenticated) {
      return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Icon(
                Icons.notifications,
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(width: 5),
              Text(translate.notifications),
            ],
          ),
        ),
        body: Center(child: Text(translate.no_elements)),
      );
    }

    final clientId = authState.user.id;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.notifications,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(width: 5),
            Text(translate.notifications),
          ],
        ),
      ),
      body: BlocProvider(
        create:
            (context) =>
                NotificationBloc()..add(GetNotificationsEvent(clientId)),
        child: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NotificationError) {
              return Center(child: Text(state.errorMessage));
            } else if (state is NotificationSuccess) {
              final notifications = state.notifications;

              if (notifications.isEmpty) {
                return Center(child: Text(translate.no_elements));
              }

              return ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(notification.title),
                        subtitle: Text(notification.body),
                        trailing: Text(notification.date),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text('Unknown state'));
            }
          },
        ),
      ),
    );
  }
}
