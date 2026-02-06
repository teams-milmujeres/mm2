import 'package:flutter/material.dart';
// Carousel
import 'package:carousel_slider/carousel_slider.dart';
// Video Player
import 'package:video_player/video_player.dart';

class MMActionsScreen extends StatefulWidget {
  const MMActionsScreen({super.key});

  @override
  State<MMActionsScreen> createState() => _MMActionsScreenState();
}

class _MMActionsScreenState extends State<MMActionsScreen> {
  CarouselSliderController buttonCarouselController =
      CarouselSliderController();

  late final VideoPlayerController _videoController;
  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _videoController = VideoPlayerController.networkUrl(
      Uri.parse('https://teams2.testermm.com/videos/testimonio.mp4'),
    );

    try {
      await _videoController.initialize();
      setState(() {});
    } catch (e) {
      debugPrint('Error initializing video controller: $e');
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  void _showZoomableImage(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (context) {
        final screenSize = MediaQuery.of(context).size;
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Center(
              child: InteractiveViewer(
                panEnabled: true,
                minScale: 1.0,
                maxScale: 5.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    width: screenSize.width * 0.95,
                    height: screenSize.height * 0.85,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget testimonialCard() {
    final screenWidth = MediaQuery.of(context).size.width;
    final translation =
        Localizations.localeOf(context).languageCode == 'es'
            ? 'TESTIMONIO DE UNA DE NUESTRAS GRADUADAS'
            : 'TESTIMONY OF ONE OF OUR GRADUATES';

    Widget videoWidget;
    // if (kIsWeb) {
    //   // Widget HTML para web
    //   // Crea un id único para el elemento
    //   final String viewID =
    //       'videoElement-${DateTime.now().millisecondsSinceEpoch}';
    //   // Registra el elemento solo una vez
    //   // ignore: undefined_prefixed_name
    //   ui.platformViewRegistry.registerViewFactory(
    //     viewID,
    //     (int _) {
    //       final video = html.HTMLVideoElement()
    //         ..src = 'https://teams2.testermm.com/videos/testimonio.mp4'
    //         ..controls = true
    //         ..style.width = '100%'
    //         ..style.borderRadius = '12px';
    //       return video;
    //     },
    //   );
    //   videoWidget = SizedBox(
    //     width: screenWidth < 350 ? 350 : screenWidth * 0.5,
    //     height: (screenWidth < 350 ? 350 : screenWidth * 0.5) * 3 / 2,
    //     child: HtmlElementView(viewType: viewID),
    //   );
    // } else {
    //   // Widget nativo para móvil/escritorio
    //   videoWidget = SizedBox(
    //     width: screenWidth < 350 ? 350 : screenWidth * 0.5,
    //     child: AspectRatio(
    //       aspectRatio: 2 / 3,
    //       child: _videoController.value.isInitialized
    //           ? Stack(
    //               alignment: Alignment.center,
    //               children: [
    //                 ClipRRect(
    //                   borderRadius: BorderRadius.circular(12),
    //                   child: VideoPlayer(_videoController),
    //                 ),
    //                 if (!_videoController.value.isPlaying)
    //                   IconButton(
    //                     icon: const Icon(
    //                       Icons.play_circle,
    //                       size: 64,
    //                       color: Colors.white,
    //                     ),
    //                     onPressed: () {
    //                       setState(() {
    //                         _videoController.play();
    //                       });
    //                     },
    //                   )
    //               ],
    //             )
    //           : const Center(child: CircularProgressIndicator()),
    //     ),
    //   );
    // }

    videoWidget = SizedBox(
      width: screenWidth < 350 ? 350 : screenWidth * 0.5,
      child: AspectRatio(
        aspectRatio: 2 / 3,
        child:
            _videoController.value.isInitialized
                ? Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: VideoPlayer(_videoController),
                    ),
                    if (!_videoController.value.isPlaying)
                      IconButton(
                        icon: const Icon(
                          Icons.play_circle,
                          size: 64,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _videoController.play();
                          });
                        },
                      ),
                  ],
                )
                : const Center(child: CircularProgressIndicator()),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: Theme.of(context).primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.only(
                  left: screenWidth < 350 ? 0 : screenWidth * 0.05,
                ),
                child: Text(
                  translation,
                  style: TextStyle(
                    fontSize: screenWidth < 350 ? 24 : screenWidth * 0.045,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(height: 24),
              Center(child: videoWidget),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Detectar si estamos en modo oscuro
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final String darkSuffix = isDarkMode ? '-dark' : '';

    // Mock data: URLs de tus imágenes de fotos
    final List<String> photoUrls = [
      'assets/images/mm-actions/image-1.jpg',
      'assets/images/mm-actions/image-2.jpg',
      'assets/images/mm-actions/image-3.jpg',
      'assets/images/mm-actions/image-4.jpg',
      'assets/images/mm-actions/image-5.jpg',
    ];

    // Carrusel de módulos como imágenes locales
    final List<Widget> moduleImageUrlsES = [
      GestureDetector(
        onTap:
            () => _showZoomableImage(
              context,
              'assets/images/mm-actions/modulo-0-es$darkSuffix.jpg',
            ),
        child: Image.asset(
          'assets/images/mm-actions/modulo-0-es$darkSuffix.jpg',
        ),
      ),
      GestureDetector(
        onTap:
            () => _showZoomableImage(
              context,
              'assets/images/mm-actions/modulo-1-es$darkSuffix.jpg',
            ),
        child: Image.asset(
          'assets/images/mm-actions/modulo-1-es$darkSuffix.jpg',
        ),
      ),
      GestureDetector(
        onTap:
            () => _showZoomableImage(
              context,
              'assets/images/mm-actions/modulo-2-es$darkSuffix.jpg',
            ),
        child: Image.asset(
          'assets/images/mm-actions/modulo-2-es$darkSuffix.jpg',
        ),
      ),
      GestureDetector(
        onTap:
            () => _showZoomableImage(
              context,
              'assets/images/mm-actions/modulo-3-es$darkSuffix.jpg',
            ),
        child: Image.asset(
          'assets/images/mm-actions/modulo-3-es$darkSuffix.jpg',
        ),
      ),
      testimonialCard(),
    ];

    final List<Widget> moduleImageUrlsEN = [
      GestureDetector(
        onTap:
            () => _showZoomableImage(
              context,
              'assets/images/mm-actions/modulo-0-en$darkSuffix.jpg',
            ),
        child: Image.asset(
          'assets/images/mm-actions/modulo-0-en$darkSuffix.jpg',
        ),
      ),
      GestureDetector(
        onTap:
            () => _showZoomableImage(
              context,
              'assets/images/mm-actions/modulo-1-en$darkSuffix.jpg',
            ),
        child: Image.asset(
          'assets/images/mm-actions/modulo-1-en$darkSuffix.jpg',
        ),
      ),
      GestureDetector(
        onTap:
            () => _showZoomableImage(
              context,
              'assets/images/mm-actions/modulo-2-en$darkSuffix.jpg',
            ),
        child: Image.asset(
          'assets/images/mm-actions/modulo-2-en$darkSuffix.jpg',
        ),
      ),
      GestureDetector(
        onTap:
            () => _showZoomableImage(
              context,
              'assets/images/mm-actions/modulo-3-en$darkSuffix.jpg',
            ),
        child: Image.asset(
          'assets/images/mm-actions/modulo-3-en$darkSuffix.jpg',
        ),
      ),
      testimonialCard(),
    ];

    // Obtener el idioma actual
    final String currentLocale = Localizations.localeOf(context).languageCode;
    // Seleccionar las imágenes según el idioma
    final List<Widget> moduleImageUrls =
        currentLocale == 'es' ? moduleImageUrlsES : moduleImageUrlsEN;

    final String logo =
        Localizations.localeOf(context).languageCode == 'es'
            ? 'assets/images/mm-actions/logo-es$darkSuffix.jpg'
            : 'assets/images/mm-actions/logo-en$darkSuffix.jpg';

    final String inscriptionsInfo =
        Localizations.localeOf(context).languageCode == 'es'
            ? 'assets/images/mm-actions/inscriptions-info-es$darkSuffix.jpg'
            : 'assets/images/mm-actions/inscriptions-info-en$darkSuffix.jpg';

    return Scaffold(
      appBar: AppBar(title: const Text('MM en Acción'), centerTitle: true),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 🟢 LOGO
                  SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.width * 0.55,
                    child: Image.asset(logo, fit: BoxFit.fitWidth),
                  ),
                  const SizedBox(height: 16),

                  // 🟢 Carrusel de fotos
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final double width = constraints.maxWidth;
                      final double scale = width > 300 ? (width / 300) : 1.0;
                      final double carouselHeight = 180 * scale;
                      final double borderRadius = 8 * scale;

                      return CarouselSlider(
                        items:
                            photoUrls.map((image) {
                              return GestureDetector(
                                onTap: () => _showZoomableImage(context, image),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    borderRadius,
                                  ),
                                  child: Image.asset(
                                    image,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),
                              );
                            }).toList(),
                        options: CarouselOptions(
                          height: carouselHeight,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          viewportFraction: 0.8,
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // 🟢 Carrusel de módulos con flechas
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final double width = constraints.maxWidth;
                      final double scale = width > 300 ? (width / 300) : 1.0;
                      final double carouselHeight = 300 * scale;
                      final double carouselWidth = width * 0.9;
                      final double buttonSize = 40 * scale;
                      final double iconSize = 48 * scale;

                      return Center(
                        child: SizedBox(
                          height: carouselHeight,
                          width: carouselWidth,
                          child: Stack(
                            children: [
                              CarouselSlider.builder(
                                itemCount: moduleImageUrls.length,
                                itemBuilder: (context, index, realIndex) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      12 * scale,
                                    ),
                                    child: moduleImageUrls[index],
                                  );
                                },
                                options: CarouselOptions(
                                  height: carouselHeight,
                                  viewportFraction: 1.0,
                                  enableInfiniteScroll: false,
                                  enlargeCenterPage: false,
                                ),
                                carouselController: buttonCarouselController,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: IconButton(
                                  iconSize: iconSize,
                                  icon: Image.asset(
                                    'assets/images/mm-actions/arrow-left$darkSuffix.png',
                                    width: buttonSize,
                                    height: buttonSize,
                                  ),
                                  onPressed: () {
                                    buttonCarouselController.previousPage(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      curve: Curves.ease,
                                    );
                                  },
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                  iconSize: iconSize,
                                  icon: Image.asset(
                                    'assets/images/mm-actions/arrow-right$darkSuffix.png',
                                    width: buttonSize,
                                    height: buttonSize,
                                  ),
                                  onPressed: () {
                                    buttonCarouselController.nextPage(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      curve: Curves.ease,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.66,
                    child: Image.asset(
                      inscriptionsInfo,
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
