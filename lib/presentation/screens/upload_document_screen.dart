import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:milmujeres_app/domain/entities/document.dart';
import 'package:milmujeres_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:milmujeres_app/presentation/bloc/documents/documents_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UploadDocumentScreen extends StatelessWidget {
  const UploadDocumentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context)!;
    final authState = context.watch<AuthBloc>().state;

    return BlocProvider(
      create:
          (_) =>
              DocumentBloc()..add(
                GetDocumentsEvent(
                  clientId: (authState as AuthAuthenticated).user.id.toString(),
                ),
              ),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(translate.document_request),
            bottom: TabBar(
              tabs: [
                Tab(text: translate.pending),
                Tab(text: translate.confirmed),
              ],
            ),
          ),
          body: BlocListener<DocumentBloc, DocumentState>(
            listener: (context, state) {
              if (state is DocumentUploaded) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              } else if (state is DocumentError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${state.error}')),
                );
              }
            },
            child: BlocBuilder<DocumentBloc, DocumentState>(
              builder: (context, state) {
                if (state is DocumentLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is DocumentsLoaded) {
                  return Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 1024),
                      child: TabBarView(
                        children: [
                          _buildPendingList(state.pending, translate, context),
                          _buildConfirmedList(state.checked, translate),
                        ],
                      ),
                    ),
                  );
                }

                return Center(child: Text(translate.is_empty));
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPendingList(
    List<Document> pendingDocs,
    AppLocalizations t,
    BuildContext context,
  ) {
    if (pendingDocs.isEmpty) return Center(child: Text(t.is_empty));

    return ListView.separated(
      itemCount: pendingDocs.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final doc = pendingDocs[index];
        final formattedDate =
            '${doc.createdAt.month}/${doc.createdAt.day}/${doc.createdAt.year}';

        final lastHistory =
            doc.histories.isNotEmpty ? doc.histories.last : null;
        final lastState = lastHistory?.state ?? '';
        final lastStateNote = lastHistory?.stateNote ?? '';

        return ListTile(
          contentPadding: const EdgeInsets.all(15),
          leading: const FaIcon(FontAwesomeIcons.upload, size: 30),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${t.document_type}: ${doc.documentType.nameEn}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 5),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: Text(t.instructions),
                        content: SingleChildScrollView(child: Text(doc.note)),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(t.close),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(
                  Icons.info_outline,
                  size: 16,
                  color: Colors.white,
                ),
                label: Text(
                  t.view_instructions,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                formattedDate,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Text('${t.last_state}: ${_translatedState(lastState, t)}'),
              if (lastStateNote.isNotEmpty)
                Text(
                  '${t.note}: $lastStateNote',
                  style: TextStyle(
                    fontSize: 14,
                    color: lastState == 'rejected' ? Colors.red : Colors.black,
                  ),
                ),
              if (!doc.uploaded)
                const Text(
                  'Max upload size 2MB',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
            ],
          ),
          trailing:
              !doc.uploaded
                  ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    onPressed: () {
                      final authState = context.read<AuthBloc>().state;

                      if (authState is! AuthAuthenticated) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(t.no_elements)));
                        return;
                      }

                      final clientId = (authState).user.id.toString();

                      context.read<DocumentBloc>().add(
                        PickFileEvent(
                          documentRequestId: doc.id,
                          clientId: clientId,
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        const FaIcon(FontAwesomeIcons.upload),
                        Text(t.upload, style: const TextStyle(fontSize: 11)),
                      ],
                    ),
                  )
                  : null,
        );
      },
    );
  }

  Widget _buildConfirmedList(List<Document> confirmedDocs, AppLocalizations t) {
    if (confirmedDocs.isEmpty) return Center(child: Text(t.is_empty));

    return ListView.separated(
      itemCount: confirmedDocs.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final doc = confirmedDocs[index];
        return ListTile(
          leading: FaIcon(
            doc.checked
                ? FontAwesomeIcons.circleCheck
                : FontAwesomeIcons.upload,
            size: 30,
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${t.document_type}: ${doc.documentType.nameEn}'),
              if (doc.googleDriveUrl != null)
                Text(doc.googleDriveUrl!, style: const TextStyle(fontSize: 12)),
            ],
          ),
          onTap: () => debugPrint('Tapped confirmed doc ${doc.id}'),
        );
      },
    );
  }

  String _translatedState(String state, AppLocalizations loc) {
    switch (state) {
      case 'pending':
        return loc.state_pending;
      case 'reviewed':
        return loc.state_reviewed;
      case 'accepted':
        return loc.state_accepted;
      case 'rejected':
        return loc.state_rejected;
      case 'moved_to_drive':
        return loc.state_moved_to_drive;
      case 'deleted':
        return loc.state_deleted;
      default:
        return 'Desconocido';
    }
  }
}
