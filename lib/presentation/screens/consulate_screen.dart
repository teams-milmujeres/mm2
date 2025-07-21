import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:milmujeres_app/data/data.dart';
import 'package:milmujeres_app/domain/entities/consulate.dart';
import 'package:milmujeres_app/domain/entities/office.dart';
import 'package:milmujeres_app/presentation/bloc/consulates/consulates_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConsulateOfficeScreen extends StatefulWidget {
  const ConsulateOfficeScreen({super.key});

  @override
  State<ConsulateOfficeScreen> createState() => _ConsulateOfficeScreenState();
}

class _ConsulateOfficeScreenState extends State<ConsulateOfficeScreen> {
  late ConsulatesBloc _consulatesBloc;

  @override
  void initState() {
    super.initState();
    _consulatesBloc = ConsulatesBloc()..add(GetConsulatesEvent());
  }

  @override
  void dispose() {
    _consulatesBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final translation = AppLocalizations.of(context)!;
    final client = DioClient();

    return BlocProvider.value(
      value: _consulatesBloc,
      child: Scaffold(
        appBar: AppBar(title: Text(translation.consulates)),
        body: BlocBuilder<ConsulatesBloc, ConsulatesState>(
          builder: (context, state) {
            if (state is ConsulatesLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ConsulatesSuccess) {
              final offices = state.offices;

              return GridView.builder(
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 300,
                ),
                itemCount: offices.length,
                itemBuilder: (context, index) {
                  final office = offices[index];
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
                                (_) => ConsulateCarouselScreen(
                                  offices: offices,
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
                        child: Image.network(
                          client.buildImageUrl(
                            'city_consulate_img/${office.city}',
                          ),
                          fit: BoxFit.cover,
                          errorBuilder:
                              (_, __, ___) => const Icon(
                                Icons.image_not_supported,
                                size: 100,
                              ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (state is ConsulatesError) {
              return Center(child: Text(state.message));
            }
            return Center(child: Text(translation.no_elements));
          },
        ),
      ),
    );
  }
}

class ConsulateCarouselScreen extends StatefulWidget {
  final List<Office> offices;
  final int initialIndex;

  const ConsulateCarouselScreen({
    super.key,
    required this.offices,
    required this.initialIndex,
  });

  @override
  State<ConsulateCarouselScreen> createState() =>
      _ConsulateCarouselScreenState();
}

class _ConsulateCarouselScreenState extends State<ConsulateCarouselScreen> {
  late int _currentIndex;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  @override
  Widget build(BuildContext context) {
    final offices = widget.offices;
    final translation = AppLocalizations.of(context)!;
    final client = DioClient();

    return Scaffold(
      appBar: AppBar(title: Text(translation.consulates)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          Stack(
            alignment: Alignment.center,
            children: [
              CarouselSlider.builder(
                carouselController: _carouselController,
                itemCount: offices.length,
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
                  final office = offices[index];
                  return Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => ConsulatesList(
                                  consulates: office.consulates,
                                  officeName: office.name,
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
                                      'city_consulate_img/${office.city}',
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
                              ListTile(
                                title: Text(
                                  '${translation.city}: ${office.city} | ${office.name}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => ConsulatesList(
                                              consulates: office.consulates,
                                              officeName: office.name,
                                            ),
                                      ),
                                    );
                                  },
                                  child: Text(translation.see_details),
                                ),
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
              Positioned(
                left: 20,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 50),
                  onPressed:
                      _currentIndex > 0
                          ? () {
                            _carouselController.animateToPage(
                              _currentIndex - 1,
                            );
                          }
                          : null,
                ),
              ),
              // Botón derecha
              Positioned(
                right: 20,
                child: IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, size: 50),
                  onPressed:
                      _currentIndex < offices.length - 1
                          ? () {
                            _carouselController.animateToPage(
                              _currentIndex + 1,
                            );
                          }
                          : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(offices.length, (index) {
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

class ConsulatesList extends StatelessWidget {
  final List<Consulate> consulates;
  final String officeName;

  const ConsulatesList({
    super.key,
    required this.consulates,
    required this.officeName,
  });

  @override
  Widget build(BuildContext context) {
    final translation = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text('${translation.consulates} | $officeName')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            consulates.isEmpty
                ? Center(child: Text(translation.no_elements))
                : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: consulates.length,
                  itemBuilder: (context, index) {
                    final consulate = consulates[index];
                    final imageUrl = DioClient().buildImageUrl(
                      'country_flag/${consulate.consulateCountry.abbrev.toUpperCase()}/3X',
                    );

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => ConsulateDetailsScreen(
                                  consulate: consulate,
                                ),
                          ),
                        );
                      },
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                loadingBuilder: (
                                  context,
                                  child,
                                  loadingProgress,
                                ) {
                                  if (loadingProgress == null) {
                                    return child; // imagen ya cargada
                                  }
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                                errorBuilder:
                                    (_, __, ___) => const Icon(
                                      Icons.image_not_supported,
                                      size: 80,
                                    ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      consulate.consulate,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      consulate.city ?? '',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}

class ConsulateDetailsScreen extends StatelessWidget {
  final Consulate consulate;

  const ConsulateDetailsScreen({super.key, required this.consulate});

  @override
  Widget build(BuildContext context) {
    final translation = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(consulate.consulate)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Center(
              child: Image.network(
                DioClient().buildImageUrl(
                  'country_flag/${consulate.consulateCountry.abbrev.toUpperCase()}/3X',
                ),
                height: 100,
                width: 100,
                errorBuilder:
                    (_, __, ___) =>
                        const Icon(Icons.image_not_supported, size: 80),
              ),
            ),

            if (consulate.email != null)
              ListTile(
                leading: const Icon(Icons.email_outlined),
                title: Text(translation.email),
                subtitle: Text(consulate.email!),
              ),
            if (consulate.phone != null)
              ListTile(
                leading: const Icon(Icons.phone_outlined),
                title: Text(translation.phone),
                subtitle: Text(consulate.phone!),
              ),
            if (consulate.contacts != null)
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: Text(translation.contacts),
                subtitle: Text(consulate.contacts!),
              ),
            if (consulate.responsable != null)
              ListTile(
                leading: const Icon(Icons.manage_accounts_outlined),
                title: const Text('Responsable'),
                subtitle: Text(consulate.responsable!),
              ),
            if (consulate.city != null)
              ListTile(
                leading: const Icon(Icons.location_city_outlined),
                title: const Text('Ciudad'),
                subtitle: Text(consulate.city!),
              ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.flag_outlined),
              title: const Text('País'),
              subtitle: Text(consulate.country.name),
            ),
            ListTile(
              leading: const Icon(Icons.map_outlined),
              title: const Text('Estado'),
              subtitle: Text(consulate.state.name),
            ),
          ],
        ),
      ),
    );
  }
}
