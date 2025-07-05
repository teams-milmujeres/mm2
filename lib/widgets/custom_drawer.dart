import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// Bloc
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:milmujeres_app/presentation/bloc/auth/auth_bloc.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final translation = AppLocalizations.of(context)!;
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Text(
                    '${state.user.firstName} ${state.user.lastName}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 24,
                    ),
                  ),
                ),
                _drawerItem(context, Icons.home, 'Inicio', '/'),
                _drawerItem(
                  context,
                  Icons.dashboard,
                  translation.dashboard,
                  '/dashboard',
                ),
                _drawerItem(
                  context,
                  Icons.person,
                  translation.profile,
                  '/profile',
                ),
                _drawerItem(
                  context,
                  Icons.event,
                  translation.events,
                  '/events',
                ),
                _drawerItem(
                  context,
                  Icons.upload_file,
                  translation.upload_file,
                  '/upload_document',
                ),
                _drawerItem(
                  context,
                  Icons.location_city,
                  translation.offices,
                  '/offices',
                ),
                _drawerItem(
                  context,
                  Icons.flag,
                  translation.consulates,
                  '/consulates',
                ),
                _drawerItem(
                  context,
                  Icons.book,
                  translation.references,
                  '/references',
                ),
                _drawerItem(
                  context,
                  Icons.contact_mail,
                  translation.contact_us,
                  '/contact_us',
                ),
                _drawerItem(
                  context,
                  Icons.favorite,
                  translation.donate,
                  '/donate',
                ),

                _drawerItem(
                  context,
                  Icons.report,
                  translation.complaint,
                  '/complaints',
                ),
                _drawerItem(
                  context,
                  Icons.lightbulb,
                  translation.suggestions,
                  '/suggestions',
                ),
                _drawerItem(
                  context,
                  Icons.warning,
                  translation.grievances,
                  '/grievances',
                ),
                _drawerItem(
                  context,
                  Icons.account_balance_wallet,
                  translation.deposits_refunds,
                  '/deposits',
                ),
                _drawerItem(
                  context,
                  Icons.folder,
                  translation.caases_stage,
                  '/caases_stage',
                ),
              ],
            ),
          );
        }

        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: Text(
                  'Menú',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 24,
                  ),
                ),
              ),
              _drawerItem(context, Icons.home, 'Inicio', '/'),
              _drawerItem(context, Icons.login, translation.login, '/login'),
              // _drawerItem(
              //   context,
              //   Icons.app_registration,
              //   translation.register,
              //   '/register',
              // ),
              _drawerItem(context, Icons.event, translation.events, '/events'),
              _drawerItem(
                context,
                Icons.location_city,
                translation.offices,
                '/offices',
              ),
              _drawerItem(
                context,
                Icons.flag,
                translation.consulates,
                '/consulates',
              ),
              _drawerItem(
                context,
                Icons.contact_mail,
                translation.contact_us,
                '/contact_us',
              ),
              _drawerItem(
                context,
                Icons.favorite,
                translation.donate,
                '/donate',
              ),

              _drawerItem(
                context,
                Icons.report,
                translation.complaints,
                '/complaints',
              ),
              // _drawerItem(
              //   context,
              //   Icons.lock_reset,
              //   translation.password_recovery,
              //   '/password_recovery',
              // ),
            ],
          ),
        );
      },
    );
  }

  Widget _drawerItem(
    BuildContext context,
    IconData icon,
    String title,
    String route,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
      onTap: () {
        context.push(route);
        Navigator.of(context).pop(); // Cierra el drawer al navegar
      },
    );
  }
}
