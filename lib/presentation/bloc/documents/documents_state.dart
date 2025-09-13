part of 'documents_bloc.dart';

abstract class DocumentState {}

class DocumentInitial extends DocumentState {}

class DocumentLoading extends DocumentState {}

class DocumentsLoaded extends DocumentState {
  final List<Document> pending;
  final List<Document> checked;

  DocumentsLoaded({required this.pending, required this.checked});
}

class DocumentUploaded extends DocumentState {
  final String message;

  DocumentUploaded(this.message);
}

class DocumentError extends DocumentState {
  final String error;

  DocumentError(this.error);
}

class DocumentSigned extends DocumentState {
  final String message;

  DocumentSigned(this.message);
}

class TermsAndConditionsUploadLoaded extends DocumentState {
  final dynamic details;

  TermsAndConditionsUploadLoaded({required this.details});
}
