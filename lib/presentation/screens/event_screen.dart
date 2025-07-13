import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:milmujeres_app/data/data.dart';
import 'package:milmujeres_app/domain/entities/event.dart';
import 'package:milmujeres_app/presentation/bloc/events/events_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  late EventsBloc _eventsBloc;

  @override
  void initState() {
    super.initState();
    _eventsBloc = EventsBloc()..add(GetEvents());
  }

  @override
  void dispose() {
    _eventsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context)!;

    return BlocProvider.value(
      value: _eventsBloc,
      child: DefaultTabController(
        length: 3,
        child: BlocBuilder<EventsBloc, EventsState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: Text(translate.events),
                bottom: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: [
                    Tab(text: translate.news),
                    Tab(text: translate.events),
                    Tab(
                      child: Text(
                        translate.upcoming_events,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              body: switch (state) {
                EventsLoading _ => const Center(
                  child: CircularProgressIndicator(),
                ),
                EventsError(:final errorMessage) => Center(
                  child: Text("Error: $errorMessage"),
                ),
                EventsSuccess _ => TabBarView(
                  children: [
                    _buildNews(context, state),
                    _buildEvents(context, state),
                    _buildUpcomingEvents(context, state),
                  ],
                ),
                _ => Center(child: Text(translate.no_elements)),
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildNews(BuildContext context, EventsSuccess state) {
    final translation = AppLocalizations.of(context)!;
    if (state.blogs.isEmpty) {
      return Center(child: Text(translation.no_elements));
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (state.importantBlogs.isNotEmpty)
            _buildImportantSection(
              context,
              state.importantBlogs,
              isEvent: false,
            ),
          _buildCityFilter(
            context,
            cities: state.citiesBlogs,
            selected:
                (value) =>
                    context.read<EventsBloc>().add(FilterBlogsByCity(value)),
          ),
          ...state.blogs.map((blog) => BlogCard(event: blog, icon: Icons.star)),
        ],
      ),
    );
  }

  Widget _buildEvents(BuildContext context, EventsSuccess state) {
    final translation = AppLocalizations.of(context)!;
    if (state.events.isEmpty) {
      return Center(child: Text(translation.no_elements));
    }
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (state.importantEvents.isNotEmpty)
            _buildImportantSection(
              context,
              state.importantEvents,
              isEvent: true,
            ),
          _buildCityFilter(
            context,
            cities: state.citiesEvents,
            selected:
                (value) =>
                    context.read<EventsBloc>().add(FilterEventsByCity(value)),
          ),
          Expanded(
            child: ListView(
              children:
                  state.events
                      .map(
                        (event) => EventCard(event: event, icon: Icons.event),
                      )
                      .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingEvents(BuildContext context, EventsSuccess state) {
    final translation = AppLocalizations.of(context)!;
    if (state.upcomingEvents.isEmpty) {
      return Center(child: Text(translation.no_elements));
    }

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (state.upcomingEvents.isNotEmpty) ...[
            Text(
              translation.upcoming_events,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 300,
              child: ListView(
                children:
                    state.upcomingEvents
                        .map(
                          (e) => EventCard(event: e, icon: Icons.access_alarm),
                        )
                        .toList(),
              ),
            ),
          ],
          if (state.pastEvents.isNotEmpty) ...[
            Text(
              translation.past_events,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 300,
              child: ListView(
                children:
                    state.pastEvents
                        .map((e) => EventCard(event: e, icon: Icons.history))
                        .toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImportantSection(
    BuildContext context,
    List<Event> list, {
    required bool isEvent,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isEvent
              ? AppLocalizations.of(context)!.important_events
              : AppLocalizations.of(context)!.important_blogs,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 200,
          child: ListView(
            children:
                list
                    .map(
                      (e) =>
                          isEvent
                              ? EventCard(event: e, icon: Icons.star)
                              : BlogCard(event: e, icon: Icons.star),
                    )
                    .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCityFilter(
    BuildContext context, {
    required List<String> cities,
    required void Function(String) selected,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              AppLocalizations.of(context)!.city,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(
            flex: 2,
            child: DropdownButton<String>(
              isExpanded: true,
              value: cities.first,
              onChanged: (String? newValue) {
                if (newValue != null) selected(newValue);
              },
              items:
                  cities
                      .map(
                        (city) => DropdownMenuItem<String>(
                          value: city,
                          child: Text(city),
                        ),
                      )
                      .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final Event event;
  final IconData icon;

  const EventCard({super.key, required this.event, required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventsDetailsScreen(event: event),
          ),
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            ListTile(
              leading: Icon(icon),
              title: Text(
                getLocalizedField(
                  context: context,
                  event: event,
                  field: 'title',
                ),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (event.eventDate != null)
                    Text(
                      DateFormat('yyyy-MM-dd – kk:mm').format(event.eventDate!),
                    ),
                  Text(event.city),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BlogCard extends StatelessWidget {
  final Event event;
  final IconData icon;

  const BlogCard({super.key, required this.event, required this.icon});

  Future<List<String>> _getImagesBlog(String eventId) async {
    final client = DioClient();
    var response = await client.dio.get('blogs_img/$eventId');
    List<dynamic> data = response.data;
    return data
        .whereType<Map<String, dynamic>>()
        .map((e) => e['image_path'] as String)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventsDetailsScreen(event: event),
          ),
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            FutureBuilder<List<String>>(
              future: _getImagesBlog(event.id.toString()),
              builder: (context, snapshot) {
                Widget leadingWidget;

                if (snapshot.connectionState == ConnectionState.waiting) {
                  leadingWidget = const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  leadingWidget = const Icon(Icons.error, color: Colors.red);
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  leadingWidget = ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      snapshot.data![0],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  );
                } else {
                  leadingWidget = const Icon(Icons.image_not_supported);
                }

                return ListTile(
                  leading: leadingWidget,
                  title: Text(
                    getLocalizedField(
                      context: context,
                      event: event,
                      field: 'title',
                    ),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    getLocalizedField(
                      context: context,
                      event: event,
                      field: 'summary',
                    ),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

String getLocalizedField({
  required BuildContext context,
  required Event event,
  required String field,
}) {
  String locale = Localizations.localeOf(context).languageCode;

  switch (field) {
    case 'title':
      return locale == 'es' ? event.titleEs : event.titleEn;
    case 'body':
      return locale == 'es' ? event.bodyEs : event.bodyEn;
    case 'summary':
      // Opcional: si tienes un campo resumen distinto, lo defines aquí.
      return locale == 'es' ? event.bodyEs : event.bodyEn;
    default:
      return '';
  }
}

class EventsDetailsScreen extends StatelessWidget {
  const EventsDetailsScreen({super.key, required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    var languageCode = Localizations.localeOf(context).languageCode;

    String getLocalizedField(String field) {
      // Mapa de códigos de idioma y sufijos correspondientes
      final localizedFields = {'es': '${field}_es', 'en': '${field}_en'};

      // Obtén el campo localizado según el idioma
      final localizedField = localizedFields[languageCode];

      // Devuelve el valor localizado si existe, o un valor por defecto
      return event.toJson()[localizedField] ??
          (languageCode == 'es' ? 'Sin $field' : 'No $field');
    }

    Future<List<String>> getImagesBlog(String eventId) async {
      final client = DioClient();
      var response = await client.dio.get('blogs_img/$eventId');
      List<dynamic> data = response.data;
      return data
          .whereType<Map<String, dynamic>>()
          .map((e) => e['image_path'] as String)
          .toList();
    }

    // Método para mostrar el tipo de evento traducido
    String checkTypeEvent(String type) {
      switch (type) {
        case 'events':
          return 'Eventos';
        case 'national':
          return 'Nacional';
        case 'community':
          return 'Comunidad';
        default:
          return '';
      }
    }

    Widget content = Container(
      constraints: const BoxConstraints(
        maxHeight: double.infinity,
        maxWidth: 1024,
      ),
      child: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          // Título localizado
          Text(
            getLocalizedField('title'), // Usando el título localizado
            style: const TextStyle(fontSize: 28),
          ),
          const SizedBox(height: 20),
          FutureBuilder<List<String>>(
            future: getImagesBlog('${event.id}'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                return const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.broken_image, size: 100.0, color: Colors.grey),
                    SizedBox(height: 10),
                    Text(
                      'No hay imágenes disponibles',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              } else if (snapshot.data!.length > 1) {
                return CarouselSlider(
                  options: CarouselOptions(
                    autoPlay: true,
                    aspectRatio: 2.0,
                    enlargeCenterPage: true,
                  ),
                  items:
                      snapshot.data!.map((imgUrl) {
                        return Builder(
                          builder: (BuildContext context) {
                            return GestureDetector(
                              onTap: () {
                                _showZoomableImage(context, imgUrl);
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 5.0,
                                ),
                                child: Image.network(imgUrl, fit: BoxFit.cover),
                              ),
                            );
                          },
                        );
                      }).toList(),
                );
              } else {
                return Image.network(snapshot.data!.first, fit: BoxFit.cover);
              }
            },
          ),
          const SizedBox(height: 20),
          if (event.eventDate != null)
            ListTile(
              title: Text(AppLocalizations.of(context)!.event_date),
              subtitle: Text(
                DateFormat('dd/MM/yyyy HH:mm a').format(event.eventDate!),
              ),
              subtitleTextStyle: const TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          if (event.eventTypeId != null)
            ListTile(
              title: Text(AppLocalizations.of(context)!.event_type),
              subtitle: Text(checkTypeEvent(event.eventTypeId.toString())),
              subtitleTextStyle: const TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.description),
            subtitle: Html(
              data: getLocalizedField('body'), // Usar el body localizado
              style: {"*": Style(color: Colors.black, fontSize: FontSize(18))},
            ),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.city),
            subtitle: Text(event.city),
            subtitleTextStyle: const TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
          if (event.sourceLink != null)
            InkWell(
              onTap: () async {
                final Uri url = Uri.parse(event.sourceLink!);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  throw 'No se pudo abrir $url';
                }
              },
              child: ListTile(
                title: const Text('Link'),
                subtitle: Text(event.sourceLink!),
                subtitleTextStyle: const TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(shadowColor: Colors.transparent),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // Si estamos en web, centramos el contenido; de lo contrario, se muestra de forma normal.
        child: kIsWeb ? Center(child: content) : content,
      ),
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
                child: Image.network(imagePath, fit: BoxFit.contain),
              ),
            ),
          ),
        );
      },
    );
  }
}
