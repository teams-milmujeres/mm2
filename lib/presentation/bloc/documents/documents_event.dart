part of 'documents_bloc.dart';

abstract class DocumentEvent {}

class GetDocumentsEvent extends DocumentEvent {
  final String clientId;

  GetDocumentsEvent({required this.clientId});
}

class UploadDocumentEvent extends DocumentEvent {
  final int documentRequestId;
  final Uint8List fileBytes;
  final String clientId;

  UploadDocumentEvent({
    required this.documentRequestId,
    required this.fileBytes,
    required this.clientId,
  });
}

class PickFileEvent extends DocumentEvent {
  final int documentRequestId;
  final String clientId;

  PickFileEvent({required this.documentRequestId, required this.clientId});
}
