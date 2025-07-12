import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:milmujeres_app/config/config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:milmujeres_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:milmujeres_app/presentation/bloc/locale/language_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
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
      ],
      child: const MaterialAppWidget(),
    );
  }
}

class MaterialAppWidget extends StatelessWidget {
  const MaterialAppWidget({super.key});

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
          // Resposive breakpoints
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
