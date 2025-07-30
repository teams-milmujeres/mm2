import 'package:flutter/material.dart';
// Bloc
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:milmujeres_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:milmujeres_app/presentation/bloc/case_stage/case_stage_bloc.dart';
// Localization
import 'package:milmujeres_app/l10n/app_localizations.dart';
// Other imports
import 'package:intl/intl.dart';

class CaseStageScreen extends StatelessWidget {
  const CaseStageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final translation = AppLocalizations.of(context)!;
    final authState = context.watch<AuthBloc>().state;

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
              final translation = AppLocalizations.of(context)!;

              if (data.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 50,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          translation.your_case_is_in_evaluation,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 800),
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  width: double.maxFinite,
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder:
                        (context, index) =>
                            CaseStageItemCard(item: data[index]),
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class CaseStageItemCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const CaseStageItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final translation = AppLocalizations.of(context)!;
    final locale = translation.localeName;

    return Card(
      elevation: 2,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        title: _cryptoNameSymbol(item, locale, context),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: RichText(
            text:
                item['note'] != null && item['note'].isNotEmpty
                    ? buildStyledText(
                      translation.status,
                      '${item['stage_type'][locale == 'es' ? 'name_es' : 'name_en']} / ${item['note']}',
                      context,
                    )
                    : buildStyledText(
                      translation.status,
                      item['stage_type'][locale == 'es'
                          ? 'name_es'
                          : 'name_en'],
                      context,
                    ),
          ),
        ),
        childrenPadding: const EdgeInsets.all(15.0),
        children: [
          const SizedBox(height: 10),
          ...List<Widget>.from(
            item['applications'].map<Widget>(
              (app) => ApplicationItem(application: app),
            ),
          ),
        ],
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
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Text(
              DateFormat('MM/dd/yyyy').format(date),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }

  TextSpan buildStyledText(String label, String value, BuildContext context) {
    return TextSpan(
      children: [
        TextSpan(
          text: '$label: ',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        TextSpan(
          text: value,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.black87),
        ),
      ],
    );
  }
}

class ApplicationItem extends StatelessWidget {
  final Map<String, dynamic> application;

  const ApplicationItem({super.key, required this.application});

  @override
  Widget build(BuildContext context) {
    final translation = AppLocalizations.of(context)!;
    final locale = translation.localeName;

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      '${translation.application}: ',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        application['application']['application_type']['abbrev'],
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                DateFormat(
                  'MM/dd/yyyy',
                ).format(DateTime.parse(application['date'])),
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.black87),
              ),
            ],
          ),
          const SizedBox(height: 5),
          RichText(
            text:
                application['note'] != null && application['note'].isNotEmpty
                    ? buildStyledText(
                      translation.status,
                      '${application['stage_type'][locale == 'es' ? 'name_es' : 'name_en']} / ${application['note']}',
                      context,
                    )
                    : buildStyledText(
                      translation.status,
                      application['stage_type'][locale == 'es'
                          ? 'name_es'
                          : 'name_en'],
                      context,
                    ),
          ),
        ],
      ),
    );
  }

  TextSpan buildStyledText(String label, String value, BuildContext context) {
    return TextSpan(
      children: [
        TextSpan(
          text: '$label: ',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        TextSpan(
          text: value,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.black87),
        ),
      ],
    );
  }
}
