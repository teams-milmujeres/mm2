import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
      pageBuilder: (context, state) => buildPageTransition(const LoginScreen()),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      pageBuilder:
          (context, state) => buildPageTransition(const RegisterScreen()),
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      pageBuilder:
          (context, state) => buildPageTransition(const ProfileScreen()),
    ),
    GoRoute(
      path: '/offices',
      name: 'offices',
      // builder: (context, state) => const OfficeScreen(),
      pageBuilder:
          (context, state) => buildPageTransition(const OfficeScreen()),
    ),
    GoRoute(
      path: '/contact_us',
      name: 'contact_us',
      // builder: (context, state) => const ContactUsScreen(),
      pageBuilder:
          (context, state) => buildPageTransition(const ContactUsScreen()),
    ),
    GoRoute(
      path: '/donate',
      name: 'donate',
      // builder: (context, state) => const DonateScreen(),
      pageBuilder:
          (context, state) => buildPageTransition(const DonateScreen()),
    ),
    GoRoute(
      path: '/consulates',
      name: 'consulates',
      // builder: (context, state) => const ConsulateScreen(),
      pageBuilder:
          (context, state) =>
              buildPageTransition(const ConsulateOfficeScreen()),
    ),
    GoRoute(
      path: '/references',
      name: 'references',
      // builder: (context, state) => const ReferenceScreen(),
      pageBuilder:
          (context, state) => buildPageTransition(const ReferenceScreen()),
    ),
    GoRoute(
      path: '/complaints',
      name: 'complaints',
      // builder: (context, state) => const ComplaintScreen(),
      pageBuilder:
          (context, state) => buildPageTransition(const ComplaintsScreen()),
    ),
    GoRoute(
      path: '/suggestions',
      name: 'suggestions',
      // builder: (context, state) => const SuggestionScreen(),
      pageBuilder:
          (context, state) => buildPageTransition(const SuggestionScreen()),
    ),
    GoRoute(
      path: '/grievances',
      name: 'grievances',
      // builder: (context, state) => const GrievanceScreen(),
      pageBuilder:
          (context, state) => buildPageTransition(const GrievanceScreen()),
    ),
    GoRoute(
      path: '/password_recovery',
      name: 'password_recovery',
      // builder: (context, state) => const PasswordRecoveryScreen(),
      pageBuilder:
          (context, state) =>
              buildPageTransition(const PasswordRecoveryScreen()),
    ),
    GoRoute(
      path: '/deposits',
      name: 'deposits',
      // builder: (context, state) => const DepositScreen(),
      pageBuilder:
          (context, state) => buildPageTransition(const DepositScreen()),
    ),
    GoRoute(
      path: '/caases_stage',
      name: 'caases_stage',
      // builder: (context, state) => const CaseStageScreen(),
      pageBuilder:
          (context, state) => buildPageTransition(const CaseStageScreen()),
    ),
    GoRoute(
      path: '/events',
      name: 'events',
      // builder: (context, state) => const EventScreen(),
      pageBuilder: (context, state) => buildPageTransition(const EventScreen()),
    ),
    GoRoute(
      path: '/upload_document',
      name: 'upload_document',
      // builder: (context, state) => const UploadDocumentScreen(),
      pageBuilder:
          (context, state) => buildPageTransition(const UploadDocumentScreen()),
    ),
    GoRoute(
      path: '/mm_actions',
      name: 'mm_actions',
      // builder: (context, state) => const DocumentScreen(),
      pageBuilder:
          (context, state) => buildPageTransition(const MMActionsScreen()),
    ),
  ],
);

CustomTransitionPage buildPageTransition(Widget child) {
  return CustomTransitionPage(
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}
