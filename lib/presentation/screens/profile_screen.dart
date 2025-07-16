import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:milmujeres_app/domain/entities/citizenship.dart';
import 'package:milmujeres_app/domain/entities/country.dart';
import 'package:milmujeres_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:milmujeres_app/presentation/bloc/countries/countries_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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

          return BlocBuilder<CountriesBloc, CountriesState>(
            builder: (context, countriesState) {
              String? countryName;
              String? citizenshipName;

              if (countriesState is CountriesLoaded) {
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

              return Scaffold(
                appBar: AppBar(
                  title: Text(translation.profile),
                  // actions: [
                  //   IconButton(
                  //     icon: const Icon(Icons.edit),
                  //     tooltip: translation.edit,
                  //     onPressed: () {
                  //       // Abre tu pantalla de edición
                  //       // Navigator.pushNamed(context, '/editProfile');
                  //     },
                  //   ),
                  //],
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
                                Text(user.userName),
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
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildItem(translation.name, fullName, context),

                              if (user.dob != null)
                                _buildItem(
                                  translation.date_birth,
                                  '${user.dob!.day}/${user.dob!.month}/${user.dob!.year}',
                                  context,
                                ),
                              if (countryName != null)
                                _buildItem(
                                  translation.country_birth,
                                  countryName,
                                  context,
                                ),
                              if (citizenshipName != null)
                                _buildItem(
                                  translation.citizenship,
                                  citizenshipName,
                                  context,
                                ),
                              if (user.phone?.isNotEmpty == true)
                                _buildItem(
                                  translation.phone,
                                  user.phone!,
                                  context,
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
                      if (user.address.isNotEmpty)
                        _buildCardSectionCustom(
                          title: translation.addresses,
                          icon: Icons.location_on_outlined,
                          context: context,
                          children:
                              user.address.map((address) {
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
