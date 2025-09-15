import 'package:flutter/material.dart';
import 'package:mm/l10n/app_localizations.dart';

class NavigationOption {
  final String route;
  final IconData icon;
  final String Function(BuildContext context) labelBuilder;
  final String Function(BuildContext context) description;

  NavigationOption({
    required this.route,
    required this.icon,
    required this.labelBuilder,
    required this.description,
  });
}

final List<NavigationOption> navigationOptions = [
  // NavigationOption(
  //   route: '/',
  //   icon: Icons.home,
  //   labelBuilder: (context) => 'Inicio',
  //   description: (context) => AppLocalizations.of(context)!.homeDescription,
  // ),
  // NavigationOption(
  //   route: '/login',
  //   icon: Icons.login,
  //   labelBuilder: (context) => AppLocalizations.of(context)!.login,
  //   description: (context) => AppLocalizations.of(context)!.loginDescription,
  // ),
  // NavigationOption(
  //   route: '/dashboard',
  //   icon: Icons.dashboard,
  //   labelBuilder: (context) => AppLocalizations.of(context)!.dashboard,
  //   description:
  //       (context) => AppLocalizations.of(context)!.dashboardDescription,
  // ),
  NavigationOption(
    route: '/profile',
    icon: Icons.person,
    labelBuilder: (context) => AppLocalizations.of(context)!.profile,
    description: (context) => AppLocalizations.of(context)!.profileDescription,
  ),
  NavigationOption(
    route: '/events',
    icon: Icons.event,
    labelBuilder: (context) => AppLocalizations.of(context)!.events,
    description: (context) => AppLocalizations.of(context)!.eventsDescription,
  ),
  NavigationOption(
    route: '/mm_actions',
    icon: Icons.pan_tool,
    labelBuilder: (context) => 'MM en Acción',
    description:
        (context) => AppLocalizations.of(context)!.mm_actionsDescription,
  ),
  NavigationOption(
    route: '/upload_document',
    icon: Icons.upload_file,
    labelBuilder: (context) => AppLocalizations.of(context)!.upload_file,
    description:
        (context) => AppLocalizations.of(context)!.upload_fileDescription,
  ),
  NavigationOption(
    route: '/offices',
    icon: Icons.location_city,
    labelBuilder: (context) => AppLocalizations.of(context)!.offices,
    description: (context) => AppLocalizations.of(context)!.officesDescription,
  ),
  NavigationOption(
    route: '/consulates',
    icon: Icons.flag,
    labelBuilder: (context) => AppLocalizations.of(context)!.consulates,
    description:
        (context) => AppLocalizations.of(context)!.consulatesDescription,
  ),
  NavigationOption(
    route: '/references',
    icon: Icons.handshake_outlined,
    labelBuilder:
        (context) => AppLocalizations.of(context)!.alliances_references,
    description:
        (context) =>
            AppLocalizations.of(context)!.alliances_referencesDescription,
  ),
  NavigationOption(
    route: '/deposits',
    icon: Icons.payments,
    labelBuilder: (context) => AppLocalizations.of(context)!.payments_refunds,
    description:
        (context) => AppLocalizations.of(context)!.deposits_refundsDescription,
  ),
  NavigationOption(
    route: '/caases_stage',
    icon: Icons.turn_right,
    labelBuilder: (context) => AppLocalizations.of(context)!.caases_stage,
    description:
        (context) => AppLocalizations.of(context)!.caases_stageDescription,
  ),
  NavigationOption(
    route: '/donate',
    icon: Icons.favorite,
    labelBuilder: (context) => AppLocalizations.of(context)!.donate,
    description: (context) => AppLocalizations.of(context)!.donateDescription,
  ),
  NavigationOption(
    route: '/contact_us',
    icon: Icons.chat_bubble_outline,
    labelBuilder: (context) => AppLocalizations.of(context)!.contact_us,
    description:
        (context) => AppLocalizations.of(context)!.contact_usDescription,
  ),
  NavigationOption(
    route: '/complaints',
    icon: Icons.report,
    labelBuilder: (context) => AppLocalizations.of(context)!.complaints,
    description:
        (context) => AppLocalizations.of(context)!.complaintsDescription,
  ),
  NavigationOption(
    route: '/rating',
    icon: Icons.star,
    labelBuilder: (context) => AppLocalizations.of(context)!.rating,
    description: (context) => AppLocalizations.of(context)!.ratingDescription,
  ),
];
