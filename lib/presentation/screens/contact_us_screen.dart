import 'package:flutter/material.dart';
// Bloc
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:milmujeres_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:milmujeres_app/presentation/bloc/contact_us/contact_us_bloc.dart';
// Entities
import 'package:milmujeres_app/domain/entities/contact_us.dart';
// Localization
import 'package:milmujeres_app/l10n/app_localizations.dart';
// Other imports
import 'package:milmujeres_app/widgets/rounded_button_large.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final subjectController = TextEditingController();
  final messageController = TextEditingController();

  String? nameError;
  String? emailError;
  String? subjectError;
  String? messageError;

  bool isAuthenticated = false;
  String? userName;
  String? userEmail;

  @override
  void initState() {
    super.initState();

    final authState = context.read<AuthBloc>().state;

    int? userId;
    if (authState is AuthAuthenticated) {
      isAuthenticated = true;
      userName = "${authState.user.firstName} ${authState.user.lastName}";
      userEmail = authState.user.email;
      userId = userId;
      nameController.text = userName ?? '';
      emailController.text = userEmail ?? '';
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    subjectController.dispose();
    messageController.dispose();
    super.dispose();
  }

  void _validateAndSubmit(BuildContext context) {
    final translation = AppLocalizations.of(context)!;

    setState(() {
      nameError = null;
      emailError = null;
      subjectError = null;
      messageError = null;

      if (!isAuthenticated) {
        if (nameController.text.trim().isEmpty) {
          nameError = translation.is_required(translation.name);
        } else if (nameController.text.length < 2) {
          nameError = translation.fewest_characters(translation.two);
        }

        if (emailController.text.trim().isEmpty) {
          emailError = translation.is_required(translation.email);
        } else if (!RegExp(
          r"^[\w.+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
        ).hasMatch(emailController.text)) {
          emailError = translation.enter_valid(translation.email);
        }
      }

      if (subjectController.text.trim().isEmpty) {
        subjectError = translation.is_required(translation.subject);
      }

      if (messageController.text.trim().isEmpty) {
        messageError = translation.is_required(translation.message);
      } else if (messageController.text.length < 5) {
        messageError = translation.fewest_characters('5');
      }
      if (nameError == null &&
          emailError == null &&
          subjectError == null &&
          messageError == null) {
        // Obtener el estado actual de AuthBloc
        final authState = context.read<AuthBloc>().state;

        // Extraer el userId si está autenticado
        final int userId =
            (authState is AuthAuthenticated) ? authState.user.id : 100;

        final contact = ContactUs(
          name: nameController.text,
          email: emailController.text,
          subject: subjectController.text,
          message: messageController.text,
          userId: userId,
        );

        context.read<ContactUsBloc>().add(SubmitContactUsEvent(contact));
      }
    });
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? errorText,
    int maxLines = 1,
    int? maxLength,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        maxLength: maxLength,
        decoration: InputDecoration(
          labelText: label,
          errorText: errorText,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final translation = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => ContactUsBloc(),
      child: Scaffold(
        appBar: AppBar(title: Text(translation.contact_us)),
        body: BlocConsumer<ContactUsBloc, ContactUsState>(
          listener: (context, state) {
            if (state is ContactUsSuccess) {
              subjectController.clear();
              messageController.clear();

              final translation = AppLocalizations.of(context)!;

              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: Icon(
                        Icons.check_circle,
                        color: Theme.of(context).colorScheme.primary,
                        size: 48,
                      ),
                      // content: Text(state.message),
                      content: Text(translation.your_message_has_been_send),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
              );
            } else if (state is ContactUsError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            final isLoading = state is ContactUsLoading;

            return Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(
                    image: AssetImage('assets/images/milmujeres-logo.png'),
                    height: 80,
                  ),
                  const SizedBox(height: 10),
                  const Text("questions@milmujeres.org"),
                  const Text("(202) 808-3311"),
                  const SizedBox(height: 30),

                  if (!isAuthenticated)
                    _buildTextField(
                      label: translation.name,
                      controller: nameController,
                      errorText: nameError,
                    ),
                  if (!isAuthenticated)
                    _buildTextField(
                      label: translation.email,
                      controller: emailController,
                      errorText: emailError,
                    ),

                  _buildTextField(
                    label: translation.subject,
                    controller: subjectController,
                    errorText: subjectError,
                  ),
                  _buildTextField(
                    label: translation.message,
                    controller: messageController,
                    errorText: messageError,
                    maxLines: 5,
                    maxLength: 250,
                  ),
                  const SizedBox(height: 20),
                  isLoading
                      ? const CircularProgressIndicator()
                      : RoundedButtonLarge(
                        text: translation.send,
                        press: () => _validateAndSubmit(context),
                        icon: Icons.send,
                      ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
