import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:milmujeres_app/domain/entities/language_model.dart';
import 'package:milmujeres_app/presentation/bloc/locale/language_bloc.dart';
import 'package:milmujeres_app/widgets/widgets.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = ResponsiveBreakpoints.of(context).isMobile;

          return Scaffold(
            appBar: isMobile ? const AndroidAppBar() : const WebAppBar(),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const CarrouselWidget(),
                  const SizedBox(height: 20),
                  const AboutComponent(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class AndroidAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  const AndroidAppBar({super.key})
    : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Mil Mujeres'),
      actions: [
        TextButton(onPressed: () {}, child: Text('Contact Us')),
        TextButton(onPressed: () {}, child: Text('Offices')),
        TextButton(onPressed: () {}, child: Text('Consulates')),
        TextButton(onPressed: () {}, child: Text('Events')),
      ],
    );
  }
}

class WebAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  const WebAppBar({super.key})
    : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  State<WebAppBar> createState() => _WebAppBarState();
}

class _WebAppBarState extends State<WebAppBar> {
  String selectedLocale = "en"; // Idioma predeterminado

  // void _onLocaleChanged(String value) {
  //   setState(() {
  //     selectedLocale = value;
  //   });

  //   if (kDebugMode) {
  //     print('Idioma seleccionado: $value');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Mil Mujeres'),
      actions: [
        // TextButton(onPressed: () {}, child: Text('Contact Us')),
        // TextButton(onPressed: () {}, child: Text('Offices')),
        // TextButton(onPressed: () {}, child: Text('Consulates')),
        // TextButton(onPressed: () {}, child: Text('Events')),
        _CustomDropDownUnderlineWelcome(),
        FilledButton(
          onPressed: () {
            // Navegar a la pantalla de donaciones
          },
          child: Row(
            children: [
              Icon(Icons.favorite),
              // SizedBox(width: 4),
              // Text('Donate'),
            ],
          ),
        ),
        SizedBox(width: 8),
        FilledButton(
          onPressed: () {
            // Navegar a la pantalla de inicio de sesión
          },
          child: Row(
            children: [
              Icon(Icons.person),
              // SizedBox(width: 4), Text('Login'),
            ],
          ),
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

class CarrouselWidget extends StatelessWidget {
  const CarrouselWidget({super.key});

  Future<List<String>> _fetchBanners() async {
    // Simulación de obtener imágenes desde una API
    // En el futuro, aquí se hará una llamada HTTP para obtener las imágenes
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Simula un retraso
    return [
      'assets/images/banners/banner1.webp',
      'assets/images/banners/banner2.webp',
      'assets/images/banners/banner3.webp',
      'assets/images/banners/banner4.webp',
    ];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _fetchBanners(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading banners'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No banners available'));
        }

        final banners = snapshot.data!;
        return CarouselSlider(
          options: CarouselOptions(
            autoPlay: true,
            enlargeCenterPage: true,
            aspectRatio: 22 / 8,
            pageSnapping: true,
            autoPlayInterval: const Duration(seconds: 3),
            pauseAutoPlayOnTouch: true,
          ),
          items:
              banners.map((imagePath) {
                return Builder(
                  builder: (BuildContext context) {
                    return GestureDetector(
                      onTap: () {
                        _showZoomableImage(context, imagePath);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image(
                            image: AssetImage(imagePath),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
        );
      },
    );
  }

  void _showZoomableImage(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(), // Cerrar el diálogo
            child: InteractiveViewer(
              panEnabled: true, // Permite desplazar la imagen
              minScale: 1.0, // Zoom mínimo
              maxScale: 5.0, // Zoom máximo
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.asset(imagePath, fit: BoxFit.contain),
              ),
            ),
          ),
        );
      },
    );
  }
}

class AboutComponent extends StatelessWidget {
  const AboutComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Theme.of(context).colorScheme.primary,
      ),
      padding: const EdgeInsets.all(20),
      child:
          isMobile
              ? Column(children: _buildContent(context))
              : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildContent(context),
              ),
    );
  }

  List<Widget> _buildContent(BuildContext context) {
    return [
      Expanded(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: const Image(
            image: AssetImage('assets/images/about.webp'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      const SizedBox(width: 20, height: 20),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context)!.about,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 10,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              Text(
                AppLocalizations.of(context)!.mm_about_txt,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'Arial,Helvetica,sans-serif',
                ),
                maxLines: 12,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),
              Center(
                child: RoundedButton(
                  text: AppLocalizations.of(context)!.contact_us,
                  color: Colors.white,
                  textColor: Theme.of(context).colorScheme.primary,
                  press: () {
                    Navigator.of(context).pushNamed('contact_us');
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    ];
  }
}
