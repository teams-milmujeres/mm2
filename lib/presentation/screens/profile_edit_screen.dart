import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:milmujeres_app/domain/entities/user.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:milmujeres_app/presentation/bloc/countries/countries_bloc.dart';

class EditProfileScreen extends StatelessWidget {
  final User user;
  const EditProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final translation = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(translation.edit_profile)),
      body: ListView(
        padding: const EdgeInsets.all(16),
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
                      (_) => BlocProvider(
                        create:
                            (context) =>
                                CountriesBloc()
                                  ..add(GetCountriesAndCitizenships()),

                        child: BlocBuilder<CountriesBloc, CountriesState>(
                          builder: (context, state) {
                            if (state is CountriesLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (state is CountriesError) {
                              return Center(child: Text(state.message));
                            } else if (state is CountriesSucess) {
                              return EditSectionScreen(
                                title: translation.basic_information,
                                fields: [
                                  EditableField(
                                    label: translation.first_name,
                                    controller: TextEditingController(
                                      text: user.firstName,
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  EditableField(
                                    label: translation.middle_name,
                                    controller: TextEditingController(
                                      text: user.middleName,
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  EditableField(
                                    label: translation.last_name,
                                    controller: TextEditingController(
                                      text: user.lastName,
                                    ),
                                  ),
                                  SizedBox(height: 12),

                                  const SizedBox(height: 12),
                                  EditableDropdownField(
                                    label: translation.country_birth,
                                    value: user.countryOfBirthId,
                                    items:
                                        state.countries.map((country) {
                                          return DropdownMenuItem(
                                            value: country.id,
                                            child: Text(country.name),
                                          );
                                        }).toList(),
                                    onChanged:
                                        (value) =>
                                            user.countryOfBirthId = value,
                                  ),

                                  const SizedBox(height: 12),

                                  EditableDropdownField(
                                    label: translation.citizenship,
                                    value: user.citizenshipId,
                                    items:
                                        state.citizenships.map((citizenship) {
                                          return DropdownMenuItem(
                                            value: citizenship.id,
                                            child: Text(citizenship.name),
                                          );
                                        }).toList(),
                                    onChanged:
                                        (value) => user.citizenshipId = value,
                                  ),
                                ],
                                onSave: () {
                                  Navigator.pop(context);
                                },
                              );
                            } else {
                              return SizedBox.shrink();
                            }
                          },
                        ),
                      ),
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

class EditableField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const EditableField({
    super.key,
    required this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
    );
  }
}

class EditableDropdownField extends StatelessWidget {
  final String label;
  final int? value;
  final List<DropdownMenuItem<int>> items;
  final ValueChanged<int?> onChanged;

  const EditableDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<int?>(
      label: Text(label),
      initialSelection: value,
      dropdownMenuEntries:
          items
              .map(
                (item) => DropdownMenuEntry<int?>(
                  value: item.value,
                  label:
                      item.child is Text ? (item.child as Text).data ?? '' : '',
                ),
              )
              .toList(),
      onSelected: onChanged,
    );
  }
}

class EditSectionScreen extends StatelessWidget {
  final String title;
  final List<Widget> fields;
  final VoidCallback onSave;

  const EditSectionScreen({
    super.key,
    required this.title,
    required this.fields,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final translation = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...fields,
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onSave,
            icon: const Icon(Icons.save),
            label: Text(translation.save),
          ),
        ],
      ),
    );
  }
}

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
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                        left: 16,
                        right: 16,
                        top: 24,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            translation.address,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),

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
