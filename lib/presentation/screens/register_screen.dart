import 'package:flutter/material.dart';
// Bloc
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:milmujeres_app/presentation/bloc/register/register_bloc.dart';
// Localization
import 'package:milmujeres_app/l10n/app_localizations.dart';
// Entities
import 'package:milmujeres_app/domain/entities/user.dart';
// Other imports
import 'package:milmujeres_app/widgets/rounded_button_large.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final middleNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  void _validateAndSubmit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final user = User(
        id: 100,
        firstName: firstNameController.text.trim(),
        middleName: middleNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        userName: userNameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
      );

      final locale = Localizations.localeOf(context).languageCode;

      context.read<RegisterBloc>().add(SubmitRegisterEvent(user, locale));
    }
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?) validator,
    bool obscureText = false,
    int maxLines = 1,
    int? maxLength,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: obscureText,
        maxLines: maxLines,
        maxLength: maxLength,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final translation = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => RegisterBloc(),
      child: Scaffold(
        appBar: AppBar(title: Text(translation.register)),
        body: BlocConsumer<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
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
            }
            if (state is RegisterError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            final isLoading = state is RegisterLoading;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Image(
                      image: AssetImage('assets/images/milmujeres-logo.png'),
                      height: 100,
                    ),
                    const SizedBox(height: 25),
                    Text(
                      translation.contact_to_request,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 25),
                    _buildTextField(
                      label: translation.first_name,
                      controller: firstNameController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return translation.is_required(translation.name);
                        }

                        if (value.length < 2) {
                          return translation.fewest_characters(translation.two);
                        }
                        return null;
                      },
                    ),
                    _buildTextField(
                      label: translation.middle_name,
                      controller: middleNameController,
                      validator: (value) => null,
                    ),
                    _buildTextField(
                      label: translation.last_name,
                      controller: lastNameController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return translation.is_required(translation.last_name);
                        }
                        if (value.length < 2) {
                          return translation.fewest_characters(translation.two);
                        }
                        return null;
                      },
                    ),
                    _buildTextField(
                      label: translation.email,
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return translation.is_required(translation.email);
                        }
                        if (value.length < 5) {
                          return translation.fewest_characters(
                            translation.five,
                          );
                        }
                        if (!RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                        ).hasMatch(value)) {
                          return translation.enter_valid(translation.email);
                        }
                        return null;
                      },
                    ),
                    _buildTextField(
                      label: translation.phone,
                      controller: phoneController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return translation.is_required(translation.phone);
                        }
                        return null;
                      },
                    ),
                    _buildTextField(
                      label: translation.username,
                      controller: userNameController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return translation.is_required(translation.username);
                        }
                        if (value.length < 3) {
                          return translation.fewest_characters(
                            translation.username,
                          );
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : RoundedButtonLarge(
                          text: translation.send,
                          press: () => _validateAndSubmit(context),
                          icon: Icons.send,
                        ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
