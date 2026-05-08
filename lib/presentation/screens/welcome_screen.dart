import 'package:flutter/material.dart';
// Bloc
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mm/data/testimonials_data.dart';
import 'package:mm/domain/entities/testimonial.dart';
import 'package:mm/presentation/bloc/notifications/notifications_bloc.dart';
import 'package:mm/presentation/bloc/staff/staff_bloc.dart';
import 'package:mm/presentation/bloc/locale/language_bloc.dart';
import 'package:mm/presentation/bloc/auth/auth_bloc.dart';
// Navigation
import 'package:go_router/go_router.dart';
import 'package:mm/presentation/bloc/theme/theme_bloc.dart';
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

import 'package:mm/widgets/widgets.dart';

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
              // isLoggedIn
              //     ? NavigationDestination(
              //       icon: Icon(Icons.person),
              //       label: translation.profile,
              //     )
              //     : NavigationDestination(
              //       icon: Icon(Icons.login),
              //       label: translation.login,
              //     ),
              if (isLoggedIn)
                NavigationDestination(
                  icon: Icon(Icons.person),
                  label: translation.profile,
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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ContainerBanner(),
            ContainerAbout(),
            const SizedBox(height: 20),
            ContainerTestimonials(),
            const SizedBox(height: 20),
            ContainerStaff(),
            const SizedBox(height: 20),
            ContainerSocialButtons(),
            const SizedBox(height: 20),
            const ContainerFooter(),
          ],
        ),
      ),
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
                      '/grants',
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
      // title: const Text('Mil Mujeres'),
      title: Image.asset('assets/images/milmujeres-logo.png', height: 40),
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
        BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            return IconButton(
              icon: Icon(
                state.themeMode == ThemeMode.dark
                    ? Icons.light_mode
                    : Icons.dark_mode,
              ),
              onPressed: () => context.read<ThemeBloc>().add(ToggleTheme()),
            );
          },
        ),
        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            if (authState is AuthAuthenticated) {
              return IconButton(
                tooltip: AppLocalizations.of(context)!.notifications,
                onPressed: () {
                  context.read<NotificationBloc>().add(
                    ClearNotificationsEvent(),
                  );
                  context.pushNamed('notifications');
                },
                icon: BlocBuilder<NotificationBloc, NotificationState>(
                  builder: (context, state) {
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Icon(Icons.notifications),
                        if (state.hasNewNotification)
                          Positioned(
                            right: 4,
                            top: 4,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),

        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              final initials = _getInitials(state.user.firstName);
              return _userAvatarWithMenu(initials, context);
            }

            return IconButton(
              icon: const Icon(FontAwesomeIcons.circleUser),
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
          context.read<NotificationBloc>().add(StopNotificationsEvent());
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

class ContainerBanner extends StatelessWidget {
  const ContainerBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Image.asset(
          'assets/images/banner.png',
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class ContainerAbout extends StatelessWidget {
  const ContainerAbout({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: SizedBox(
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                // height: 400,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: AppLocalizations.of(context)!.mm_welcome,
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.normal,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              TextSpan(
                                text: ' Mil Mujeres',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          AppLocalizations.of(context)!.mm_description,
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 30),
                        // RoundedButtonLarge(
                        //   text: AppLocalizations.of(context)!.contact_us,
                        //   icon: Icons.info_outline,
                        //   press: () => context.push('/contact_us'),
                        // ),
                        RoundedButton(
                          text: AppLocalizations.of(context)!.login,
                          press: () => context.pushNamed('login'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContainerTestimonials extends StatelessWidget {
  const ContainerTestimonials({super.key});

  List<Testimonial> _getData() {
    return testimonialsData.map((e) => Testimonial.fromMap(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final data = _getData();
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Title
          Text('Testimonios', style: theme.textTheme.titleLarge),
          const SizedBox(height: 20),

          // Cards
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: data.map((t) => _card(context, t)).toList(),
          ),

          const SizedBox(height: 30),

          // Button
          RoundedButton(
            text: AppLocalizations.of(context)!.contact_us,
            press: () => context.push('/contact_us'),
          ),
        ],
      ),
    );
  }

  Widget _card(BuildContext context, Testimonial t) {
    final theme = Theme.of(context);

    return Container(
      width: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(blurRadius: 8, color: Colors.black.withAlpha(13)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 Header (avatar + name)
          Row(
            children: [
              _avatar(t.name),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(t.location, style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// 🔹 Estrellas
          Row(
            children: List.generate(
              t.stars,
              (index) => const Icon(Icons.star, size: 16),
            ),
          ),

          const SizedBox(height: 10),

          /// 🔹 Texto
          Text(t.testimonial, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }

  /// Avatar con iniciales
  Widget _avatar(String name) {
    final initials = _getInitials(name);

    return CircleAvatar(
      radius: 22,
      child: Text(
        initials,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  // Obtener iniciales
  String _getInitials(String name) {
    final parts = name.trim().split(' ');

    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }

    return (parts[0][0] + parts[1][0]).toUpperCase();
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
        color: Theme.of(context).colorScheme.primary,
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
                    isExecutive: true,
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
    List<StaffMember> team, {
    bool isExecutive = false,
  }) {
    final isSmallScreen = MediaQuery.of(context).size.width < 400;
    final double avatarRadius = isSmallScreen ? 40 : 60;

    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        color: colorScheme.secondaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSecondaryContainer,
                ),
              ),
              const SizedBox(height: 20),

              LayoutBuilder(
                builder: (context, constraints) {
                  final double maxWidth = constraints.maxWidth;

                  const double spacing = 24;
                  final double twoPerRowWidth = (maxWidth - spacing) / 2;

                  return Wrap(
                    alignment: WrapAlignment.center,
                    spacing: spacing,
                    runSpacing: spacing,
                    children: List.generate(team.length, (index) {
                      double itemWidth;

                      if (isExecutive && index == 0) {
                        itemWidth = maxWidth;
                      } else {
                        itemWidth = twoPerRowWidth;
                      }

                      return SizedBox(
                        width: itemWidth,
                        child: _buildStaffItem(
                          context,
                          team[index],
                          avatarRadius,
                        ),
                      );
                    }),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStaffItem(
    BuildContext context,
    StaffMember member,
    double avatarRadius,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          CircleAvatar(
            radius: avatarRadius,
            backgroundColor: colorScheme.primary,
            backgroundImage:
                member.imageUrl != null ? NetworkImage(member.imageUrl!) : null,
            child:
                member.imageUrl == null
                    ? Icon(
                      Icons.person_outline,
                      size: avatarRadius * 0.8,
                      color: colorScheme.onPrimary,
                    )
                    : null,
          ),
          const SizedBox(height: 10),
          Text(
            member.name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: colorScheme.onSecondaryContainer,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            _getTranslatedRole(member.role, context),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSecondaryContainer,
            ),
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
        url: 'https://www.tiktok.com/@milmujeres',
        icon: FontAwesomeIcons.tiktok,
      ),
      _SocialButtonData(
        url:
            'https://www.linkedin.com/company/milmujeres-legalservices/posts/?feedView=all',
        icon: FontAwesomeIcons.linkedin,
      ),
      _SocialButtonData(
        url:
            'https://open.spotify.com/show/3yWmZqImkITDFSvmiumeoJ?si=f949522f5ce64281&nd=1&dlsi=f2327a8c16984488',
        icon: FontAwesomeIcons.spotify,
      ),
      _SocialButtonData(
        url:
            'https://api.whatsapp.com/send/?phone=13013564725&text&type=phone_number&app_absent=0',
        icon: FontAwesomeIcons.whatsapp,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: double.infinity),
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 50),
                  Text(
                    translation.follow_us,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: socialButtons.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                          childAspectRatio: 1.2,
                        ),
                    itemBuilder: (context, index) {
                      return _AnimatedSocialButton(
                        button: socialButtons[index],
                      );
                    },
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedSocialButton extends StatefulWidget {
  final _SocialButtonData button;

  const _AnimatedSocialButton({required this.button});

  @override
  State<_AnimatedSocialButton> createState() => _AnimatedSocialButtonState();
}

class _AnimatedSocialButtonState extends State<_AnimatedSocialButton> {
  bool isPressed = false;

  void _onTapDown(_) => setState(() => isPressed = true);
  void _onTapUp(_) => setState(() => isPressed = false);
  void _onTapCancel() => setState(() => isPressed = false);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => UrlLauncherHelper.launchURL(url: widget.button.url),
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,

      child: AnimatedSize(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,

        child: AnimatedScale(
          scale: isPressed ? 0.92 : 1.0,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,

          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,

            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                if (!isPressed)
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),

            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap:
                    () => UrlLauncherHelper.launchURL(url: widget.button.url),

                child: Center(
                  child: FaIcon(
                    widget.button.icon,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
          ),
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
    final theme = Theme.of(context);
    final translation = AppLocalizations.of(context)!;

    return Container(
      color: theme.colorScheme.surface,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600), // 🔥 clave
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '© ${DateTime.now().year} Mil Mujeres Legal Services.\nAll Right Reserved,',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),

              const SizedBox(height: 30),

              // Divider(color: theme.dividerColor, thickness: 1),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Organización
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        translation.organization,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),
                      _item(
                        translation.contact_us,
                        () => context.push('/contact_us'),
                      ),
                      _item(translation.donate, () => context.push('/donate')),
                      _item(
                        translation.offices,
                        () => context.push('/offices'),
                      ),
                      _item(
                        translation.consulates,
                        () => context.push('/consulates'),
                      ),
                    ],
                  ),

                  /// Redes
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        translation.follow_us,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),
                      _item(
                        'Facebook',
                        () => UrlLauncherHelper.launchURL(
                          url: 'https://www.facebook.com/milmujeres.org/',
                        ),
                      ),
                      _item(
                        'Instagram',
                        () => UrlLauncherHelper.launchURL(
                          url: 'https://www.instagram.com/milmujeres/?hl=en',
                        ),
                      ),
                      _item(
                        'Twitter',
                        () => UrlLauncherHelper.launchURL(
                          url: 'https://twitter.com/milmujeres',
                        ),
                      ),
                      _item(
                        'YouTube',
                        () => UrlLauncherHelper.launchURL(
                          url:
                              'https://www.youtube.com/channel/UCL8B6nm7i4nKMUNZ-AL77Vw',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(String text, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: GestureDetector(onTap: onTap, child: Text(text)),
    );
  }
}
