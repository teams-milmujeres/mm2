import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mm/data/data.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mm/domain/entities/notification.dart';

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
    // 1. Solicitar permisos (iOS)
    await _messaging.requestPermission();

    // 2. Obtener el token
    final token = await _messaging.getToken(vapidKey: dotenv.env['VAPID_KEY']);
    print(" FCM TOKEN: $token");

    if (token != null) {
      await _sendTokenToBackend(event.clientId, token);
    }

    // 3. Escuchar cambios del token (cuando Firebase lo renueva)
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      print("🔄 Token refreshed: $newToken");
      _sendTokenToBackend(event.clientId, newToken);
    });

    // 4. Listener cuando llega una notificación en foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground message received: ${message.data}");
      add(NewNotificationEvent(message));
    });

    // 5. Listener cuando el usuario abre la app desde la notificación
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      add(NewNotificationEvent(message));
    });

    // 6. Manejar si la app estaba terminada y se abre desde notificación
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

  // Método para enviar el token al backend
  Future<void> _sendTokenToBackend(int clientId, String token) async {
    try {
      var client = DioClient();
      const secureStorage = FlutterSecureStorage();
      final authToken = await secureStorage.read(key: 'token');

      if (authToken == null) {
        print("Error: No se encontró token de autenticación.");
        return;
      }

      final response = await client.dio.put(
        '/update-device-token',
        data: {"client_id": clientId, "fcm_token": token},
        options: Options(headers: {'Authorization': 'Bearer $authToken'}),
      );

      if (response.statusCode == 200) {
        print("Token enviado al backend correctamente");
      } else {
        print("Error enviando token: ${response.data}");
      }
    } catch (e) {
      print("Error en conexión con backend: $e");
    }
  }

  // Método para obtener las notificaciones del backend
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

      final notifications = List<Notification>.from(
        (response.data as List).map((n) => Notification.fromJson(n)),
      );

      emit(NotificationSuccess(notifications,
          hasNewNotification: state.hasNewNotification));
    } catch (e) {
      emit(NotificationError(e.toString(),
          hasNewNotification: state.hasNewNotification));
    }
  }
}
