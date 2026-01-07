import 'package:flutter/material.dart';
// Bloc
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm/domain/entities/terms_upload.dart';
import 'package:mm/presentation/bloc/auth/auth_bloc.dart';
import 'package:mm/presentation/bloc/documents/documents_bloc.dart';
// Localization
import 'package:mm/l10n/app_localizations.dart';
// Entities
import 'package:mm/domain/entities/document.dart';
// Other imports
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UploadDocumentScreen extends StatefulWidget {
  const UploadDocumentScreen({super.key});

  @override
  State<UploadDocumentScreen> createState() => _UploadDocumentScreenState();
}

class _UploadDocumentScreenState extends State<UploadDocumentScreen> {
  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) {
        final bloc = DocumentBloc();
        // Dispara el evento de términos y condiciones
        bloc.add(GetTermsAndConditionsUploadEvent());
        // El evento para obtener los documentos se dispara después de aceptar los términos
        return bloc;
      },
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
                  SnackBar(content: Text(translate.error_message)),
                );
              } else if (state is TermsAndConditionsUploadLoaded) {
                final authState = context.read<AuthBloc>().state;
                final userVersion =
                    (authState as AuthAuthenticated)
                        .user
                        .signatureUploadDocumentsVersion;

                if (userVersion == null ||
                    state.details.version > userVersion) {
                  _showSignatureModal(
                    context,
                    state.details.version.toDouble(),
                    state.details,
                  );
                } else {
                  // Si ya ha firmado, obtener los documentos
                  context.read<DocumentBloc>().add(
                    GetDocumentsEvent(clientId: authState.user.id.toString()),
                  );
                }
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

                return Center(child: Text(translate.no_elements));
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
    if (pendingDocs.isEmpty) return Center(child: Text(t.no_elements));

    return ListView.separated(
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemCount: pendingDocs.length,
      itemBuilder: (context, index) {
        final doc = pendingDocs[index];
        return _PendingDocumentCard(document: doc, t: t);
      },
    );
  }
}

class _PendingDocumentCard extends StatelessWidget {
  final Document document;
  final AppLocalizations t;

  const _PendingDocumentCard({required this.document, required this.t});

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        '${document.createdAt.month}/${document.createdAt.day}/${document.createdAt.year}';
    final lastHistory =
        document.histories.isNotEmpty ? document.histories.last : null;
    final lastState = lastHistory?.state ?? '';
    final lastStateNote = lastHistory?.stateNote ?? '';
    final isRejected = lastState == 'rejected';
    final locale = Localizations.localeOf(context).languageCode;
    final documentName =
        locale == 'es'
            ? document.documentType.nameEs
            : document.documentType.nameEn;
    final documentNote = locale == 'es' ? document.noteES : document.noteEN;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          decoration: BoxDecoration(
            // color: isRejected ? Colors.red.shade50 : Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                leading: const FaIcon(FontAwesomeIcons.upload, size: 24),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${t.document_type}: ',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: documentName),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),

                    _rowText('${t.created_at}: ', formattedDate, Colors.grey),
                    if (!document.uploaded)
                      _rowText(
                        '${t.last_state}: ',
                        _translatedState(lastState, t),
                        isRejected ? Colors.red : Colors.black87,
                      ),
                    if (lastStateNote.isNotEmpty && !document.uploaded)
                      _rowText(
                        '${t.note}: ',
                        lastStateNote,
                        isRejected ? Colors.red : Colors.black87,
                      ),
                  ],
                ),
                trailing:
                    document.uploaded
                        ? Icon(
                          Icons.hourglass_top,
                          color: Theme.of(context).colorScheme.primary,
                          size: 30,
                        )
                        : ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(90, 36),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            elevation: 1,
                          ),
                          onPressed: () {
                            final authState = context.read<AuthBloc>().state;
                            if (authState is! AuthAuthenticated) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(t.no_elements)),
                              );
                              return;
                            }
                            final clientId = authState.user.id.toString();
                            context.read<DocumentBloc>().add(
                              PickFileEvent(
                                documentRequestId: document.id,
                                clientId: clientId,
                              ),
                            );
                          },
                          icon: const FaIcon(FontAwesomeIcons.upload, size: 16),
                          label: Text(
                            t.upload,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        minimumSize: const Size(0, 32),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder:
                              (_) => AlertDialog(
                                title: Text(t.instructions),
                                content: SingleChildScrollView(
                                  child: Text(documentNote),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(t.close),
                                  ),
                                ],
                              ),
                        );
                      },
                      icon: const Icon(Icons.info_outline, size: 18),
                      label: Text(
                        t.view_instructions,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildConfirmedList(List<Document> confirmedDocs, AppLocalizations t) {
  if (confirmedDocs.isEmpty) return Center(child: Text(t.no_elements));

  return ListView.separated(
    itemCount: confirmedDocs.length,
    separatorBuilder: (_, __) => const SizedBox(height: 8),
    itemBuilder: (context, index) {
      final doc = confirmedDocs[index];
      final locale = Localizations.localeOf(context).languageCode;
      final documentName =
          locale == 'es' ? doc.documentType.nameEs : doc.documentType.nameEn;
      final formattedDate =
          '${doc.createdAt.month}/${doc.createdAt.day}/${doc.createdAt.year}';
      final lastHistory = doc.histories.isNotEmpty ? doc.histories.last : null;
      final lastState = lastHistory?.state ?? '';
      final lastStateNote = lastHistory?.stateNote ?? '';
      final isMovedToDrive = lastState == 'moved_to_drive';

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ExpansionTile(
            leading: FaIcon(
              FontAwesomeIcons.circleCheck,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '${t.document_type}: ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: documentName),
                ],
              ),
            ),
            childrenPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            expandedAlignment: Alignment.topLeft,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _rowText('${t.created_at}: ', formattedDate),
                  _rowText('${t.last_state}: ', _translatedState(lastState, t)),
                  if (lastStateNote.isNotEmpty && !isMovedToDrive)
                    _rowText('${t.note}: ', lastStateNote),
                  SizedBox(height: 8),
                ],
              ),
            ],
          ),
        ),
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
      return loc.saved;
    case 'deleted':
      return loc.state_deleted;
    default:
      return 'Desconocido';
  }
}

