import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:milmujeres_app/data/data.dart';
import 'package:milmujeres_app/domain/entities/address.dart';
import 'package:milmujeres_app/domain/entities/email.dart';
import 'package:milmujeres_app/domain/entities/phone.dart';
import 'package:milmujeres_app/domain/entities/user.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:milmujeres_app/presentation/bloc/auth/auth_bloc.dart';
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
                  builder: (_) => EditBasicScreen(translation: translation),
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
                MaterialPageRoute(builder: (_) => EditEmailsScreen()),
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
                MaterialPageRoute(builder: (_) => EditPhonesScreen()),
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
                MaterialPageRoute(builder: (_) => EditAddressesScreen()),
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
  const EditBasicScreen({super.key, required this.translation});

  final AppLocalizations translation;

  @override
  State<EditBasicScreen> createState() => _EditBasicScreenState();
}

class _EditBasicScreenState extends State<EditBasicScreen> {
  late final TextEditingController firstNameController;
  late final TextEditingController middleNameController;
  late final TextEditingController lastNameController;
  late final CountriesBloc countriesBloc;
  late User user;
  late final TextEditingController birthDateController;
  DateTime? selectedBirthDate;

  bool initialized = false;

  @override
  void initState() {
    super.initState();
    countriesBloc = CountriesBloc()..add(GetCountriesAndCitizenships());
  }

  void initializeControllers(User currentUser) {
    if (initialized) return;
    user = currentUser;
    firstNameController = TextEditingController(text: user.firstName);
    middleNameController = TextEditingController(text: user.middleName);
    lastNameController = TextEditingController(text: user.lastName);
    birthDateController = TextEditingController(
      text: user.dob != null ? DateFormat('yyyy-MM-dd').format(user.dob!) : '',
    );
    selectedBirthDate = user.dob;

    initialized = true;
  }

  @override
  void dispose() {
    countriesBloc.close();
    firstNameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    birthDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is! AuthAuthenticated) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        initializeControllers(authState.user);

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
                return BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthAuthenticated) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(widget.translation.information_updated),
                        ),
                      );
                    } else if (state is AuthFailure) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.message)));
                    }
                  },
                  child: Scaffold(
                    appBar: AppBar(
                      title: Text(widget.translation.basic_information),
                    ),
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
                          value: user.countryOfBirthId,
                          entries:
                              state.countries
                                  .map((e) => MapEntry(e.id, e.name))
                                  .toList(),
                          onChanged: (value) => user.countryOfBirthId = value,
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: birthDateController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: widget.translation.date_birth,
                            border: const OutlineInputBorder(),
                            suffixIcon: const Icon(Icons.calendar_today),
                          ),
                          onTap: () async {
                            final now = DateTime.now();
                            final initialDate =
                                selectedBirthDate ?? DateTime(now.year - 18);
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: initialDate,
                              firstDate: DateTime(1900),
                              lastDate: now,
                            );

                            if (pickedDate != null) {
                              setState(() {
                                selectedBirthDate = pickedDate;
                                birthDateController.text = DateFormat(
                                  'yyyy-MM-dd',
                                ).format(pickedDate);
                                user.dob = pickedDate;
                              });
                            }
                          },
                        ),

                        const SizedBox(height: 12),
                        EditableDropdownField(
                          label: widget.translation.citizenship,
                          value: user.citizenshipId,
                          entries:
                              state.citizenships
                                  .map((e) => MapEntry(e.id, e.name))
                                  .toList(),
                          onChanged: (value) => user.citizenshipId = value,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () {
                            user.firstName = firstNameController.text.trim();
                            user.middleName = middleNameController.text.trim();
                            user.lastName = lastNameController.text.trim();
                            user.dob = selectedBirthDate;

                            context.read<AuthBloc>().add(
                              EditProfileRequested(user.id.toString(), {
                                'firstname': user.firstName,
                                'middlename': user.middleName,
                                'lastname': user.lastName,
                                'country_of_birth_id': user.countryOfBirthId,
                                'dob':
                                    user.dob != null
                                        ? DateFormat(
                                          'yyyy-MM-dd',
                                        ).format(user.dob!)
                                        : null,
                                'citizenship_id': user.citizenshipId,
                                'client_id': user.id,
                                'client': getPlatform(),
                              }),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  widget.translation.information_updated,
                                ),
                              ),
                            );
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.save),
                          label: Text(AppLocalizations.of(context)!.save),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        );
      },
    );
  }
}

