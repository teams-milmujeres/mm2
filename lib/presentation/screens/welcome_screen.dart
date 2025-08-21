import 'package:flutter/material.dart';
// Bloc
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mm/presentation/bloc/staff/staff_bloc.dart';
import 'package:mm/presentation/bloc/locale/language_bloc.dart';
import 'package:mm/presentation/bloc/auth/auth_bloc.dart';
// Navigation
import 'package:go_router/go_router.dart';
import 'package:mm/presentation/navigation_options.dart';
// Entities
import 'package:mm/domain/entities/language_model.dart';
import 'package:mm/domain/entities/staff.dart';
// Localization
import 'package:mm/l10n/app_localizations.dart';
// Screens
import 'package:mm/presentation/screens.dart';
// Other imports
import 'package:mm/data/data.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:mm/widgets/circular_buitton.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StaffBloc()..add(StaffFetchEvent()),
      child: Scaffold(
        appBar: const CustomAppBar(),
        bottomNavigationBar: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final isLoggedIn = state is AuthAuthenticated;
            final translation = AppLocalizations.of(context)!;

            final destinations = <NavigationDestination>[
              const NavigationDestination(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              NavigationDestination(icon: Icon(Icons.menu), label: 'Menu'),
              if (isLoggedIn)
                NavigationDestination(
                  icon: Icon(Icons.design_services),
                  label: translation.services,
                ),
              isLoggedIn
                  ? NavigationDestination(
                    icon: Icon(Icons.person),
                    label: translation.profile,
                  )
                  : NavigationDestination(
                    icon: Icon(Icons.login),
                    label: translation.login,
                  ),
            ];

            // Corrige el índice en tiempo real para evitar excepciones cuando el índice es mayor que la cantidad de destinos
            final safeIndex =
                currentPageIndex < destinations.length ? currentPageIndex : 0;

            return NavigationBar(
              selectedIndex: safeIndex,
              onDestinationSelected: (index) {
                setState(() {
                  currentPageIndex = index;
                });
              },
              destinations: destinations,
            );
          },
        ),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final isLoggedIn = state is AuthAuthenticated;

            final pages = <Widget>[
              const HomePage(),
              const AboutPage(),
              if (isLoggedIn) const DashboardScreen(),
              isLoggedIn ? const ProfileScreen() : const LoginPage(),
            ];

            // Usa el mismo índice seguro para sincronizar con el NavigationBar
            final safeIndex =
                currentPageIndex < pages.length ? currentPageIndex : 0;

            return pages[safeIndex];
          },
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: Column(
            children: [
              ContainerAbout(),
              const SizedBox(height: 20),
              ContainerStaff(),
              const SizedBox(height: 20),
              ContainerSocialButtons(),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoggedIn = state is AuthAuthenticated;

        final List<Widget> options =
            navigationOptions
                .where((option) {
                  if (isLoggedIn) {
                    return ![
                      '/login',
                      '/register',
                      '/upload_document',
                      '/deposits',
                      '/caases_stage',
                    ].contains(option.route);
                  } else {
                    return [
                      // '/login',
                      // '/',
                      '/events',
                      '/mm_actions',
                      '/offices',
                      '/consulates',
                      '/contact_us',
                      '/donate',
                    ].contains(option.route);
                  }
                })
                .map(
                  (option) => _optionItem(
                    context,
                    option.icon,
                    option.labelBuilder(context),
                    option.description(context),
                    option.route,
                  ),
                )
                .toList();

        return ListView(children: [...options]);
      },
    );
  }

  Widget _optionItem(
    BuildContext context,
    IconData icon,
    String title,
    String description,
    String route,
  ) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
      subtitle: Text(
        description,
        style: Theme.of(context).textTheme.bodyMedium?.merge(
          TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      visualDensity: const VisualDensity(vertical: -1),
      onTap: () {
        context.push(route);
      },
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(image: AssetImage('assets/icon/icon.png'), height: 250),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.contact_to_request,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            CircularButton(
              text: AppLocalizations.of(context)!.login,
              press: () {
                context.pushNamed(
                  'login',
                ); // Navega a la pantalla de inicio de sesión
              },
            ),
            const SizedBox(height: 20),
            CircularButton(
              text: AppLocalizations.of(context)!.register,
              press: () {
                context.pushNamed(
                  'register',
                ); // Navega a la pantalla de registro
              },
            ),
            const SizedBox(height: 50),
            // ContainerSocialButtons(),
          ],
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      title: const Text('Mil Mujeres'),
      // leading: Builder(
      //   builder: (context) {
      //     return IconButton(
      //       icon: const Icon(Icons.menu),
      //       onPressed: () {
      //         Scaffold.of(context).openDrawer();
      //       },
      //     );
      //   },
      // ),
      bottom: PreferredSize(preferredSize: Size.zero, child: Container()),
      actions: [
        _CustomDropDownUnderlineWelcome(),
        IconButton(
          tooltip: AppLocalizations.of(context)!.donate,
          onPressed: () async {
            await UrlLauncherHelper.launchURL(
              url: 'https://givebutter.com/KI0Y2G',
            );
          },
          icon: const Icon(Icons.favorite),
        ),
        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              final initials = _getInitials(state.user.firstName);
              return _userAvatarWithMenu(initials, context);
            }

            return IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                context.pushNamed('login');
              },
            );
          },
        ),
      ],
    );
  }

  Widget _userAvatarWithMenu(String initials, BuildContext context) {
    final translation = AppLocalizations.of(context)!;
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'profile') {
          context.pushNamed('profile');
        } else if (value == 'logout') {
          context.read<AuthBloc>().add(LogoutRequested());
        }
      },
      itemBuilder:
          (_) => [
            PopupMenuItem(value: 'profile', child: Text(translation.profile)),
            PopupMenuItem(value: 'logout', child: Text(translation.logout)),
          ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Text(initials, style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final names = name.trim().split(' ');
    if (names.length == 1) return names.first[0].toUpperCase();
    return (names[0][0] + names[1][0]).toUpperCase();
  }
}

