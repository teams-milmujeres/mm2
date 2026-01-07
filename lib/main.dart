import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mm/config/config.dart';
import 'package:mm/l10n/app_localizations.dart';
import 'package:mm/presentation/bloc/auth/auth_bloc.dart';
import 'package:mm/presentation/bloc/locale/language_bloc.dart';
import 'package:mm/presentation/bloc/theme/theme_bloc.dart';
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
        BlocProvider<ThemeBloc>(create: (_) => ThemeBloc()),
      ],
      child: const MaterialAppWidget(),
    );
  }
}

class MaterialAppWidget extends StatelessWidget {
  const MaterialAppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LanguageBloc>(create: (_) => LanguageBloc()),
        BlocProvider<ThemeBloc>(create: (_) => ThemeBloc()..add(LoadTheme())),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return BlocBuilder<LanguageBloc, LanguageState>(
            builder: (context, languageState) {
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                theme: AppTheme().lightTheme,
                darkTheme: AppTheme().darkTheme,
                themeMode: themeState.themeMode,
                locale: languageState.selectedLanguage.value,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                routerConfig: onBoardingRouter(context),
                builder:
                    (context, widget) => ResponsiveBreakpoints.builder(
                      child: widget!,
                      breakpoints: const [
                        Breakpoint(start: 0, end: 450, name: MOBILE),
                        Breakpoint(start: 451, end: 800, name: TABLET),
                        Breakpoint(start: 801, end: 1200, name: DESKTOP),
                        Breakpoint(start: 1201, end: 2460, name: DESKTOP),
                        Breakpoint(
                          start: 2461,
                          end: double.infinity,
                          name: "4K",
                        ),
                      ],
                    ),
              );
            },
          );
        },
      ),
    );
  }
}
