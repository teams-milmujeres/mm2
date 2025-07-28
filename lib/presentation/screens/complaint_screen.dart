import 'package:flutter/material.dart';
// Bloc
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:milmujeres_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:milmujeres_app/presentation/bloc/complaints/complaints_bloc.dart';
// Entities
import 'package:milmujeres_app/domain/entities/complaint.dart';
// Localization
import 'package:milmujeres_app/l10n/app_localizations.dart';
// Other imports
import 'package:milmujeres_app/widgets/rounded_button_large.dart';

class ComplaintsScreen extends StatefulWidget {
  const ComplaintsScreen({super.key});

  @override
  State<ComplaintsScreen> createState() => _ComplaintsScreenState();
}

class _ComplaintsScreenState extends State<ComplaintsScreen> {
  final subjectController = TextEditingController();
  final messageController = TextEditingController();

  String? subjectError;
  String? messageError;
  String? userName;
  String? userEmail;
  int? userId;

  @override
  void initState() {
    super.initState();

    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      userName = "${authState.user.firstName} ${authState.user.lastName}";
      userEmail = authState.user.email;
      userId = authState.user.id;
    }
  }

  @override
  void dispose() {
    subjectController.dispose();
    messageController.dispose();
    super.dispose();
  }

  void _validateAndSubmit(BuildContext context) {
    final translation = AppLocalizations.of(context)!;

    setState(() {
      subjectError = null;
      messageError = null;

      if (subjectController.text.trim().isEmpty) {
        subjectError = translation.is_required(translation.subject);
      }

      if (messageController.text.trim().isEmpty) {
        messageError = translation.is_required(translation.message);
      } else if (messageController.text.length < 5) {
        messageError = translation.fewest_characters('5');
      }

      if (subjectError == null && messageError == null) {
        // Obtener el estado actual de AuthBloc
        final authState = context.read<AuthBloc>().state;

        // Extraer el userId si está autenticado
        final int userId =
            (authState is AuthAuthenticated) ? authState.user.id : 100;

        final complaint = Complaint(
          subject: subjectController.text,
          message: messageController.text,
          userId: userId,
        );

        if (authState is AuthAuthenticated) {
          final token = authState.token;
          context.read<ComplaintsBloc>().add(SubmitComplaint(complaint, token));
        }
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
      create: (_) => ComplaintsBloc(),
      child: Scaffold(
        appBar: AppBar(title: Text(translation.complaints)),
        body: BlocConsumer<ComplaintsBloc, ComplaintsState>(
          listener: (context, state) {
            if (state is ComplaintsSucess) {
              subjectController.clear();
              messageController.clear();

              showDialog(
                context: context,
                builder:
                    (_) => AlertDialog(
                      title: Icon(
                        Icons.check_circle,
                        color: Theme.of(context).colorScheme.primary,
                        size: 48,
                      ),
                      content: Text(state.message),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
              );
            } else if (state is ComplaintsError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            final isLoading = state is ComplaintsLoading;

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
                  if (userEmail != null) Text(userEmail!),
                  const Text("(202) 808-3311"),
                  const SizedBox(height: 30),

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
