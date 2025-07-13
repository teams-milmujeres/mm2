part of 'events_bloc.dart';

sealed class EventsEvent {}

class GetEvents extends EventsEvent {}

class FilterEventsByCity extends EventsEvent {
  final String city;
  FilterEventsByCity(this.city);
}

class FilterBlogsByCity extends EventsEvent {
  final String city;
  FilterBlogsByCity(this.city);
}
