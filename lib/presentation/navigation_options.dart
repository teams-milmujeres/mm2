import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NavigationOption {
  final String route;
  final IconData icon;
  final String Function(BuildContext context) labelBuilder;

  NavigationOption({
    required this.route,
    required this.icon,
    required this.labelBuilder,
  });
}

final List<NavigationOption> navigationOptions = [
  NavigationOption(
    route: '/',
    icon: Icons.home,
    labelBuilder: (context) => 'Inicio',
  ),
  NavigationOption(
    route: '/login',
    icon: Icons.login,
    labelBuilder: (context) => AppLocalizations.of(context)!.login,
  ),
  NavigationOption(
    route: '/dashboard',
    icon: Icons.dashboard,
    labelBuilder: (context) => AppLocalizations.of(context)!.dashboard,
  ),
  NavigationOption(
    route: '/profile',
    icon: Icons.person,
    labelBuilder: (context) => AppLocalizations.of(context)!.profile,
  ),
  NavigationOption(
    route: '/events',
    icon: Icons.event,
    labelBuilder: (context) => AppLocalizations.of(context)!.events,
  ),
  NavigationOption(
    route: '/upload_document',
    icon: Icons.upload_file,
    labelBuilder: (context) => AppLocalizations.of(context)!.upload_file,
  ),
  NavigationOption(
    route: '/offices',
    icon: Icons.location_city,
    labelBuilder: (context) => AppLocalizations.of(context)!.offices,
  ),
  NavigationOption(
    route: '/consulates',
    icon: Icons.flag,
    labelBuilder: (context) => AppLocalizations.of(context)!.consulates,
  ),
  NavigationOption(
    route: '/references',
    icon: Icons.handshake_outlined,
    labelBuilder:
        (context) => AppLocalizations.of(context)!.alliances_references,
  ),
  NavigationOption(
    route: '/contact_us',
    icon: Icons.chat_bubble_outline,
    labelBuilder: (context) => AppLocalizations.of(context)!.contact_us,
  ),
  NavigationOption(
    route: '/donate',
    icon: Icons.favorite,
    labelBuilder: (context) => AppLocalizations.of(context)!.donate,
  ),
  NavigationOption(
    route: '/complaints',
    icon: Icons.report,
    labelBuilder: (context) => AppLocalizations.of(context)!.complaints,
  ),
  NavigationOption(
    route: '/suggestions',
    icon: Icons.lightbulb,
    labelBuilder: (context) => AppLocalizations.of(context)!.suggestions,
  ),
  // NavigationOption(
  //   route: '/grievances',
  //   icon: Icons.warning,
  //   labelBuilder: (context) => AppLocalizations.of(context)!.grievances,
  // ),
  NavigationOption(
    route: '/deposits',
    icon: Icons.payments,
    labelBuilder: (context) => AppLocalizations.of(context)!.deposits_refunds,
  ),
  NavigationOption(
    route: '/caases_stage',
    icon: Icons.turn_right,
    labelBuilder: (context) => AppLocalizations.of(context)!.caases_stage,
  ),
];
