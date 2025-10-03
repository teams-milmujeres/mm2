import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mm/config/config.dart';
import 'package:mm/l10n/app_localizations.dart';
import 'package:mm/presentation/bloc/auth/auth_bloc.dart';
import 'package:mm/presentation/bloc/locale/language_bloc.dart';
import 'package:mm/presentation/bloc/notifications/notifications_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';

// Definimos una key global
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LanguageBloc>(create: (_) => LanguageBloc()),
        BlocProvider<AuthBloc>(create: (_) => AuthBloc()..add(CheckToken())),
        BlocProvider<NotificationBloc>(create: (_) => NotificationBloc()),
      ],
      child: const MaterialAppWidget(),
    );
  }
}

class MaterialAppWidget extends StatefulWidget {
  const MaterialAppWidget({super.key});

  @override
  State<MaterialAppWidget> createState() => _MaterialAppWidgetState();
}

class _MaterialAppWidgetState extends State<MaterialAppWidget> {
  @override
  void initState() {
    super.initState();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      rootScaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(notification?.title ?? "Nueva notificación"),
          duration: const Duration(seconds: 3),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, state) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: AppTheme().lightTheme,
          locale: state.selectedLanguage.value,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: onBoardingRouter(context),
          // 🔑 Aquí le pasamos la key global
          scaffoldMessengerKey: rootScaffoldMessengerKey,
          builder:
              (context, widget) => ResponsiveBreakpoints.builder(
                child: widget!,
                breakpoints: const [
                  Breakpoint(start: 0, end: 450, name: MOBILE),
                  Breakpoint(start: 451, end: 800, name: TABLET),
                  Breakpoint(start: 801, end: 1200, name: DESKTOP),
                  Breakpoint(start: 1201, end: 2460, name: DESKTOP),
                  Breakpoint(start: 2461, end: double.infinity, name: "4K"),
                ],
              ),
        );
      },
    );
  }
}
