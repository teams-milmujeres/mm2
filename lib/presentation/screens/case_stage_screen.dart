import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:milmujeres_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:milmujeres_app/presentation/bloc/case_stage/case_stage_bloc.dart';

class CaseStageScreen extends StatelessWidget {
  const CaseStageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final translation = AppLocalizations.of(context)!;
    final locale = translation.localeName;

    final authState = context.watch<AuthBloc>().state;

    // Validar que el usuario esté autenticado
    if (authState is! AuthAuthenticated) {
      return Scaffold(
        appBar: AppBar(title: Text(translation.caases_stage)),
        body: Center(child: Text(translation.no_elements)),
      );
    }

    final String clientId = authState.user.id.toString();

    return Scaffold(
      appBar: AppBar(title: Text(translation.caases_stage)),
      body: BlocProvider(
        create: (context) => CaseStageBloc()..add(GetCaseStageEvent(clientId)),
        child: BlocBuilder<CaseStageBloc, CaseStageState>(
          builder: (context, state) {
            if (state is CaseStageLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CaseStageError) {
              return Center(child: Text(state.message));
            }

            if (state is CaseStageSuccess) {
              final data = state.stages;

              if (data.isEmpty) {
                return Center(
                  child: Text(translation.your_case_is_in_evaluation),
                );
              }

              return Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 800),
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  width: double.maxFinite,
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final item = data[index];
                      return Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _cryptoNameSymbol(item, locale, context),
                              const SizedBox(height: 10),
                              Text(
                                item['note'] != null && item['note'].isNotEmpty
                                    ? '${translation.status}: ${item['stage_type'][locale == 'es' ? 'name_es' : 'name_en']} / ${item['note']}'
                                    : '${translation.status}: ${item['stage_type'][locale == 'es' ? 'name_es' : 'name_en']}',
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Divider(
                                color: Theme.of(context).colorScheme.primary,
                                thickness: 1,
                              ),
                              const SizedBox(height: 10),
                              ...List<Widget>.from(
                                item['applications'].map<Widget>((application) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${translation.application}: ${application['application']['application_type']['abbrev']}',
                                              style: const TextStyle(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              DateFormat('MM/dd/yyyy').format(
                                                DateTime.parse(
                                                  application['date'],
                                                ),
                                              ),
                                              style: const TextStyle(
                                                color: Colors.black87,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          application['note'] != null &&
                                                  application['note'].isNotEmpty
                                              ? '${translation.status}: ${application['stage_type'][locale == 'es' ? 'name_es' : 'name_en']} / ${application['note']}'
                                              : '${translation.status}: ${application['stage_type'][locale == 'es' ? 'name_es' : 'name_en']}',
                                          style: const TextStyle(
                                            color: Colors.black87,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
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

            return const SizedBox.shrink(); // Estado inicial vacío
          },
        ),
      ),
    );
  }

  Widget _cryptoNameSymbol(
    Map<String, dynamic> item,
    String locale,
    BuildContext context,
  ) {
    final caase = item['caase'];
    final caaseType =
        caase != null && caase['caase_type'] != null
            ? caase['caase_type'][locale == 'es' ? 'name_es' : 'name_en'] ?? ''
            : 'Unknown';

    final date =
        item['date'] != null
            ? DateTime.tryParse(item['date'].toString()) ?? DateTime.now()
            : DateTime.now();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          caaseType,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Text(
              DateFormat('MM/dd/yyyy').format(date),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
