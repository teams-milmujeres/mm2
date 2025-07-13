part of 'contact_us_bloc.dart';

sealed class ContactUsEvent {}

class SubmitContactUs extends ContactUsEvent {
  final ContactUs contact;
  SubmitContactUs(this.contact);
}
