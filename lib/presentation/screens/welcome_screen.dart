// import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:milmujeres_app/domain/entities/language_model.dart';
import 'package:milmujeres_app/domain/entities/staff.dart';
import 'package:milmujeres_app/presentation/bloc/locale/language_bloc.dart';
// import 'package:milmujeres_app/widgets/widgets.dart';
// import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:milmujeres_app/presentation/bloc/staff/staff_bloc.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Scaffold(
            appBar: CustomAppBar(),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  // const SizedBox(height: 20),
                  // const CarrouselWidget(),
                  // const SizedBox(height: 20),
                  // const AboutComponent(),
                  ContainerAbout(),
                  const SizedBox(height: 20),
                  ContainerDonate(),
                  const SizedBox(height: 20),
                  ContainerStaff(),
                ],
              ),
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
      actions: [
        _CustomDropDownUnderlineWelcome(),
        IconButton(onPressed: () {}, icon: const Icon(Icons.favorite)),
        IconButton(
          icon: const Icon(Icons.person),
          onPressed: () {
            // Mostrar menú lateral
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
            value: state.selectedLanguage.value.languageCode, // Idioma actual
            items: [
              DropdownMenuItem(
                value: "en",
                child: Row(
                  children: const [
                    Icon(Icons.language, color: Colors.blue),
                    SizedBox(width: 10),
                    Text('English'),
                  ],
                ),
              ),
              DropdownMenuItem(
                value: "es",
                child: Row(
                  children: const [
                    Icon(Icons.language, color: Colors.red),
                    SizedBox(width: 10),
                    Text('Español'),
                  ],
                ),
              ),
            ],
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
              onPressed: () {},
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
    return Container(
      child: BlocBuilder<StaffBloc, StaffState>(
        bloc: StaffBloc()..add(StaffFetchEvent()),
        builder: (context, state) {
          switch (state.runtimeType) {
            case StaffInitial:
            case StaffLoading:
              return const Center(child: CircularProgressIndicator());

            case StaffSuccess:
              final staff = (state as StaffSuccess).staff;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    _buildTeamSection('Executive Team', staff.executiveTeam),
                    _buildTeamSection('Legal Team', staff.legalTeam),
                  ],
                ),
              );

            case StaffError:
              final error = (state as StaffError).errorMessage;
              return Center(child: Text('Error: $error'));

            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _buildTeamSection(String title, List<StaffMember> team) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(), // Importante
          itemCount: team.length,
          itemBuilder: (context, index) {
            final member = team[index];
            return ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(member.name),
              subtitle: Text(member.role),
            );
          },
        ),
      ],
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
