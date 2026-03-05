import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mm/data/data.dart';
import 'package:dio/dio.dart';
import 'package:mm/domain/entities/notification.dart';
import 'dart:convert';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  NotificationBloc() : super(const NotificationInitial()) {
    on<InitializeNotificationsEvent>(_onInit);
    on<NewNotificationEvent>(_onNewNotification);
    on<GetNotificationsEvent>(_onGetNotifications);
    on<ClearNotificationsEvent>(_onClearNotifications);
  }

  Future<void> _onInit(
    InitializeNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {

    /// 1️⃣ Solicitar permisos
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print("Permiso notificaciones: ${settings.authorizationStatus}");

    /// 2️⃣ En iOS esperar APNS token
    if (Platform.isIOS) {
      String? apnsToken;

      for (int i = 0; i < 10; i++) {
        apnsToken = await _messaging.getAPNSToken();
        if (apnsToken != null) break;

        print("Esperando APNS token...");
        await Future.delayed(const Duration(seconds: 1));
      }

      print("APNS TOKEN: $apnsToken");
    }

    /// 3️⃣ Obtener token FCM
    final token = await _messaging.getToken();
    print("FCM TOKEN: $token");

    if (token != null) {
      await _sendTokenToBackend(event.clientId, token);
    }

    /// 4️⃣ Escuchar renovación de token
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      print("Token refreshed: $newToken");
      _sendTokenToBackend(event.clientId, newToken);
    });

    /// 5️⃣ Listener foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground message: ${message.data}");
      add(NewNotificationEvent(message));
    });

    /// 6️⃣ Usuario abre notificación
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      add(NewNotificationEvent(message));
    });

    /// 7️⃣ App abierta desde notificación cerrada
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      add(NewNotificationEvent(initialMessage));
    }
  }

  void _onNewNotification(
    NewNotificationEvent event,
    Emitter<NotificationState> emit,
  ) {
    emit(NotificationReceived(event.message, hasNewNotification: true));
  }

  void _onClearNotifications(
    ClearNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) {
    emit(NotificationUpdated(hasNewNotification: false));
  }

  Future<void> _sendTokenToBackend(int clientId, String token) async {
    try {
      var client = DioClient();
      const secureStorage = FlutterSecureStorage();
      final authToken = await secureStorage.read(key: 'token');

      if (authToken == null) {
        print("No auth token");
        return;
      }

      final response = await client.dio.put(
        '/update-device-token',
        data: {
          "client_id": clientId,
          "fcm_token": token
        },
        options: Options(
          headers: {'Authorization': 'Bearer $authToken'},
        ),
      );

      if (response.statusCode == 200) {
        print("Token enviado correctamente");
      } else {
        print("Error enviando token: ${response.data}");
      }
    } catch (e) {
      print("Error backend: $e");
    }
  }

  Future<void> _onGetNotifications(
    GetNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {

    emit(NotificationLoading(hasNewNotification: state.hasNewNotification));

    final client = DioClient();
    final token = await const FlutterSecureStorage().read(key: 'token');

    try {
      final response = await client.dio.get(
        '/get-notifications',
        queryParameters: {'client_id': event.clientId},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final data = response.data;

      List<dynamic> notificationList;

      if (data is String) {
        notificationList = jsonDecode(data);
      } else if (data is List) {
        notificationList = data;
      } else {
        emit(NotificationError(
          'Unexpected notification data type',
          hasNewNotification: state.hasNewNotification,
        ));
        return;
      }

      final notifications = List<Notification>.from(
        notificationList.map((n) => Notification.fromJson(n)),
      );

      emit(NotificationSuccess(
        notifications,
        hasNewNotification: state.hasNewNotification,
      ));

    } catch (e) {
      emit(NotificationError(
        e.toString(),
        hasNewNotification: state.hasNewNotification,
      ));
    }
  }
}