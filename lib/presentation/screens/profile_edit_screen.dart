import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:milmujeres_app/domain/entities/user.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:milmujeres_app/presentation/bloc/countries/countries_bloc.dart';
import 'package:milmujeres_app/widgets/widgets.dart';

// Pantalla de edicion de perfil, muestra las opciones
class EditProfileScreen extends StatelessWidget {
  final User user;
  const EditProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final translation = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(translation.edit_profile)),
      body: ListView(
        padding: const EdgeInsets.all(25.0),
        children: [
          _buildEditCard(
            context,
            title: translation.basic_information,
            icon: Icons.person_outline,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) =>
                          EditBasicScreen(translation: translation, user: user),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildEditCard(
            context,
            title: translation.emails,
            icon: Icons.email_outlined,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => EditEmailsScreen(user: user)),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildEditCard(
            context,
            title: translation.phones,
            icon: Icons.phone_outlined,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => EditPhonesScreen(user: user)),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildEditCard(
            context,
            title: translation.addresses,
            icon: Icons.location_on_outlined,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditAddressesScreen(user: user),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEditCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: theme.primaryColor),
        title: Text(title),
        trailing: Icon(Icons.edit_outlined, color: theme.primaryColor),
        onTap: onTap,
      ),
    );
  }
}

// Pantalla relacionada a la informacion basica, solo se edita
class EditBasicScreen extends StatefulWidget {
  const EditBasicScreen({
    super.key,
    required this.translation,
    required this.user,
  });

  final AppLocalizations translation;
  final User user;

  @override
  State<EditBasicScreen> createState() => _EditBasicScreenState();
}

