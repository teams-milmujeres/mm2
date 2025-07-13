part of 'events_bloc.dart';

sealed class EventsState {}

class EventsInitial extends EventsState {}

class EventsLoading extends EventsState {}

class EventsSuccess extends EventsState {
  final List<Event> events;
  final List<Event> blogs;
  final List<Event> importantEvents;
  final List<Event> importantBlogs;
  final List<Event> upcomingEvents;
  final List<Event> pastEvents;
  final List<String> citiesEvents;
  final List<String> citiesBlogs;

  EventsSuccess({
    required this.events,
    required this.blogs,
    required this.importantEvents,
    required this.importantBlogs,
    required this.upcomingEvents,
    required this.pastEvents,
    required this.citiesEvents,
    required this.citiesBlogs,
  });

  EventsSuccess copyWith({
    List<Event>? events,
    List<Event>? blogs,
    List<Event>? importantEvents,
    List<Event>? importantBlogs,
    List<Event>? upcomingEvents,
    List<Event>? pastEvents,
    List<String>? citiesEvents,
    List<String>? citiesBlogs,
  }) {
    return EventsSuccess(
      events: events ?? this.events,
      blogs: blogs ?? this.blogs,
      importantEvents: importantEvents ?? this.importantEvents,
      importantBlogs: importantBlogs ?? this.importantBlogs,
      upcomingEvents: upcomingEvents ?? this.upcomingEvents,
      pastEvents: pastEvents ?? this.pastEvents,
      citiesEvents: citiesEvents ?? this.citiesEvents,
      citiesBlogs: citiesBlogs ?? this.citiesBlogs,
    );
  }
}

class EventsError extends EventsState {
  final String errorMessage;
  EventsError({required this.errorMessage});
}
