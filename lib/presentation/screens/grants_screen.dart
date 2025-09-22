import 'package:flutter/material.dart';
// Bloc
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm/data/data.dart';
import 'package:mm/domain/entities/grant.dart';
import 'package:mm/presentation/bloc/grants/grants_bloc.dart';
import 'package:mm/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class GrantScreen extends StatefulWidget {
  const GrantScreen({super.key});

  @override
  State<GrantScreen> createState() => _GrantScreenState();
}

class _GrantScreenState extends State<GrantScreen> {
  late GrantsBloc _grantsBloc;

  @override
  void initState() {
    super.initState();
    _grantsBloc = GrantsBloc()..add(GetGrantsEvent());
  }

  @override
  void dispose() {
    _grantsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final translation = AppLocalizations.of(context)!;
    final client = DioClient();

    return BlocProvider.value(
      value: _grantsBloc,
      child: Scaffold(
        appBar: AppBar(title: Text(translation.grants)),
        body: BlocBuilder<GrantsBloc, GrantsState>(
          builder: (context, state) {
            if (state is GrantsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GrantsSuccess) {
              final grants = state.grants;

              return GridView.builder(
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 300,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.8,
                ),
                itemCount: grants.length,
                itemBuilder: (context, index) {
                  final grant = grants[index];
                  return TweenAnimationBuilder(
                    duration: Duration(milliseconds: 300 + (index * 100)),
                    tween: Tween<double>(begin: 0, end: 1),
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.scale(scale: value, child: child),
                      );
                    },
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => GrantCarouselScreen(
                                  grants: grants,
                                  initialIndex: index,
                                ),
                          ),
                        );
                      },
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: Center(
                                child: Image.network(
                                  client.buildImageUrl(
                                    'grant_logo/${grant.id}',
                                  ),
                                  fit: BoxFit.contain,
                                  errorBuilder:
                                      (_, __, ___) => const Icon(
                                        Icons.image_not_supported,
                                        size: 100,
                                      ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                grant.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (state is GrantsError) {
              return Center(child: Text(state.message));
            }
            return Center(child: Text(translation.no_elements));
          },
        ),
      ),
    );
  }
}

class GrantCarouselScreen extends StatefulWidget {
  final List<Grant> grants;
  final int initialIndex;

  const GrantCarouselScreen({
    super.key,
    required this.grants,
    required this.initialIndex,
  });

  @override
  State<GrantCarouselScreen> createState() => _GrantCarouselScreenState();
}

class _GrantCarouselScreenState extends State<GrantCarouselScreen> {
  late int _currentIndex;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final grants = widget.grants;
    final translation = AppLocalizations.of(context)!;
    final client = DioClient();

    return Scaffold(
      appBar: AppBar(title: Text(translation.grants)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          Stack(
            alignment: Alignment.center,
            children: [
              CarouselSlider.builder(
                carouselController: _carouselController,
                itemCount: grants.length,
                options: CarouselOptions(
                  height: 500,
                  initialPage: _currentIndex,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                  autoPlay: true, // utoplay
                  autoPlayInterval: const Duration(seconds: 4), // Duracion
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
                itemBuilder: (context, index, realIndex) {
                  final grant = grants[index];
                  return Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => GrantDetailScreen(
                                  grant: grant,
                                  index: index,
                                ),
                          ),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 5,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          constraints: const BoxConstraints(maxHeight: 500),
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                flex: 4,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    client.buildImageUrl(
                                      'grant_logo/${grant.id}',
                                    ),
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorBuilder:
                                        (_, __, ___) => const Icon(
                                          Icons.image_not_supported,
                                          size: 100,
                                        ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                grant.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              // Botón izquierda
              if (_currentIndex > 0)
                Positioned(
                  left: 20,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 50),
                    onPressed: () {
                      _carouselController.animateToPage(_currentIndex - 1);
                    },
                  ),
                ),
              // Botón derecha
              if (_currentIndex < grants.length - 1)
                Positioned(
                  right: 20,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, size: 50),
                    onPressed: () {
                      _carouselController.animateToPage(_currentIndex + 1);
                    },
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(grants.length, (index) {
              return GestureDetector(
                onTap: () => _carouselController.animateToPage(index),
                child: Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        _currentIndex == index
                            ? Theme.of(context).primaryColor
                            : Colors.grey[300],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class GrantDetailScreen extends StatelessWidget {
  final Grant grant;
  final int index;
  const GrantDetailScreen({
    super.key,
    required this.grant,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final translation = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final client = DioClient();

    return Scaffold(
      appBar: AppBar(title: Text(grant.name)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (grant.imageUrl.isNotEmpty)
                Center(
                  child: Hero(
                    tag: 'grant-image-${grant.id}',
                    child: Image.network(
                      client.buildImageUrl('grant_logo/${grant.id}'),
                      height: size.height * 0.25,
                      fit: BoxFit.contain,
                      loadingBuilder: (
                        BuildContext context,
                        Widget child,
                        ImageChunkEvent? loadingProgress,
                      ) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value:
                                loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                          ),
                        );
                      },
                      errorBuilder:
                          (context, error, stackTrace) =>
                              const Icon(Icons.error, size: 100),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              if (grant.name.isNotEmpty)
                Text(
                  grant.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const SizedBox(height: 20),
              if (grant.website.isNotEmpty)
                ListTile(
                  leading: const Icon(Icons.link),
                  title: Text(translation.website),
                  subtitle: Text(grant.website),
                  onTap: () => launchUrl(Uri.parse(grant.website)),
                ),
              if (grant.telephone.isNotEmpty)
                ListTile(
                  leading: const Icon(Icons.phone),
                  title: Text(translation.phone),
                  subtitle: Text(grant.telephone),
                ),
              if (grant.email.isNotEmpty)
                ListTile(
                  leading: const Icon(Icons.email),
                  title: Text(translation.email),
                  subtitle: Text(grant.email),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
