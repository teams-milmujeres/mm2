import 'dart:convert';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mm/data/data.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mm/domain/entities/document.dart';
import 'package:mm/domain/entities/terms_upload.dart';

part 'documents_event.dart';
part 'documents_state.dart';

class DocumentBloc extends Bloc<DocumentEvent, DocumentState> {
  final FlutterSecureStorage _secureStorage;

  DocumentBloc({FlutterSecureStorage? secureStorage})
    : _secureStorage = secureStorage ?? const FlutterSecureStorage(),
      super(DocumentInitial()) {
    on<GetDocumentsEvent>(_onLoadDocuments);
    on<UploadDocumentEvent>(_onUploadDocument);
    on<PickFileEvent>(_onPickFile);
    on<GetTermsAndConditionsUploadEvent>(_getTermsAndConditionsUpload);
    on<SigningTermsAndConditionsEvent>(_signingTermsandConditions);
  }

  Future<void> _onLoadDocuments(
    GetDocumentsEvent event,
    Emitter<DocumentState> emit,
  ) async {
    emit(DocumentLoading());

    try {
      final token = await _secureStorage.read(key: 'token');
      if (token == null) throw Exception('Token no encontrado');

      final client = DioClient();
      final response = await client.dio.get(
        '/documents_request',
        queryParameters: {'client_id': event.clientId},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final pending = List<Document>.from(
          response.data['pending'].map((doc) => Document.fromJson(doc)),
        );
        final checked = List<Document>.from(
          response.data['checked'].map((doc) => Document.fromJson(doc)),
        );

        emit(DocumentsLoaded(pending: pending, checked: checked));
      } else {
        emit(DocumentError('Error al obtener documentos'));
      }
    } catch (e) {
      emit(DocumentError(e.toString()));
    }
  }

  Future<void> _onUploadDocument(
    UploadDocumentEvent event,
    Emitter<DocumentState> emit,
  ) async {
    emit(DocumentLoading());

    try {
      final token = await _secureStorage.read(key: 'token');
      if (token == null) throw Exception('Token no encontrado');

      final base64File = base64Encode(event.fileBytes);
      final client = DioClient();

      final response = await client.dio.post(
        '/upload_file',
        data: {
          'file': base64File,
          'document_request_id': event.documentRequestId,
          'base64': true,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      emit(DocumentUploaded(response.data['message']));

      // ¡Recargar lista!
      add(GetDocumentsEvent(clientId: event.clientId));
    } catch (e) {
      emit(DocumentError(e.toString()));
    }
  }

  Future<void> _getTermsAndConditionsUpload(
    GetTermsAndConditionsUploadEvent event,
    Emitter<DocumentState> emit,
  ) async {
    emit(DocumentLoading());

    try {
      final token = await _secureStorage.read(key: 'token');
      if (token == null) {
        emit(DocumentError('Token no encontrado'));
        return;
      }

      final client = DioClient();

      final response = await client.dio.get(
        '/get-terms-and-conditions-upload',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final terms = TermsAndConditionsUpload.fromJson(response.data);
        emit(TermsAndConditionsUploadLoaded(details: terms));
      } else {
        emit(DocumentError('Respuesta inválida del servidor'));
      }
    } on DioException catch (e) {
      emit(
        DocumentError(
          'Error de red: ${e.message ?? 'No se pudo conectar al servidor'}',
        ),
      );
    } catch (e) {
      emit(DocumentError('Error inesperado: $e'));
    }
  }

  Future<void> _signingTermsandConditions(
    SigningTermsAndConditionsEvent event,
    Emitter<DocumentState> emit,
  ) async {
    emit(DocumentLoading());

    try {
      final token = await _secureStorage.read(key: 'token');
      if (token == null) throw Exception('Token no encontrado');

      final client = DioClient();

      final response = await client.dio.post(
        '/sign_upload_documents',
        data: {
          'signature_upload_documents': event.signing,
          'client_id': event.clientId,
          'version': event.version,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      emit(DocumentSigned(response.data['msg']));

      add(GetDocumentsEvent(clientId: event.clientId));
    } catch (e) {
      emit(DocumentError(e.toString()));
    }
  }

  Future<void> _onPickFile(
    PickFileEvent event,
    Emitter<DocumentState> emit,
  ) async {
    final result = await FilePicker.platform.pickFiles(withData: true);
    if (result != null) {
      final fileBytes = result.files.first.bytes!;
      add(
        UploadDocumentEvent(
          documentRequestId: event.documentRequestId,
          fileBytes: fileBytes,
          clientId: event.clientId,
        ),
      );
    }
  }
}
