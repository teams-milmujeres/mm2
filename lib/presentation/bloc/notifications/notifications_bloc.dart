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
    try {
      /// 1️⃣ Solicitar permisos
      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      print("Permiso notificaciones: ${settings.authorizationStatus}");

      // Validar que el permiso fue concedido
      if (settings.authorizationStatus != AuthorizationStatus.authorized &&
          settings.authorizationStatus != AuthorizationStatus.provisional) {
        print("❌ Permiso de notificaciones rechazado o no disponible");
        return;
      }

      /// 2️⃣ En iOS esperar APNS token
      if (Platform.isIOS) {
        String? apnsToken;
        int attempts = 0;
        const maxAttempts = 15;

        // Intentar obtener el APNS token con más intentos y mejor logging
        while (apnsToken == null && attempts < maxAttempts) {
          apnsToken = await _messaging.getAPNSToken();
          if (apnsToken != null) {
            print("✅ APNS TOKEN obtenido: $apnsToken");
            break;
          }

          attempts++;
          if (attempts < maxAttempts) {
            print("⏳ Esperando APNS token... (intento $attempts/$maxAttempts)");
            await Future.delayed(const Duration(milliseconds: 500));
          }
        }

        if (apnsToken == null) {
          print("⚠️ ADVERTENCIA: APNS token NO disponible después de $maxAttempts intentos");
          print("   Verifica que:");
          print("   • Push Notifications esté habilitado en Xcode (Signing & Capabilities)");
          print("   • El Provisioning Profile incluya 'Push Notifications'");
          print("   • El certificado APNs esté configurado en Firebase Console");
          print("   • La app se ejecute en un dispositivo real (no en simulador)");
        }
      }

      /// 3️⃣ Obtener token FCM
      final token = await _messaging.getToken();
      if (token != null) {
        print("✅ FCM TOKEN: $token");
        await _sendTokenToBackend(event.clientId, token);
      } else {
        print("⚠️ No se pudo obtener token FCM");
      }

      /// 4️⃣ Escuchar renovación de token
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
        print("📲 Token refreshed: $newToken");
        _sendTokenToBackend(event.clientId, newToken);
      });

      /// 5️⃣ Listener foreground
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print("📨 Foreground message received: ${message.notification?.title}");
        add(NewNotificationEvent(message));
      });

      /// 6️⃣ Usuario abre notificación
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print("👆 Notification opened: ${message.notification?.title}");
        add(NewNotificationEvent(message));
      });

      /// 7️⃣ App abierta desde notificación cerrada
      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        print("🚀 App opened from closed state via notification");
        add(NewNotificationEvent(initialMessage));
      }
    } catch (e) {
      print("❌ Error initializing notifications: $e");
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