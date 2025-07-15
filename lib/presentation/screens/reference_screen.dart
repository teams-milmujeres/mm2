import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:milmujeres_app/data/data.dart';
import 'package:milmujeres_app/domain/entities/alliance.dart';
import 'package:milmujeres_app/domain/entities/reference.dart';
import 'package:milmujeres_app/presentation/bloc/alliances/alliances_bloc.dart';
import 'package:milmujeres_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:milmujeres_app/presentation/bloc/references/references_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class ReferenceScreen extends StatefulWidget {
  const ReferenceScreen({super.key});

  @override
  State<ReferenceScreen> createState() => _ReferenceScreenState();
}

class _ReferenceScreenState extends State<ReferenceScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final TextEditingController _allianceSearchController;
  late final TextEditingController _referenceSearchController;
  late final AlliancesBloc _alliancesBloc;
  late final ReferencesBloc _referencesBloc;
  String _token = '';

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _allianceSearchController = TextEditingController();
    _referenceSearchController = TextEditingController();

    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      _token = authState.token;
    }

    _alliancesBloc = AlliancesBloc()..add(FindAlliancesEvent('', _token));
    _referencesBloc = ReferencesBloc()..add(FindReferencesEvent('', _token));

    _tabController.addListener(() {
      if (_tabController.indexIsChanging || !mounted) return;

      if (_tabController.index == 0) {
        _allianceSearchController.clear();
        _alliancesBloc.add(FindAlliancesEvent('', _token));
      } else {
        _referenceSearchController.clear();
        _referencesBloc.add(FindReferencesEvent('', _token));
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _allianceSearchController.dispose();
    _referenceSearchController.dispose();
    _alliancesBloc.close();
    _referencesBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final translation = AppLocalizations.of(context)!;
    final client = DioClient();

    return Scaffold(
      appBar: AppBar(
        title: Text(translation.alliances_references),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: translation.alliances),
            Tab(text: translation.references),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Alliances tab
          BlocProvider.value(
            value: _alliancesBloc,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _allianceSearchController,
                    decoration: InputDecoration(
                      hintText: translation.search,
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onSubmitted: (query) {
                      _alliancesBloc.add(FindAlliancesEvent(query, _token));
                    },
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: BlocBuilder<AlliancesBloc, AlliancesState>(
                      builder: (context, state) {
                        if (state is AlliancesLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is AlliancesSuccess) {
                          final alliances = state.alliances;

                          if (alliances.isEmpty) {
                            return Center(child: Text(translation.no_elements));
                          }

                          return GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.8,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                ),
                            itemCount: alliances.length,
                            itemBuilder: (_, index) {
                              final alliance = alliances[index];
                              final imageUrl = client.buildImageUrl(
                                'alliance_logo/${alliance.id}',
                              );
                              final image =
                                  alliance.logo
                                      ? NetworkImage(imageUrl)
                                      : const AssetImage(
                                            'assets/images/custom-reference.png',
                                          )
                                          as ImageProvider;

                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder:
                                          (_) => AllianceDetailScreen(
                                            alliance: alliance,
                                          ),
                                    ),
                                  );
                                },
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
                                                (_, __, ___) => Image.asset(
                                                  'assets/images/custom-reference.png',
                                                ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          alliance.organization,
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
                          );
                        } else if (state is AlliancesError) {
                          return Center(child: Text(state.message));
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // References tab
          BlocProvider.value(
            value: _referencesBloc,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _referenceSearchController,
                    decoration: InputDecoration(
                      hintText: translation.search,
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onSubmitted: (query) {
                      _referencesBloc.add(FindReferencesEvent(query, _token));
                    },
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: BlocBuilder<ReferencesBloc, ReferencesState>(
                      builder: (context, state) {
                        if (state is ReferencesLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is ReferencesSuccess) {
                          final references = state.references;

                          if (references.isEmpty) {
                            return Center(child: Text(translation.no_elements));
                          }

                          return ListView.builder(
                            itemCount: references.length,
                            itemBuilder: (context, index) {
                              final reference = references[index];
                              final imageUrl = client.buildImageUrl(
                                'reference_logo/${reference.id}',
                              );
                              final image =
                                  reference.logo
                                      ? NetworkImage(imageUrl)
                                      : const AssetImage(
                                            'assets/images/custom-reference.png',
                                          )
                                          as ImageProvider;

                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder:
                                          (_) => ReferenceDetailScreen(
                                            reference: reference,
                                          ),
                                    ),
                                  );
                                },
                                child: Card(
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: image,
                                      onBackgroundImageError: (_, __) {},
                                    ),
                                    title: Text(reference.organization),
                                  ),
                                ),
                              );
                            },
                          );
                        } else if (state is ReferencesError) {
                          return Center(child: Text(state.message));
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AllianceDetailScreen extends StatelessWidget {
  final Alliance alliance;

  const AllianceDetailScreen({super.key, required this.alliance});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final imageUrl =
        alliance.logo
            ? DioClient().buildImageUrl('alliance_logo/${alliance.id}')
            : null;

    return Scaffold(
      appBar: AppBar(title: Text(alliance.organization)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child:
                imageUrl != null
                    ? CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(imageUrl),
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
              alliance.organization,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),

          if (alliance.address?.isNotEmpty == true)
            _ItemTile(
              icon: Icons.location_on,
              label: 'Dirección',
              value: alliance.address!,
            ),
          if (alliance.city?.isNotEmpty == true)
            _ItemTile(
              icon: Icons.location_city,
              label: 'Ciudad',
              value: alliance.city!,
            ),
          if (alliance.phone?.isNotEmpty == true)
            _ItemTile(
              icon: Icons.phone,
              label: 'Teléfono',
              value: alliance.phone!,
            ),
          if (alliance.email?.isNotEmpty == true)
            _ItemTile(
              icon: Icons.email,
              label: 'Email',
              value: alliance.email!,
            ),
          if (alliance.contact?.isNotEmpty == true)
            _ItemTile(
              icon: Icons.person,
              label: 'Contacto',
              value: alliance.contact!,
            ),
          if (alliance.services?.isNotEmpty == true)
            _ItemTile(
              icon: Icons.miscellaneous_services,
              label: 'Servicios',
              value: alliance.services!,
            ),

          if (alliance.website?.isNotEmpty == true)
            ListTile(
              leading: const Icon(Icons.link),
              title: const Text('Sitio web'),
              subtitle: Text(alliance.website!),
              onTap: () => _launchUrl(alliance.website!),
            ),

          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Ubicación'),
            subtitle: Text('${alliance.state.name}, ${alliance.country.name}'),
          ),
        ],
      ),
    );
  }

  static Future<void> _launchUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

class ReferenceDetailScreen extends StatelessWidget {
  final Reference reference;

  const ReferenceDetailScreen({super.key, required this.reference});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final imageUrl =
        reference.logo
            ? DioClient().buildImageUrl('reference_logo/${reference.id}')
            : null;

    return Scaffold(
      appBar: AppBar(title: Text(reference.organization)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child:
                imageUrl != null
                    ? CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(imageUrl),
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
              reference.organization,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),

          if (reference.address?.isNotEmpty == true)
            _ItemTile(
              icon: Icons.location_on,
              label: 'Dirección',
              value: reference.address!,
            ),
          if (reference.city?.isNotEmpty == true)
            _ItemTile(
              icon: Icons.location_city,
              label: 'Ciudad',
              value: reference.city!,
            ),
          if (reference.phone?.isNotEmpty == true)
            _ItemTile(
              icon: Icons.phone,
              label: 'Teléfono',
              value: reference.phone!,
            ),
          if (reference.email?.isNotEmpty == true)
            _ItemTile(
              icon: Icons.email,
              label: 'Email',
              value: reference.email!,
            ),
          if (reference.contacts?.isNotEmpty == true)
            _ItemTile(
              icon: Icons.person,
              label: 'Contacto',
              value: reference.contacts!,
            ),

          if (reference.website?.isNotEmpty == true)
            ListTile(
              leading: const Icon(Icons.link),
              title: const Text('Sitio web'),
              subtitle: Text(reference.website!),
              onTap: () => _launchUrl(reference.website!),
            ),

          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Ubicación'),
            subtitle: Text(
              '${reference.state.name}, ${reference.country.name}',
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> _launchUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

class _ItemTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ItemTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      subtitle: Text(value),
    );
  }
}