class EditEmailsScreen extends StatelessWidget {
  const EditEmailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final translation = AppLocalizations.of(context)!;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is! AuthAuthenticated) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = state.user;

        return Scaffold(
          appBar: AppBar(title: Text(translation.emails)),
          floatingActionButton: FloatingActionButton(
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            backgroundColor: Theme.of(context).colorScheme.primary,
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder:
                    (_) => GenericEditModal<Email>(
                      itemKey: 'emails',
                      getCurrentItems: (user) => user.emails,
                      title: translation.email,
                      initialValues: {'email': '', 'note': ''},
                      originalItem: null,
                      fields: [
                        FormFieldConfig(
                          name: 'email',
                          label: translation.email,
                          type: FieldType.text,
                        ),
                        FormFieldConfig(
                          name: 'note',
                          label: translation.note,
                          type: FieldType.text,
                        ),
                      ],
                      builder:
                          (values) => Email(
                            email: values['email'],
                            note: values['note'],
                          ),
                      onSave: (_) {},
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
                      final updatedEmails = [...user.emails]..removeAt(index);

                      if (updatedEmails.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              AppLocalizations.of(
                                context,
                              )!.at_least_one_required,
                            ),
                          ),
                        );
                        return;
                      }

                      context.read<AuthBloc>().add(
                        EditProfileRequested(user.id.toString(), {
                          'emails':
                              updatedEmails.map((e) => e.toJson()).toList(),
                          'client_id': user.id,
                          'client': getPlatform(),
                        }),
                      );
                    },
                  ),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder:
                          (_) => GenericEditModal<Email>(
                            itemKey: 'emails',
                            getCurrentItems: (user) => user.emails,
                            title: translation.email,
                            initialValues: {
                              'email': email.email,
                              'note': email.note ?? '',
                            },
                            originalItem: email,
                            fields: [
                              FormFieldConfig(
                                name: 'email',
                                label: translation.email,
                                type: FieldType.text,
                              ),
                              FormFieldConfig(
                                name: 'note',
                                label: translation.note,
                                type: FieldType.text,
                              ),
                            ],
                            builder:
                                (values) => Email(
                                  email: values['email'],
                                  note: values['note'],
                                ),
                            onSave: (_) {},
                          ),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// Pantalla relacionada a los telefonos, agregar y editar
class EditPhonesScreen extends StatelessWidget {
  const EditPhonesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final translation = AppLocalizations.of(context)!;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is! AuthAuthenticated) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = state.user;

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
                    (_) => GenericEditModal<Phone>(
                      itemKey: 'phones',
                      getCurrentItems: (user) => user.phones,
                      title: translation.phone,
                      initialValues: {'phone': '', 'unsafe': false},
                      originalItem: null,
                      fields: [
                        FormFieldConfig(
                          name: 'phone',
                          label: translation.phone,
                          type: FieldType.text,
                        ),
                        FormFieldConfig(
                          name: 'unsafe',
                          label: translation.insecure,
                          type: FieldType.bool,
                        ),
                      ],
                      builder:
                          (values) => Phone(
                            phone: values['phone'],
                            unsafe: values['unsafe'],
                          ),
                      onSave: (_) {},
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
                      final updatedPhones = [...user.phones]..removeAt(index);

                      if (updatedPhones.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              AppLocalizations.of(
                                context,
                              )!.at_least_one_required,
                            ),
                          ),
                        );
                        return;
                      }
                      context.read<AuthBloc>().add(
                        EditProfileRequested(user.id.toString(), {
                          'phones':
                              updatedPhones.map((e) => e.toJson()).toList(),
                          'client_id': user.id,
                          'client': getPlatform(),
                        }),
                      );
                    },
                  ),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder:
                          (_) => GenericEditModal<Phone>(
                            itemKey: 'phones',
                            getCurrentItems: (user) => user.phones,
                            title: translation.phone,
                            initialValues: {
                              'phone': phone.phone,
                              'unsafe': phone.unsafe,
                            },
                            originalItem: phone,
                            fields: [
                              FormFieldConfig(
                                name: 'phone',
                                label: translation.phone,
                                type: FieldType.text,
                              ),
                              FormFieldConfig(
                                name: 'unsafe',
                                label: translation.insecure,
                                type: FieldType.bool,
                              ),
                            ],
                            builder:
                                (values) => Phone(
                                  phone: values['phone'],
                                  unsafe: values['unsafe'],
                                ),
                            onSave: (_) {},
                          ),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// Pantalla relacionada a las direcciones, las lista, agregar y editarclass
