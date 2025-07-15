import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// Navigation Options
import 'package:milmujeres_app/presentation/navigation_options.dart';
// Bloc
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:milmujeres_app/presentation/bloc/auth/auth_bloc.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
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
                ...navigationOptions
                    .where(
                      (option) =>
                          option.route != '/login' &&
                          option.route != '/register',
                    )
                    .map(
                      (option) => _drawerItem(
                        context,
                        option.icon,
                        option.labelBuilder(context),
                        option.route,
                      ),
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
              ...navigationOptions
                  .where(
                    (opt) => [
                      '/login',
                      '/',
                      '/events',
                      '/offices',
                      '/consulates',
                      '/contact_us',
                      '/donate',
                    ].contains(opt.route),
                  )
                  .map(
                    (option) => _drawerItem(
                      context,
                      option.icon,
                      option.labelBuilder(context),
                      option.route,
                    ),
                  ),
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
