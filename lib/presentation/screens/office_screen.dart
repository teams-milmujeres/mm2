import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:milmujeres_app/data/data.dart';
import 'package:milmujeres_app/domain/entities/office.dart';
import 'package:milmujeres_app/presentation/bloc/offices/offices_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';

class OfficeScreen extends StatefulWidget {
  const OfficeScreen({super.key});

  @override
  State<OfficeScreen> createState() => _OfficeScreenState();
}

class _OfficeScreenState extends State<OfficeScreen> {
  late OfficesBloc _officesBloc;

  @override
  void initState() {
    super.initState();
    _officesBloc = OfficesBloc()..add(GetOfficesEvent());
  }

  @override
  void dispose() {
    _officesBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final translation = AppLocalizations.of(context)!;

    return BlocProvider.value(
      value: _officesBloc,
      child: Scaffold(
        appBar: AppBar(title: Text(translation.offices)),
        body: BlocBuilder<OfficesBloc, OfficesState>(
          builder: (context, state) {
            if (state is OfficesLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is OfficesError) {
              return Center(child: Text(state.errorMessage));
            }

            if (state is OfficesSuccess) {
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
                                (_) => OfficeCarouselScreen(
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
                        child:
                            office.imageUrl?.isNotEmpty == true
                                ? Image.network(
                                  office.imageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (_, __, ___) =>
                                          const Icon(Icons.image_not_supported),
                                )
                                : const Icon(Icons.image_not_supported),
                      ),
                    ),
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class OfficeCarouselScreen extends StatefulWidget {
  final List<Office> offices;
  final int initialIndex;

  const OfficeCarouselScreen({
    super.key,
    required this.offices,
    required this.initialIndex,
  });

  @override
  State<OfficeCarouselScreen> createState() => _OfficeCarouselScreenState();
}

class _OfficeCarouselScreenState extends State<OfficeCarouselScreen> {
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
    final offices = widget.offices;
    final translation = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: const Text('Oficinas')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          CarouselSlider.builder(
            carouselController: _carouselController,
            itemCount: offices.length,
            options: CarouselOptions(
              height: 500,
              initialPage: _currentIndex,
              enlargeCenterPage: true,
              enableInfiniteScroll: false,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
            itemBuilder: (context, index, realIndex) {
              final office = offices[index];
              return Center(
                // asegura que la card no se expanda más allá del slider
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OfficeDetailsScreen(office: office),
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
                                office.imageUrl ?? '',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                // height: 200,
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
                              office.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              "${translation.office_director}: ${office.officeDirector ?? ''} | ${office.city}",
                              style: const TextStyle(fontSize: 16),
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
                                        (context) =>
                                            OfficeDetailsScreen(office: office),
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

class OfficeDetailsScreen extends StatelessWidget {
  final Office office;

  const OfficeDetailsScreen({super.key, required this.office});

  @override
  Widget build(BuildContext context) {
    final translation = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("${translation.office} | ${office.name}"),
          bottom: TabBar(
            tabs: [
              Tab(text: translation.information),
              Tab(text: translation.about), // o "Consulados y Alianzas"
              Tab(text: translation.map),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _GeneralInfoTab(office: office),
            _ReferenceTab(office: office),
            _MapTab(office: office),
          ],
        ),
      ),
    );
  }
}

class _GeneralInfoTab extends StatelessWidget {
  final Office office;

  const _GeneralInfoTab({required this.office});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Center(
          child:
              office.imageUrl != null && office.imageUrl!.isNotEmpty
                  ? CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(office.imageUrl!),
                    backgroundColor: Colors.grey[200],
                  )
                  : const CircleAvatar(
                    radius: 60,
                    child: Icon(Icons.image_not_supported, size: 40),
                  ),
        ),
        const SizedBox(height: 16),

        Center(
          child: Text(
            office.name,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 24),

        if (office.address.isNotEmpty)
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text('Dirección'),
            subtitle: Text(office.address),
          ),

        if (office.city.isNotEmpty)
          ListTile(
            leading: const Icon(Icons.location_city),
            title: const Text('Ciudad'),
            subtitle: Text(office.city),
          ),

        if (office.phone.isNotEmpty)
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('Teléfono'),
            subtitle: Text(office.phone),
          ),

        if (office.poBoxForUscis.isNotEmpty)
          ListTile(
            leading: const Icon(Icons.markunread_mailbox),
            title: const Text('PO Box (USCIS)'),
            subtitle: Text(office.poBoxForUscis),
          ),

        if (office.mmFax != null && office.mmFax!.isNotEmpty)
          ListTile(
            leading: const Icon(Icons.print),
            title: const Text('Fax'),
            subtitle: Text(office.mmFax!),
          ),

        if (office.cityEmail != null && office.cityEmail!.isNotEmpty)
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('Correo de oficina'),
            subtitle: Text(office.cityEmail!),
          ),

        if (office.officeDirector != null && office.officeDirector!.isNotEmpty)
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Directora de Oficina'),
            subtitle: Text(office.officeDirector!),
          ),

        if (office.officeDirectorEmail != null &&
            office.officeDirectorEmail!.isNotEmpty)
          ListTile(
            leading: const Icon(Icons.alternate_email),
            title: const Text('Correo de la Directora'),
            subtitle: Text(office.officeDirectorEmail!),
          ),

        if (office.urlGoogleMaps != null && office.urlGoogleMaps!.isNotEmpty)
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Ver en Google Maps'),
            subtitle: Text(office.urlGoogleMaps!),
            onTap: () async {
              final url = Uri.parse(office.urlGoogleMaps!);
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              }
            },
          ),
      ],
    );
  }
}

