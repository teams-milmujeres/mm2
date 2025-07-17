import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:milmujeres_app/data/data.dart';
import 'package:milmujeres_app/domain/entities/user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  User? _user;
  String? _token;
  bool bd = false;
  final _secureStorage = const FlutterSecureStorage();
  final client = DioClient();

  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<TryToken>(_onTryToken);
    on<CheckToken>(_onCheckToken);
    on<LogoutRequested>(_onLogoutRequested);
    on<ReadPreferencesRequested>(_onReadPreferencesRequested);
    on<SetPreferenceRequested>(_onSetPreferenceRequested);
    on<EditProfileRequested>(_onEditProfileRequested);
    on<DeleteItemRequested>(_onDeleteItemRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final response = await client.dio.post(
        '/sanctum/token',
        data: event.credentials,
      );
      final data = response.data;
      if (data['status']) {
        final token = data['token'].toString();
        bd = data['bd'];
        await _secureStorage.write(
          key: 'b',
          value: bd.toString(),
        ); // ← aquí el cambio
        add(TryToken(token: token, bd: bd));
        // print('Token: $token');
        // print('BD: $bd');
      } else {
        if (!data['verified']) {
          emit(AuthFailure(data['message']));
        } else {
          emit(AuthFailure(data['message']));
        }
      }
    } catch (e) {
      emit(AuthFailure("Username or password incorrect"));
    }
  }

  Future<void> _onTryToken(TryToken event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final response = await client.dio.get(
        '/user',
        queryParameters: {"b": event.bd},
        options: Options(headers: {'Authorization': 'Bearer ${event.token}'}),
      );

      _user = User.fromJson(response.data);
      _token = event.token;

      await _secureStorage.write(key: 'token', value: _token);
      await _secureStorage.write(key: 'client_id', value: _user!.id.toString());

      emit(AuthAuthenticated(_user!, _token!));
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        emit(
          AuthFailure("Sesión expirada. Por favor vuelve a iniciar sesión."),
        );
      } else {
        emit(AuthFailure("Error al validar el usuario. Intenta más tarde."));
      }
      emit(AuthUnauthenticated());
    } catch (_) {
      emit(AuthFailure("Error inesperado. Intenta nuevamente."));
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onCheckToken(CheckToken event, Emitter<AuthState> emit) async {
    final token = await _secureStorage.read(key: 'token');
    final bd = await _secureStorage.read(key: 'b') == 'true';

    if (token != null && token.isNotEmpty) {
      try {
        final response = await client.dio.get(
          '/user',
          queryParameters: {"b": bd},
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );

        final user = User.fromJson(response.data);
        emit(AuthAuthenticated(user, token));
      } on DioException catch (e) {
        if (e.response?.statusCode == 401) {
          emit(AuthFailure("Tu sesión ha expirado."));
        } else {
          emit(AuthFailure("No se pudo verificar la sesión."));
        }
        emit(AuthUnauthenticated());
      } catch (_) {
        emit(AuthFailure("Error inesperado al validar sesión."));
        emit(AuthUnauthenticated());
      }
    } else {
      emit(AuthFailure("No hay sesión activa."));
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await client.dio.get(
        '/user/revoke',
        options: Options(headers: {'Authorization': 'Bearer $_token'}),
      );
    } catch (_) {}
    await _secureStorage.delete(key: 'token');
    await _secureStorage.delete(key: 'client_id');
    await _secureStorage.delete(key: 'b');

    emit(AuthUnauthenticated());
  }

  Future<void> _onReadPreferencesRequested(
    ReadPreferencesRequested event,
    Emitter<AuthState> emit,
  ) async {
    final value = await _secureStorage.read(key: event.preference) ?? '';
    emit(PreferenceReadSuccess(value));
  }

  Future<void> _onSetPreferenceRequested(
    SetPreferenceRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _secureStorage.write(key: event.preference, value: event.value);
  }

  Future<void> _onEditProfileRequested(
    EditProfileRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final token = await _secureStorage.read(key: 'token');
    final bd = await _secureStorage.read(key: 'b') == 'true';

    try {
      // Enviar los datos actualizados
      await client.dio.post(
        '/user_c/${event.userId}',
        data: event.userData,
        queryParameters: {'b': bd},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      // Volver a obtener el usuario actualizado
      final response = await client.dio.get(
        '/user',
        queryParameters: {"b": bd},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      _user = User.fromJson(response.data);
      emit(AuthAuthenticated(_user!, token!));
    } catch (e) {
      emit(
        AuthFailure("No se pudo actualizar la información. Intenta más tarde."),
      );
    }
  }

  Future<void> _onDeleteItemRequested(
    DeleteItemRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final token = await _secureStorage.read(key: 'token');
      final bd = await _secureStorage.read(key: 'b') == 'true';
      final Map<String, dynamic> currentData = _user!.toJson();

      final List updatedList = List.from(currentData[event.type]);
      updatedList.removeAt(event.index);

      final updatedData = {
        event.type: updatedList,
        'client_id': event.userId,
        'client': getPlatform(), // función para detectar plataforma
      };

      await client.dio.post(
        '/user_c/${event.userId}',
        data: updatedData,
        queryParameters: {'b': bd},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      // Refresh user
      final response = await client.dio.get(
        '/user',
        queryParameters: {"b": bd},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      _user = User.fromJson(response.data);
      emit(AuthAuthenticated(_user!, token!));
    } catch (e) {
      emit(
        AuthFailure("No se pudo actualizar la información. Intenta más tarde."),
      );
    }
  }
}