class _EditBasicScreenState extends State<EditBasicScreen> {
  late final TextEditingController firstNameController;
  late final TextEditingController middleNameController;
  late final TextEditingController lastNameController;
  late final CountriesBloc countriesBloc;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController(text: widget.user.firstName);
    middleNameController = TextEditingController(text: widget.user.middleName);
    lastNameController = TextEditingController(text: widget.user.lastName);
    countriesBloc = CountriesBloc()..add(GetCountriesAndCitizenships());
  }

  @override
  void dispose() {
    countriesBloc.close();
    firstNameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: countriesBloc,
      child: BlocBuilder<CountriesBloc, CountriesState>(
        builder: (context, state) {
          if (state is CountriesLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is CountriesError) {
            return Scaffold(body: Center(child: Text(state.message)));
          }

          if (state is CountriesSucess) {
            return Scaffold(
              appBar: AppBar(title: Text(widget.translation.basic_information)),
              body: ListView(
                padding: const EdgeInsets.all(25.0),
                children: [
                  EditableField(
                    label: widget.translation.first_name,
                    controller: firstNameController,
                  ),
                  const SizedBox(height: 12),
                  EditableField(
                    label: widget.translation.middle_name,
                    controller: middleNameController,
                  ),
                  const SizedBox(height: 12),
                  EditableField(
                    label: widget.translation.last_name,
                    controller: lastNameController,
                  ),
                  const SizedBox(height: 12),
                  EditableDropdownField(
                    label: widget.translation.country_birth,
                    value: widget.user.countryOfBirthId,
                    entries:
                        state.countries
                            .map((e) => MapEntry(e.id, e.name))
                            .toList(),
                    onChanged: (value) => widget.user.countryOfBirthId = value,
                  ),
                  const SizedBox(height: 12),
                  EditableDropdownField(
                    label: widget.translation.citizenship,
                    value: widget.user.citizenshipId,
                    entries:
                        state.citizenships
                            .map((e) => MapEntry(e.id, e.name))
                            .toList(),
                    onChanged: (value) => widget.user.citizenshipId = value,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      widget.user.firstName = firstNameController.text.trim();
                      widget.user.middleName = middleNameController.text.trim();
                      widget.user.lastName = lastNameController.text.trim();
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.save),
                    label: Text(AppLocalizations.of(context)!.save),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// Pantalla relacionada a los emails, las lista, agregar y editar
class EditEmailsScreen extends StatelessWidget {
  final User user;
  const EditEmailsScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final translation = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(translation.emails)),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () {
          String newEmail = '';
          String newNote = '';
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder:
                (_) => Padding(
                  padding: EdgeInsets.all(25.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          labelText: translation.email,
                        ),
                        onChanged: (value) => newEmail = value,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        decoration: InputDecoration(
                          labelText: translation.note,
                        ),
                        onChanged: (value) => newNote = value,
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          // TODO: lógica para agregar nuevo email a user.emails
                          Navigator.pop(context);
                        },
                        child: Text(translation.save),
                      ),
                    ],
                  ),
                ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: user.emails.length,
        itemBuilder: (context, index) {
          final email = user.emails[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(Icons.email_outlined),
              title: Text(email.email),
              subtitle: email.note != null ? Text(email.note!) : null,
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  // lógica de eliminación
                },
              ),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder:
                      (_) => Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                          left: 16,
                          right: 16,
                          top: 24,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: TextEditingController(
                                text: email.email,
                              ),
                              decoration: InputDecoration(
                                labelText: translation.email,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: TextEditingController(
                                text: email.note,
                              ),
                              decoration: InputDecoration(
                                labelText: translation.note,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(translation.save),
                            ),
                          ],
                        ),
                      ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// Pantalla relacionada a los telefonos, agregar y editar
class EditPhonesScreen extends StatelessWidget {
  final User user;
  const EditPhonesScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final translation = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(translation.phones)),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder:
                (_) => StatefulBuilder(
                  builder: (context, setModalState) {
                    final phoneController = TextEditingController();
                    bool isUnsafe = false;

                    return Padding(
                      padding: EdgeInsets.all(25.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: phoneController,
                            decoration: InputDecoration(
                              labelText: translation.phone,
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                          SwitchListTile(
                            title: Text(translation.unsafe),
                            value: isUnsafe,
                            onChanged: (value) {
                              setModalState(() => isUnsafe = value);
                            },
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              final newPhone = phoneController.text.trim();
                              if (newPhone.isNotEmpty) {
                                // Aquí deberías llamar a tu lógica para agregar el nuevo teléfono
                                // Ejemplo (si estuvieras usando BLoC o similar):
                                // context.read<AuthBloc>().add(AddPhoneRequested(newPhone, isUnsafe));

                                Navigator.pop(context);
                              }
                            },
                            child: Text(translation.save),
                          ),
                        ],
                      ),
                    );
                  },
                ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: user.phones.length,
        itemBuilder: (context, index) {
          final phone = user.phones[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(Icons.phone_android),
              title: Text(phone.phone),
              subtitle: Text(
                '${translation.insecure}: ${phone.unsafe ? translation.yes : translation.no}',
                style: TextStyle(
                  color: phone.unsafe ? Colors.red : Colors.green,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  // lógica de eliminación
                },
              ),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder:
                      (_) => StatefulBuilder(
                        builder: (context, setModalState) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom:
                                  MediaQuery.of(context).viewInsets.bottom + 16,
                              left: 16,
                              right: 16,
                              top: 24,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: TextEditingController(
                                    text: phone.phone,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: translation.phone,
                                  ),
                                ),
                                SwitchListTile(
                                  title: Text(translation.unsafe),
                                  value: phone.unsafe,
                                  onChanged: (value) {
                                    setModalState(() => phone.unsafe = value);
                                  },
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(translation.save),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// Pantalla relacionada a las direcciones, las lista, agregar y editar
class EditAddressesScreen extends StatelessWidget {
  final User user;
  const EditAddressesScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final translation = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(translation.addresses)),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder:
                (_) => StatefulBuilder(
                  builder: (context, setModalState) {
                    // Variables locales del modal
                    final TextEditingController addressController =
                        TextEditingController();
                    bool isUnsafe = false;

                    return Padding(
                      padding: EdgeInsets.all(25.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextField(
                            controller: addressController,
                            decoration: InputDecoration(
                              labelText: translation.address,
                              border: const OutlineInputBorder(),
                            ),
                          ),

                          const SizedBox(height: 16),

                          SwitchListTile(
                            title: Text(translation.unsafe),
                            value: isUnsafe,
                            onChanged:
                                (value) =>
                                    setModalState(() => isUnsafe = value),
                          ),

                          const SizedBox(height: 16),

                          SwitchListTile(
                            title: Text(translation.physical_address),
                            value: false,
                            onChanged:
                                (value) =>
                                    setModalState(() => isUnsafe = value),
                          ),

                          const SizedBox(height: 16),

                          SwitchListTile(
                            title: Text(translation.mailing_address),
                            value: false,
                            onChanged:
                                (value) =>
                                    setModalState(() => isUnsafe = value),
                          ),

                          const SizedBox(height: 16),

                          ElevatedButton.icon(
                            icon: const Icon(Icons.save),
                            onPressed: () {
                              final newAddress = addressController.text.trim();
                              if (newAddress.isNotEmpty) {
                                // Aquí podrías usar Bloc, setState, etc.
                                // print(
                                //   'Guardar dirección: $newAddress | Insegura: $isUnsafe',
                                // );
                                Navigator.pop(context);
                              }
                            },
                            label: Text(translation.save),
                          ),
                        ],
                      ),
                    );
                  },
                ),
          );
        },
        child: const Icon(Icons.add),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: user.address.length,
        itemBuilder: (context, index) {
          final address = user.address[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(Icons.location_on_outlined),
              title: Text(address.address),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${translation.physical_address}: ${address.physicalAddress ? translation.yes : translation.no}',
                  ),
                  Text(
                    '${translation.mailing_address}: ${address.mailingAddress ? translation.yes : translation.no}',
                  ),
                  Text(
                    '${translation.unsafe}: ${address.unsafe ? translation.yes : translation.no}',
                    style: TextStyle(
                      color: address.unsafe ? Colors.red : Colors.green,
                    ),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  // lógica de eliminación
                },
              ),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder:
                      (_) => StatefulBuilder(
                        builder: (context, setModalState) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom:
                                  MediaQuery.of(context).viewInsets.bottom + 16,
                              left: 16,
                              right: 16,
                              top: 24,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: TextEditingController(
                                    text: address.address,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: translation.address,
                                  ),
                                ),

                                SwitchListTile(
                                  title: Text(translation.physical_address),
                                  value: address.physicalAddress,
                                  onChanged:
                                      (value) => setModalState(
                                        () => address.physicalAddress = value,
                                      ),
                                ),
                                SwitchListTile(
                                  title: Text(translation.mailing_address),
                                  value: address.mailingAddress,
                                  onChanged:
                                      (value) => setModalState(
                                        () => address.mailingAddress = value,
                                      ),
                                ),
                                SwitchListTile(
                                  title: Text(translation.unsafe),
                                  value: address.unsafe,
                                  onChanged:
                                      (value) => setModalState(
                                        () => address.unsafe = value,
                                      ),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(translation.save),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
