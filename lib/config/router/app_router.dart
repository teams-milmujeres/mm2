import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:milmujeres_app/presentation/bloc/auth/auth_bloc.dart';

// Screens
import 'package:milmujeres_app/presentation/screens.dart';

GoRouter onBoardingRouter(BuildContext context) => GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      name: 'dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder:
          (context, state) => BlocProvider(
            create: (_) => AuthBloc(),
            child: const LoginScreen(),
          ),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/offices',
      name: 'offices',
      builder: (context, state) => const OfficeScreen(),
    ),
    GoRoute(
      path: '/contact_us',
      name: 'contact_us',
      builder: (context, state) => const ContactUsScreen(),
    ),
    GoRoute(
      path: '/donate',
      name: 'donate',
      builder: (context, state) => const DonateScreen(),
    ),
    GoRoute(
      path: '/consulates',
      name: 'consulates',
      builder: (context, state) => const ConsulateScreen(),
    ),
    GoRoute(
      path: '/references',
      name: 'references',
      builder: (context, state) => const ReferenceScreen(),
    ),
    GoRoute(
      path: '/complaints',
      name: 'complaints',
      builder: (context, state) => const ComplaintScreen(),
    ),
    GoRoute(
      path: '/suggestions',
      name: 'suggestions',
      builder: (context, state) => const SuggestionScreen(),
    ),
    GoRoute(
      path: '/grievances',
      name: 'grievances',
      builder: (context, state) => const GrievanceScreen(),
    ),
    GoRoute(
      path: '/password_recovery',
      name: 'password_recovery',
      builder: (context, state) => const PasswordRecoveryScreen(),
    ),
    GoRoute(
      path: '/deposits',
      name: 'deposits',
      builder: (context, state) => const DepositScreen(),
    ),
    GoRoute(
      path: '/caases_stage',
      name: 'caases_stage',
      builder: (context, state) => const CaseStageScreen(),
    ),
    GoRoute(
      path: '/events',
      name: 'events',
      builder: (context, state) => const EventScreen(),
    ),
    GoRoute(
      path: '/upload_document',
      name: 'upload_document',
      builder: (context, state) => const UploadDocumentScreen(),
    ),
  ],
);
