import 'package:flutter/material.dart';
// Bloc
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm/presentation/bloc/auth/auth_bloc.dart';
import 'package:mm/presentation/bloc/notifications/notifications_bloc.dart';
// Localization
import 'package:mm/l10n/app_localizations.dart';
// Navigation
import 'package:go_router/go_router.dart';
// Other imports
import 'dart:io';
import 'package:mm/data/data.dart';
import 'package:flutter/foundation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscureText = true;

  String getPlatform() {
    if (kIsWeb) return 'web';
    return Platform.operatingSystem;
  }

  void toggleVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final translation = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(translation.login)),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            final notificationsBloc = context.read<NotificationBloc>();
            notificationsBloc
                .add(InitializeNotificationsEvent(state.user.id));
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(translation.login)));
            context.go('/');
          }

          if (state is AuthFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(
                image: AssetImage('assets/icon/icon.png'),
                height: 100,
              ),
              const SizedBox(height: 25),
              Text(translation.contact_to_request, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: translation.email_or_phone_number,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: obscureText,
                obscuringCharacter: '*',
                decoration: InputDecoration(
                  labelText: translation.password,
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: toggleVisibility,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  final isLoading = state is AuthLoading;
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed:
                          isLoading
                              ? null
                              : () async {
                                final authBloc = context.read<AuthBloc>();
                                final username = usernameController.text.trim();
                                final password = passwordController.text;
                                final deviceName = await getDeviceName();
                                final platform = getPlatform();

                                authBloc.add(
                                  LoginRequested({
                                    'username': username,
                                    'password': password,
                                    'device_name': deviceName,
                                    'platform': platform,
                                  }),
                                );
                              },
                      icon: const Icon(Icons.check),
                      label:
                          isLoading
                              ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                              : Text(translation.login),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.pushNamed('register');
                  },
                  icon: const Icon(Icons.person_add),
                  label: Text(translation.register),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  context.pushNamed('password_recovery');
                },
                child: Text(translation.forgot_password),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
