import 'package:flutter/material.dart';
import 'package:milmujeres_app/domain/entities/user.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                      (_) => EditSectionScreen(
                        title: translation.basic_information,
                        fields: [
                          EditableField(
                            label: translation.name,
                            controller: TextEditingController(
                              text: user.firstName,
                            ),
                          ),
                          EditableField(
                            label: translation.name,
                            controller: TextEditingController(
                              text: user.middleName,
                            ),
                          ),
                          EditableField(
                            label: translation.name,
                            controller: TextEditingController(
                              text: user.lastName,
                            ),
                          ),
                        ],
                        onSave: () {
                          Navigator.pop(context);
                        },
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

class EditableField {
  final String label;
  final TextEditingController controller;
  final bool multiline;
  final bool isRequired;

  EditableField({
    required this.label,
    required this.controller,
    this.multiline = false,
    this.isRequired = true,
  });
}

class EditSectionScreen extends StatelessWidget {
  final String title;
  final List<EditableField> fields;
  final VoidCallback onSave;

  const EditSectionScreen({
    super.key,
    required this.title,
    required this.fields,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: fields.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final field = fields[index];
                  return TextField(
                    controller: field.controller,
                    maxLines: field.multiline ? null : 1,
                    decoration: InputDecoration(
                      labelText: field.label,
                      border: const OutlineInputBorder(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onSave,
              icon: const Icon(Icons.save),
              label: Text(MaterialLocalizations.of(context).saveButtonLabel),
            ),
          ],
        ),
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
                phone.unsafe ? translation.insecure : translation.unsafe,
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
                                text: phone.phone,
                              ),
                              decoration: InputDecoration(
                                labelText: translation.phone,
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

class EditAddressesScreen extends StatelessWidget {
  final User user;
  const EditAddressesScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final translation = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(translation.addresses)),
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
                                text: address.address,
                              ),
                              decoration: InputDecoration(
                                labelText: translation.address,
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