class _CustomDropDownUnderlineWelcome extends StatefulWidget {
  const _CustomDropDownUnderlineWelcome();

  @override
  State<_CustomDropDownUnderlineWelcome> createState() =>
      _CustomDropDownUnderlineWelcomeState();
}

class _CustomDropDownUnderlineWelcomeState
    extends State<_CustomDropDownUnderlineWelcome> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, state) {
          return DropdownButton<String>(
            value: state.selectedLanguage.value.languageCode,
            items: _buildLanguageItems(),
            onChanged: (String? value) {
              if (value != null &&
                  value != state.selectedLanguage.value.languageCode) {
                context.read<LanguageBloc>().add(
                  ChangeLanguage(
                    selectedLanguage: Language.values.firstWhere(
                      (lang) => lang.value.languageCode == value,
                    ),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }

  List<DropdownMenuItem<String>> _buildLanguageItems() {
    return Language.values.map((lang) {
      final languageCode = lang.value.languageCode.toUpperCase();
      final flagUrl = 'country_flag/$languageCode';
      final client = DioClient();

      return DropdownMenuItem(
        value: lang.value.languageCode,
        child: Row(
          children: [
            Image.network(
              client.buildImageUrl(flagUrl),
              width: 24,
              height: 16,
              errorBuilder: (_, __, ___) => const Icon(Icons.flag),
            ),
            const SizedBox(width: 10),
            Text(lang.text),
          ],
        ),
      );
    }).toList();
  }
}

class ContainerAbout extends StatelessWidget {
  const ContainerAbout({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(100.0),
      child: Center(
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: const AssetImage('assets/icon/icon.png'),
              radius: 80,
            ),
            Text(
              AppLocalizations.of(context)!.mm_description,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            CircularButton(
              icon: Icons.info_outline,
              text: AppLocalizations.of(context)!.contact_us,
              press: () => context.push('/contact_us'),
            ),
          ],
        ),
      ),
    );
  }
}

class ContainerDonate extends StatelessWidget {
  const ContainerDonate({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: const EdgeInsets.all(30),
        color: Theme.of(context).colorScheme.primary, // Set primary color
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.mm_donate_txt,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.white),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(
                Icons.favorite,
                color: Theme.of(context).colorScheme.primary,
              ),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              onPressed: () async {
                await UrlLauncherHelper.launchURL(
                  url: 'https://givebutter.com/KI0Y2G',
                );
              },
              label: Text(
                AppLocalizations.of(context)!.donate,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContainerStaff extends StatefulWidget {
  const ContainerStaff({super.key});

  @override
  State<ContainerStaff> createState() => _ContainerStaffState();
}

class _ContainerStaffState extends State<ContainerStaff> {
  @override
  Widget build(BuildContext context) {
    final translation = AppLocalizations.of(context)!;

    return BlocBuilder<StaffBloc, StaffState>(
      builder: (context, state) {
        switch (state.runtimeType) {
          case const (StaffInitial):
          case const (StaffLoading):
            return const Center(child: CircularProgressIndicator());

          case const (StaffSuccess):
            final staff = (state as StaffSuccess).staff;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTeamSection(
                    context,
                    translation.executive_team,
                    staff.executiveTeam,
                  ),
                  _buildTeamSection(
                    context,
                    translation.legal_team,
                    staff.legalTeam,
                  ),
                ],
              ),
            );

          case const (StaffError):
            final error = (state as StaffError).errorMessage;
            return Center(child: Text('Error: $error'));

          default:
            return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildTeamSection(
    BuildContext context,
    String title,
    List<StaffMember> team,
  ) {
    final isSmallScreen = MediaQuery.of(context).size.width < 400;
    final double avatarRadius = isSmallScreen ? 40 : 60;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        ResponsiveGridRow(
          children: [
            for (int i = 0; i < team.length; i++) ...[
              ResponsiveGridCol(
                xs:
                    team[i].staffOrder == 0
                        ? 12
                        : (i == (team.length - 1) && i % 2 != 0)
                        ? 12
                        : 6,
                sm:
                    team[i].staffOrder == 0
                        ? 12
                        : (i == (team.length - 1) && i % 2 != 0)
                        ? 12
                        : 6,
                md:
                    team[i].staffOrder == 0
                        ? 12
                        : (i == (team.length - 1) && i % 2 != 0)
                        ? 12
                        : 6,
                child: _buildStaffItem(context, team[i], avatarRadius),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildStaffItem(
    BuildContext context,
    StaffMember member,
    double avatarRadius,
  ) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          CircleAvatar(
            radius: avatarRadius,
            backgroundColor: Theme.of(context).colorScheme.primary,
            backgroundImage:
                member.imageUrl != null ? NetworkImage(member.imageUrl!) : null,
            child:
                member.imageUrl == null
                    ? Icon(
                      Icons.person_outline,
                      size: avatarRadius * 0.8,
                      color: Colors.white,
                    )
                    : null,
          ),
          const SizedBox(height: 10),
          Text(
            member.name,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            _getTranslatedRole(member.role, context),
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Función auxiliar para traducir los roles
  static String _getTranslatedRole(String role, BuildContext context) {
    final translation = AppLocalizations.of(context)!;
    switch (role) {
      case 'executive_director':
        return translation.executive_director;
      case 'national_deputy_director':
        return translation.national_deputy_director;
      case 'financial_manager':
        return translation.financial_manager;
      case 'human_resources_manager':
        return translation.human_resources_manager;
      case 'information_technology_coordinator':
        return translation.information_technology_coordinator;
      case 'public_relations_coordinator':
        return translation.public_relations_coordinator;
      case 'corporate_communications_coordinator':
        return translation.corporate_communications_coordinator;
      case 'legal_director':
        return translation.legal_director;
      case 'senior_attorney':
        return translation.senior_attorney;
      default:
        return "";
    }
  }
}

class ContainerSocialButtons extends StatelessWidget {
  const ContainerSocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final translation = AppLocalizations.of(context)!;

    final socialButtons = [
      _SocialButtonData(
        url: 'https://www.facebook.com/milmujeres.org/',
        icon: FontAwesomeIcons.facebookF,
      ),
      _SocialButtonData(
        url: 'https://twitter.com/milmujeres',
        icon: FontAwesomeIcons.twitter,
      ),
      _SocialButtonData(
        url: 'https://www.instagram.com/milmujeres/?hl=en',
        icon: FontAwesomeIcons.instagram,
      ),
      _SocialButtonData(
        url: 'https://www.youtube.com/channel/UCL8B6nm7i4nKMUNZ-AL77Vw',
        icon: FontAwesomeIcons.youtube,
      ),
      _SocialButtonData(
        url: 'https://www.milmujeres.org/',
        icon: FontAwesomeIcons.earthAmericas,
      ),
      _SocialButtonData(
        url: 'https://www.tiktok.com/@milmujeres?_t=8fUmrHYkLSQ&_r=1',
        icon: FontAwesomeIcons.tiktok,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              translation.follow_us,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  socialButtons
                      .map((button) => _buildSocialButton(context, button))
                      .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton(BuildContext context, _SocialButtonData button) {
    return Expanded(
      flex: 1,
      child: IconButton(
        icon: FaIcon(
          button.icon,
          color: Theme.of(context).colorScheme.primary,
          size: 25,
        ),
        onPressed: () => UrlLauncherHelper.launchURL(url: button.url),
        style: ElevatedButton.styleFrom(
          // foregroundColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Colors.white,
          shape: const CircleBorder(),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }
}

class _SocialButtonData {
  final String url;
  final IconData icon;

  _SocialButtonData({required this.url, required this.icon});
}

class ContainerFooter extends StatelessWidget {
  const ContainerFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Mil Mujeres',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '© ${DateTime.now().year} Mil Mujeres. All rights reserved.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
