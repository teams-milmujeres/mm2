// import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:milmujeres_app/data/helpers/launch_url.dart';
import 'package:milmujeres_app/domain/entities/language_model.dart';
import 'package:milmujeres_app/domain/entities/staff.dart';
import 'package:milmujeres_app/presentation/bloc/locale/language_bloc.dart';
import 'package:milmujeres_app/widgets/widgets.dart';
// import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:milmujeres_app/presentation/bloc/staff/staff_bloc.dart';
import 'package:responsive_grid/responsive_grid.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: CustomAppBar(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
              children: [
                ContainerAbout(),
                const SizedBox(height: 20),
                ContainerDonate(),
                const SizedBox(height: 20),
                ContainerStaff(),
                const SizedBox(height: 20),
                ContainerSocialButtons(),
                const SizedBox(height: 20),
                const ContainerFooter(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  const CustomAppBar({super.key})
    : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  String selectedLocale = "en"; // Idioma predeterminado

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      title: Text('Mil Mujeres'),
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
      bottom: PreferredSize(preferredSize: Size.zero, child: Container()),
      actions: [
        _CustomDropDownUnderlineWelcome(),
        IconButton(
          onPressed: () async {
            await UrlLauncherHelper.launchURL(
              url: 'https://givebutter.com/KI0Y2G',
            );
          },
          icon: const Icon(Icons.favorite),
        ),
        IconButton(
          icon: const Icon(Icons.person),
          onPressed: () {
            context.pushNamed('login');
          },
        ),
      ],
    );
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
      final flagUrl = 'http://127.0.0.1:8000/api/country_flag/$languageCode';

      return DropdownMenuItem(
        value: lang.value.languageCode,
        child: Row(
          children: [
            Image.network(
              flagUrl,
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
            Text(
              AppLocalizations.of(context)!.mm_about_txt,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.contact_page, color: Colors.white),
              onPressed: () {},
              label: Text(
                AppLocalizations.of(context)!.contact_us,
                style: Theme.of(context).textTheme.labelLarge,
              ),
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

class ContainerStaff extends StatelessWidget {
  const ContainerStaff({super.key});

  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context)!;

    return BlocBuilder<StaffBloc, StaffState>(
      bloc: StaffBloc()..add(StaffFetchEvent()),
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
                    translate.executive_team,
                    staff.executiveTeam,
                  ),
                  _buildTeamSection(
                    context,
                    translate.legal_team,
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
            style: Theme.of(context).textTheme.headlineLarge,
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
    final translate = AppLocalizations.of(context)!;
    switch (role) {
      case 'executive_director':
        return translate.executive_director;
      case 'national_deputy_director':
        return translate.national_deputy_director;
      case 'financial_manager':
        return translate.financial_manager;
      case 'human_resources_manager':
        return translate.human_resources_manager;
      case 'information_technology_coordinator':
        return translate.information_technology_coordinator;
      case 'public_relations_coordinator':
        return translate.public_relations_coordinator;
      case 'corporate_communications_coordinator':
        return translate.corporate_communications_coordinator;
      case 'legal_director':
        return translate.legal_director;
      case 'senior_attorney':
        return translate.senior_attorney;
      default:
        return "";
    }
  }
}

class ContainerSocialButtons extends StatelessWidget {
  const ContainerSocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context)!;

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
              translate.follow_us,
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

// class CarrouselWidget extends StatelessWidget {
//   const CarrouselWidget({super.key});

//   Future<List<String>> _fetchBanners() async {
//     // Simulación de obtener imágenes desde una API
//     // En el futuro, aquí se hará una llamada HTTP para obtener las imágenes
//     await Future.delayed(
//       const Duration(milliseconds: 500),
//     ); // Simula un retraso
//     return [
//       'assets/images/banners/banner1.webp',
//       'assets/images/banners/banner2.webp',
//       'assets/images/banners/banner3.webp',
//       'assets/images/banners/banner4.webp',
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<String>>(
//       future: _fetchBanners(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return const Center(child: Text('Error loading banners'));
//         } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return const Center(child: Text('No banners available'));
//         }

//         final banners = snapshot.data!;
//         return CarouselSlider(
//           options: CarouselOptions(
//             autoPlay: true,
//             enlargeCenterPage: true,
//             aspectRatio: 22 / 8,
//             pageSnapping: true,
//             autoPlayInterval: const Duration(seconds: 3),
//             pauseAutoPlayOnTouch: true,
//           ),
//           items:
//               banners.map((imagePath) {
//                 return Builder(
//                   builder: (BuildContext context) {
//                     return GestureDetector(
//                       onTap: () {
//                         _showZoomableImage(context, imagePath);
//                       },
//                       child: Container(
//                         width: MediaQuery.of(context).size.width,
//                         margin: const EdgeInsets.symmetric(horizontal: 2.0),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(8.0),
//                           child: Image(
//                             image: AssetImage(imagePath),
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               }).toList(),
//         );
//       },
//     );
//   }

//   void _showZoomableImage(BuildContext context, String imagePath) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return Dialog(
//           backgroundColor: Colors.transparent,
//           child: GestureDetector(
//             onTap: () => Navigator.of(context).pop(), // Cerrar el diálogo
//             child: InteractiveViewer(
//               panEnabled: true, // Permite desplazar la imagen
//               minScale: 1.0, // Zoom mínimo
//               maxScale: 5.0, // Zoom máximo
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(10.0),
//                 child: Image.asset(imagePath, fit: BoxFit.contain),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class AboutComponent extends StatelessWidget {
//   const AboutComponent({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final isMobile = ResponsiveBreakpoints.of(context).isMobile;

//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10.0),
//         color: Theme.of(context).colorScheme.primary,
//       ),
//       padding: const EdgeInsets.all(20),
//       child:
//           isMobile
//               ? Column(children: _buildContent(context))
//               : Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: _buildContent(context),
//               ),
//     );
//   }

//   List<Widget> _buildContent(BuildContext context) {
//     return [
//       Expanded(
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(12.0),
//           child: const Image(
//             image: AssetImage('assets/images/about.webp'),
//             fit: BoxFit.cover,
//           ),
//         ),
//       ),
//       const SizedBox(width: 20, height: 20),
//       Expanded(
//         child: Padding(
//           padding: const EdgeInsets.all(25),
//           child: Column(
//             children: [
//               Text(
//                 AppLocalizations.of(context)!.about,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 35,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 maxLines: 10,
//                 overflow: TextOverflow.ellipsis,
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 15),
//               Text(
//                 AppLocalizations.of(context)!.mm_about_txt,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontFamily: 'Arial,Helvetica,sans-serif',
//                 ),
//                 maxLines: 12,
//                 overflow: TextOverflow.ellipsis,
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 25),
//               Center(
//                 child: RoundedButton(
//                   text: AppLocalizations.of(context)!.contact_us,
//                   color: Colors.white,
//                   textColor: Theme.of(context).colorScheme.primary,
//                   press: () {
//                     Navigator.of(context).pushNamed('contact_us');
//                   },
//                 ),
//               ),
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     ];
//   }
// }
