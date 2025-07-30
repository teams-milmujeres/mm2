import 'package:flutter/material.dart';
// Bloc
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:milmujeres_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:milmujeres_app/presentation/bloc/countries/countries_bloc.dart';
// Entities
import 'package:milmujeres_app/domain/entities/citizenship.dart';
import 'package:milmujeres_app/domain/entities/country.dart';
import 'package:milmujeres_app/presentation/constants.dart';
// Screens
import 'package:milmujeres_app/presentation/screens.dart';
// Localization
import 'package:milmujeres_app/l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _modalShown = false;
  @override
  Widget build(BuildContext context) {
    final translation = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => CountriesBloc()..add(GetCountriesAndCitizenships()),
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState is! AuthAuthenticated) {
            return const SizedBox.shrink();
          }
          final user = authState.user;
          final fullName =
              '${user.firstName} ${user.middleName ?? ''} ${user.lastName}';

          // Obtener el nombre del país de nacimiento y la ciudadanía
          return BlocBuilder<CountriesBloc, CountriesState>(
            builder: (context, countriesState) {
              String? countryName;
              String? citizenshipName;

              if (countriesState is CountriesSucess) {
                if (user.countryOfBirthId != null) {
                  countryName =
                      countriesState.countries
                          .firstWhere(
                            (c) => c.id == user.countryOfBirthId,
                            orElse:
                                () =>
                                    Country(id: 0, name: 'N/A', abbrev: 'N/A'),
                          )
                          .name;
                }
                if (user.citizenshipId != null) {
                  citizenshipName =
                      countriesState.citizenships
                          .firstWhere(
                            (c) => c.id == user.citizenshipId,
                            orElse: () => Citizenship(id: 0, name: 'N/A'),
                          )
                          .name;
                }
              }

              // Validar campos vacíos y mostrar modal si es necesario
              validateEmptyFields(
                context,
                user,
                countryName,
                citizenshipName,
                translation,
              );

              return Scaffold(
                appBar: AppBar(title: Text(translation.profile)),
                floatingActionButton: FloatingActionButton(
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfileScreen(user: user),
                      ),
                    );
                  },
                  child: const Icon(Icons.edit),
                ),
                body: SingleChildScrollView(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar con iniciales
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: MediaQuery.of(context).size.width * 0.2,
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              child: Text(
                                '${user.firstName[0].toUpperCase()}${user.lastName[0].toUpperCase()}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 50,
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              user.email,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${translation.username}: ',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  user.userName ?? 'N/A',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        translation.basic_information,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),

                      // Card con información principal
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildRequiredItem(
                                context: context,
                                label: translation.name,
                                value: fullName,
                              ),
                              buildRequiredItem(
                                context: context,
                                label: translation.date_birth,
                                value:
                                    user.dob != null
                                        ? '${user.dob!.day}/${user.dob!.month}/${user.dob!.year}'
                                        : null,
                              ),
                              buildRequiredItem(
                                context: context,
                                label: translation.country_birth,
                                value: countryName,
                              ),
                              buildRequiredItem(
                                context: context,
                                label: translation.citizenship,
                                value: citizenshipName,
                              ),
                              if (user.phone?.isNotEmpty == true)
                                _buildItem(
                                  translation.phone,
                                  user.phone!,
                                  context,
                                ),
                              buildRequiredItem(
                                context: context,
                                label: translation.how_meet,
                                value: getMeansText(user.howMeet),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Correos secundarios
                      if (user.emails.isNotEmpty)
                        _buildCardSectionCustom(
                          title: translation.emails,
                          icon: Icons.email_outlined,
                          context: context,
                          children:
                              user.emails.map((email) {
                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ExpansionTile(
                                    leading: const Icon(Icons.email_outlined),
                                    title: Text(email.email.toString()),
                                    childrenPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    children: [
                                      if (email.note != null &&
                                          email.note
                                              .toString()
                                              .trim()
                                              .isNotEmpty)
                                        _buildItem(
                                          translation.note,
                                          email.note.toString(),
                                          context,
                                        ),

                                      SizedBox(height: 10),
                                    ],
                                  ),
                                );
                              }).toList(),
                        ),

                      // Teléfonos secundarios
                      if (user.phones.isNotEmpty)
                        _buildCardSectionCustom(
                          title: translation.phones,
                          icon: Icons.phone_android,
                          context: context,
                          children:
                              user.phones.map((phone) {
                                final isUnsafe = phone.unsafe;
                                return Card(
                                  color: isUnsafe ? Colors.red[100] : null,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ExpansionTile(
                                    leading: const Icon(Icons.phone_android),
                                    title: Text(phone.phone),
                                    childrenPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    children: [
                                      _buildItem(
                                        translation.insecure,
                                        isUnsafe
                                            ? translation.yes
                                            : translation.no,
                                        context,
                                        valueColor:
                                            isUnsafe
                                                ? Colors.red
                                                : Colors.green,
                                      ),
                                      SizedBox(height: 8),
                                    ],
                                  ),
                                );
                              }).toList(),
                        ),

                      // Direcciones
                      if (user.addresses.isNotEmpty)
                        _buildCardSectionCustom(
                          title: translation.addresses,
                          icon: Icons.location_on_outlined,
                          context: context,
                          children:
                              user.addresses.map((address) {
                                final isUnsafe = address.unsafe;
                                return Card(
                                  color: isUnsafe ? Colors.red[50] : null,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ExpansionTile(
                                    leading: const Icon(
                                      Icons.location_on_outlined,
                                    ),
                                    title: Text(address.address),
                                    childrenPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    children: [
                                      _buildItem(
                                        translation.unsafe,
                                        isUnsafe
                                            ? translation.yes
                                            : translation.no,
                                        context,
                                        valueColor:
                                            isUnsafe
                                                ? Colors.red
                                                : Colors.green,
                                      ),
                                      _buildItem(
                                        translation.mailing_address,
                                        address.mailingAddress
                                            ? translation.yes
                                            : translation.no,
                                        context,
                                      ),
                                      _buildItem(
                                        translation.physical_address,
                                        address.physicalAddress
                                            ? translation.yes
                                            : translation.no,
                                        context,
                                      ),
                                      SizedBox(height: 10),
                                    ],
                                  ),
                                );
                              }).toList(),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String getMeansText(String? value) {
    if (value == null || value.isEmpty) return 'N/A';
    final match = means.firstWhere(
      (item) => item['value'] == value,
      orElse: () => const {'value': '', 'text': 'N/A'},
    );
    return match['text']!;
  }

  // Función para validar y mostrar el modal si hay campos vacíos
  void validateEmptyFields(
    BuildContext context,
    dynamic user,
    String? countryName,
    String? citizenshipName,
    AppLocalizations translation,
  ) {
    final camposFaltantes = <String>[];

    if (user.howMeet == null || user.howMeet!.isEmpty) {
      camposFaltantes.add(translation.how_meet);
    }
    if (countryName == null || countryName == 'N/A') {
      camposFaltantes.add(translation.country_birth);
    }
    if (citizenshipName == null || citizenshipName == 'N/A') {
      camposFaltantes.add(translation.citizenship);
    }
    if (user.dob == null) {
      camposFaltantes.add(translation.date_birth);
    }
    if (user.firstName.isEmpty || user.lastName.isEmpty) {
      camposFaltantes.add(translation.name);
    }

    if (camposFaltantes.isNotEmpty && !_modalShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(Icons.warning, color: Colors.red, size: 100),
                  ],
                ),
                content: Text(
                  '${translation.please_complete_information}:\n\n- ${camposFaltantes.join('\n- ')}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.red),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              ),
        );
        _modalShown = true; // Evita que se muestre nuevamente
      });
    }
  }

  Widget buildRequiredItem({
    required BuildContext context,
    required String label,
    required String? value,
  }) {
    final translation = AppLocalizations.of(context)!;
    if (value != null && value.trim().isNotEmpty && value != 'N/A') {
      return _buildItem(label, value, context);
    } else {
      return Text(
        translation.is_required(label),
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      );
    }
  }

  Widget _buildItem(
    String title,
    String value,
    BuildContext context, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title: ',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value, style: TextStyle(color: valueColor))),
        ],
      ),
    );
  }

  Widget _buildCardSectionCustom({
    required String title,
    required IconData icon,
    required List<Widget> children,
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineMedium),
            ],
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }
}
