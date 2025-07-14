part of 'contact_us_bloc.dart';

sealed class ContactUsEvent {}

class SubmitContactUsEvent extends ContactUsEvent {
  final ContactUs contact;
  SubmitContactUsEvent(this.contact);
}