Widget _rowText(
  String title,
  String value, [
  Color? color,
  double fontSize = 14,
]) => Row(
  children: [
    Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: color ?? Colors.black87,
        fontSize: fontSize,
      ),
    ),
    Text(
      value,
      style: TextStyle(color: color ?? Colors.black87, fontSize: fontSize),
    ),
  ],
);

// Modal para firmar términos y condiciones
void _showSignatureModal(
  BuildContext context,
  double version,
  TermsAndConditionsUpload details,
) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return BlocProvider.value(
        value: BlocProvider.of<DocumentBloc>(context),
        child: SignatureModal(version: version, details: details),
      );
    },
  );
}

class SignatureModal extends StatefulWidget {
  const SignatureModal({
    super.key,
    required this.details,
    required this.version,
  });

  final double version;
  final TermsAndConditionsUpload details;

  @override
  State<SignatureModal> createState() => _SignatureModalState();
}

class _SignatureModalState extends State<SignatureModal> {
  final ScrollController _scrollController = ScrollController();
  bool _hasScrolledToEnd = false;
  bool _isExpanded = false;

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      if (!_hasScrolledToEnd) {
        setState(() {
          _hasScrolledToEnd = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final translation = AppLocalizations.of(context)!;

    final fullText =
        locale == 'es' ? widget.details.termsEs : widget.details.termsEn;

    final summary =
        locale == 'es' ? widget.details.summaryEs : widget.details.summaryEn;

    return AlertDialog(
      title: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 4,
        children: [
          Text(translation.terms_and_conditions),
          if (widget.details.publishedAt != null)
            Text(
              ' - ${_formatDate(widget.details.publishedAt!)}',
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!_isExpanded) ...[
              Text(summary),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _isExpanded = true;
                    });
                  },
                  icon: const Icon(Icons.menu_book_outlined),
                  label: Text(translation.read_full),
                ),
              ),
            ],
            if (_isExpanded)
              Flexible(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: Scrollbar(
                    thumbVisibility: true,
                    controller: _scrollController,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Text(fullText),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          child: Text(translation.close),
        ),
        BlocConsumer<DocumentBloc, DocumentState>(
          listener: (context, state) {
            if (state is DocumentSigned) {
              final authState = context.read<AuthBloc>().state;
              if (authState is AuthAuthenticated) {
                context.read<DocumentBloc>().add(
                  GetDocumentsEvent(clientId: authState.user.id.toString()),
                );
              }
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(translation.signature_success)),
              );
            } else if (state is DocumentError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(translation.error_message)),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is DocumentLoading;
            final authState = context.read<AuthBloc>().state;
            final canAccept = _isExpanded && _hasScrolledToEnd;

            return TextButton(
              onPressed:
                  isLoading || !canAccept
                      ? null
                      : () {
                        context.read<DocumentBloc>().add(
                          SigningTermsAndConditionsEvent(
                            signing: true,
                            clientId:
                                (authState as AuthAuthenticated).user.id
                                    .toString(),
                            version: widget.version,
                          ),
                        );
                        context.read<AuthBloc>().add(CheckToken());
                      },
              child:
                  isLoading
                      ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : Text(translation.accept_terms_and_conditions),
            );
          },
        ),
      ],
    );
  }
}
