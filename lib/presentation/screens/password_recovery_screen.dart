import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:milmujeres_app/presentation/bloc/password_recovery/password_recovery_bloc.dart';
import 'package:milmujeres_app/presentation/bloc/password_recovery/password_recovery_event.dart';
import 'package:milmujeres_app/presentation/bloc/password_recovery/password_recovery_state.dart';

class PasswordRecoveryScreen extends StatefulWidget {
  const PasswordRecoveryScreen({super.key});

  @override
  State<PasswordRecoveryScreen> createState() => _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen> {
  final _formKey = GlobalKey<FormState>();
  final account = TextEditingController();
  final code = TextEditingController();
  final password = TextEditingController();
  final confirmation = TextEditingController();

  AppLocalizations get t => AppLocalizations.of(context)!;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PasswordRecoveryBloc(),
      child: Scaffold(
        appBar: AppBar(title: Text(t.password_recovery)),
        body: BlocConsumer<PasswordRecoveryBloc, PasswordRecoveryState>(
          listener: (context, state) {
            if (state is RecoveryFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            final bloc = context.read<PasswordRecoveryBloc>();

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Form(
                  key: _formKey,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child:
                        state is RecoveryInitial
                            ? buildStep0(bloc)
                            : state is RecoveryStep1
                            ? buildStep1(bloc)
                            : state is RecoveryStep2
                            ? buildStep2(bloc)
                            : state is RecoverySuccess
                            ? buildStep3()
                            : state is RecoveryLoading
                            ? const CircularProgressIndicator()
                            : Text(t.error_try_again_later),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildStep0(PasswordRecoveryBloc bloc) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(t.write_username_email_or_recover_password),
      const SizedBox(height: 20),
      TextFormField(
        decoration: InputDecoration(
          labelText: t.username_email_phone,
          border: const OutlineInputBorder(),
        ),
        controller: account,
        validator: (v) => v == null || v.isEmpty ? t.is_required(t.user) : null,
      ),
      const SizedBox(height: 20),
      ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            bloc.add(SubmitUsername(account.text));
          }
        },
        child: Text(t.send),
      ),
    ],
  );

  Widget buildStep1(PasswordRecoveryBloc bloc) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(t.write_the_code_that_we_send_to_your_email),
      const SizedBox(height: 20),
      TextFormField(
        decoration: InputDecoration(
          labelText: t.code_example,
          border: const OutlineInputBorder(),
        ),
        controller: code,
        validator: (v) => v == null || v.isEmpty ? t.is_required(t.code) : null,
      ),
      const SizedBox(height: 20),
      ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            bloc.add(SubmitCode(code.text));
          }
        },
        child: Text(t.send),
      ),
    ],
  );

  Widget buildStep2(PasswordRecoveryBloc bloc) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(t.change_your_password),
      const SizedBox(height: 20),
      TextFormField(
        decoration: InputDecoration(
          labelText: t.new_password,
          border: const OutlineInputBorder(),
        ),
        controller: password,
        validator:
            (v) =>
                v == null || v.isEmpty ? t.is_required(t.new_password) : null,
      ),
      const SizedBox(height: 20),
      TextFormField(
        decoration: InputDecoration(
          labelText: t.password_confirmation,
          border: const OutlineInputBorder(),
        ),
        controller: confirmation,
        validator: (v) {
          if (v == null || v.isEmpty) {
            return t.is_required(t.password_confirmation);
          }
          if (v != password.text) return t.not_match(t.password_confirmation);
          return null;
        },
      ),
      const SizedBox(height: 20),
      ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            bloc.add(
              SubmitNewPassword(code.text, password.text, confirmation.text),
            );
          }
        },
        child: Text(t.save),
      ),
    ],
  );

  Widget buildStep3() => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(t.password_updated_successfully),
      const SizedBox(height: 20),
      ElevatedButton(
        onPressed: () => Navigator.of(context).pushNamed('login'),
        child: Text(t.login),
      ),
    ],
  );
}