class EditAddressesScreen extends StatelessWidget {
  const EditAddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final translation = AppLocalizations.of(context)!;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is! AuthAuthenticated) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = state.user;

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
                    (_) => GenericEditModal<Address>(
                      title: translation.address,
                      itemKey: 'address',
                      getCurrentItems: (user) => user.addresses,
                      originalItem: null,
                      initialValues: {
                        'address': '',
                        'unsafe': false,
                        'physicalAddress': false,
                        'mailingAddress': false,
                      },
                      fields: [
                        FormFieldConfig(
                          name: 'address',
                          label: translation.address,
                          type: FieldType.text,
                        ),
                        FormFieldConfig(
                          name: 'unsafe',
                          label: translation.unsafe,
                          type: FieldType.bool,
                        ),
                        FormFieldConfig(
                          name: 'physicalAddress',
                          label: translation.physical_address,
                          type: FieldType.bool,
                        ),
                        FormFieldConfig(
                          name: 'mailingAddress',
                          label: translation.mailing_address,
                          type: FieldType.bool,
                        ),
                      ],
                      builder:
                          (values) => Address(
                            address: values['address'],
                            unsafe: values['unsafe'],
                            physicalAddress: values['physicalAddress'],
                            mailingAddress: values['mailingAddress'],
                          ),
                      onSave: (_) {},
                    ),
              );
            },
            child: const Icon(Icons.add),
          ),
          body: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: user.addresses.length,
            itemBuilder: (context, index) {
              final address = user.addresses[index];
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
                      final updatedAddresses = [...user.addresses]
                        ..removeAt(index);

                      if (updatedAddresses.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              AppLocalizations.of(
                                context,
                              )!.at_least_one_required,
                            ),
                          ),
                        );
                        return;
                      }
                      context.read<AuthBloc>().add(
                        EditProfileRequested(user.id.toString(), {
                          'address':
                              updatedAddresses.map((e) => e.toJson()).toList(),
                          'client_id': user.id,
                          'client': getPlatform(),
                        }),
                      );
                    },
                  ),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder:
                          (_) => GenericEditModal<Address>(
                            title: translation.address,
                            itemKey: 'address',
                            getCurrentItems: (user) => user.addresses,
                            initialValues: {
                              'address': address.address,
                              'unsafe': address.unsafe,
                              'physicalAddress': address.physicalAddress,
                              'mailingAddress': address.mailingAddress,
                            },
                            originalItem: address,
                            fields: [
                              FormFieldConfig(
                                name: 'address',
                                label: translation.address,
                                type: FieldType.text,
                              ),
                              FormFieldConfig(
                                name: 'unsafe',
                                label: translation.unsafe,
                                type: FieldType.bool,
                              ),
                              FormFieldConfig(
                                name: 'physicalAddress',
                                label: translation.physical_address,
                                type: FieldType.bool,
                              ),
                              FormFieldConfig(
                                name: 'mailingAddress',
                                label: translation.mailing_address,
                                type: FieldType.bool,
                              ),
                            ],
                            builder:
                                (values) => Address(
                                  address: values['address'],
                                  unsafe: values['unsafe'],
                                  physicalAddress: values['physicalAddress'],
                                  mailingAddress: values['mailingAddress'],
                                ),
                            onSave: (_) {},
                          ),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class GenericEditModal<T> extends StatefulWidget {
  final String title;
  final Map<String, dynamic> initialValues;
  final List<FormFieldConfig> fields;
  final void Function(T) onSave;
  final T Function(Map<String, dynamic> values) builder;
  final String itemKey; // 'emails', 'phones', 'addresses'
  final List<T> Function(User user) getCurrentItems;
  final T? originalItem;

  const GenericEditModal({
    super.key,
    required this.title,
    required this.initialValues,
    required this.fields,
    required this.onSave,
    required this.builder,
    required this.itemKey,
    required this.getCurrentItems,
    this.originalItem,
  });

  @override
  State<GenericEditModal<T>> createState() => _GenericEditModalState<T>();
}

class _GenericEditModalState<T> extends State<GenericEditModal<T>> {
  late Map<String, dynamic> _values;
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _values = Map.of(widget.initialValues);
    for (var field in widget.fields) {
      if (field.type == FieldType.text) {
        _controllers[field.name] = TextEditingController(
          text: _values[field.name]?.toString() ?? '',
        );
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final translation = AppLocalizations.of(context)!;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(translation.information_updated)),
          );
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          left: 16,
          right: 16,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            ...widget.fields.map((field) {
              switch (field.type) {
                case FieldType.text:
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TextField(
                      controller: _controllers[field.name],
                      decoration: InputDecoration(labelText: field.label),
                      onChanged: (val) => _values[field.name] = val,
                    ),
                  );
                case FieldType.bool:
                  return SwitchListTile(
                    title: Text(field.label),
                    value: _values[field.name] ?? false,
                    onChanged:
                        (val) => setState(() => _values[field.name] = val),
                  );
              }
            }),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                for (var entry in _controllers.entries) {
                  _values[entry.key] = entry.value.text.trim();
                }

                final newItem = widget.builder(_values);

                final authState = context.read<AuthBloc>().state;
                if (authState is AuthAuthenticated) {
                  final user = authState.user;
                  final currentList = widget.getCurrentItems(user);

                  final updatedList =
                      widget.originalItem == null
                          ? [...currentList, newItem]
                          : currentList.map((e) {
                            if (e == widget.originalItem) {
                              return newItem;
                            }
                            return e;
                          }).toList();

                  // ✅ Validar que no quede vacía
                  if (updatedList.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(translation.at_least_one_required),
                      ),
                    );
                    return;
                  }

                  context.read<AuthBloc>().add(
                    EditProfileRequested(user.id.toString(), {
                      widget.itemKey:
                          updatedList.map((e) {
                            if (e is Email) return e.toJson();
                            if (e is Phone) return e.toJson();
                            if (e is Address) return e.toJson();
                            return {};
                          }).toList(),
                      'client_id': user.id,
                      'client': getPlatform(),
                    }),
                  );

                  Navigator.of(context).pop();
                }
              },
              child: Text(translation.save),
            ),
          ],
        ),
      ),
    );
  }
}