class _ReferenceTab extends StatelessWidget {
  final Office office;

  const _ReferenceTab({required this.office});

  @override
  Widget build(BuildContext context) {
    final client = DioClient();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildCardGridSection(
          context,
          title: 'Consulados',
          items: office.consulates,
          getId: (e) => e.id,
          getLogo: (e) => e.logo,
          getLabel: (e) => e.consulate,
          logoPathBuilder: (id) => client.buildImageUrl('consulate_logo/$id'),
        ),
        const SizedBox(height: 24),
        _buildListTileSection(
          context,
          title: 'Referencias',
          items: office.references,
          getId: (e) => e.id,
          getLogo: (e) => e.logo,
          getLabel: (e) => e.organization,
          logoPathBuilder: (id) => client.buildImageUrl('reference_logo/$id'),
        ),
        const SizedBox(height: 24),
        _buildCardGridSection(
          context,
          title: 'Alianzas',
          items: office.alliances,
          getId: (e) => e.id,
          getLogo: (e) => e.logo,
          getLabel: (e) => e.organization,
          logoPathBuilder: (id) => client.buildImageUrl('alliance_logo/$id'),
        ),
      ],
    );
  }

  /// Referencias con estilo tipo ListTile
  Widget _buildListTileSection<T>(
    BuildContext context, {
    required String title,
    required List<T> items,
    required int Function(T) getId,
    required bool Function(T) getLogo,
    required String Function(T) getLabel,
    required String Function(int) logoPathBuilder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (items.isEmpty)
          const Text('No hay elementos disponibles.')
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (_, index) {
              final item = items[index];
              final logo =
                  getLogo(item)
                      ? NetworkImage(logoPathBuilder(getId(item)))
                      : const AssetImage('assets/images/custom-reference.png')
                          as ImageProvider;

              return GestureDetector(
                // onTap: () => Navigator.push(context, getRoute(item)),
                child: Card(
                  child: ListTile(
                    leading: CircleAvatar(backgroundImage: logo),
                    title: Text(getLabel(item)),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  /// Consulados y Alianzas con imagen grande y nombre debajo
  Widget _buildCardGridSection<T>(
    BuildContext context, {
    required String title,
    required List<T> items,
    required int Function(T) getId,
    required bool Function(T) getLogo,
    required String Function(T) getLabel,
    required String Function(int) logoPathBuilder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (items.isEmpty)
          const Text('No hay elementos disponibles.')
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: items.length,
            itemBuilder: (_, index) {
              final item = items[index];
              final image =
                  getLogo(item)
                      ? NetworkImage(logoPathBuilder(getId(item)))
                      : const AssetImage('assets/images/custom-reference.png')
                          as ImageProvider;

              return GestureDetector(
                // onTap: () => Navigator.push(context, getRoute(item)),
                child: Card(
                  elevation: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image(
                            image: image,
                            fit: BoxFit.contain,
                            errorBuilder:
                                (context, error, stackTrace) => Image.asset(
                                  'assets/images/custom-reference.png',
                                ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 8.0,
                        ),
                        child: Text(
                          getLabel(item),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}

class _MapTab extends StatelessWidget {
  final Office office;

  const _MapTab({required this.office});

  @override
  Widget build(BuildContext context) {
    final lat = office.lat;
    final lon = office.lon;

    if (lat == null || lon == null) {
      return const Center(child: Text('Ubicación no disponible.'));
    }

    final coords = LatLng(lat, lon);

    return FlutterMap(
      options: MapOptions(
        initialCenter: coords,
        initialZoom: 13.0,
        maxZoom: 18.0,
        minZoom: 13.0,
      ),
      children: [
        TileLayer(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
        ),
        MarkerLayer(
          markers: [
            Marker(
              width: 80.0,
              height: 80.0,
              point: coords,
              child: InkWell(
                onTap: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  final url = Uri.parse(office.urlGoogleMaps ?? '');

                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } else {
                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text('No se pudo abrir el mapa.'),
                      ),
                    );
                  }
                },
                child: const Image(
                  image: AssetImage('assets/images/marker.png'),
                  width: 50,
                  height: 50,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
