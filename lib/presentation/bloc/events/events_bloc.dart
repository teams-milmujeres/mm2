import 'package:bloc/bloc.dart';
import 'package:mm/data/data.dart';
import 'package:mm/domain/entities/event.dart';

part 'events_event.dart';
part 'events_state.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  late List<Event> _allEvents;
  late List<Event> _allBlogs;

  EventsBloc() : super(EventsInitial()) {
    on<GetEvents>(_onEventsFetchEvent);
    on<FilterEventsByCity>(_onFilterEventsByCity);
    on<FilterBlogsByCity>(_onFilterBlogsByCity);
  }

  Future<void> _onEventsFetchEvent(
    GetEvents event,
    Emitter<EventsState> emit,
  ) async {
    emit(EventsLoading());
    try {
      final client = DioClient();
      final response = await client.dio.get('/get_blogs');
      final List data = response.data;

      final now = DateTime.now();
      final events =
          data
              .map((e) => Event.fromJson(e))
              .where((e) => e.isEvent && !e.important)
              .toList();

      final blogs =
          data
              .map((e) => Event.fromJson(e))
              .where((e) => !e.isEvent && !e.important)
              .toList();

      final importantEvents =
          data
              .map((e) => Event.fromJson(e))
              .where((e) => e.important && e.isEvent)
              .toList();

      final importantBlogs =
          data
              .map((e) => Event.fromJson(e))
              .where((e) => e.important && !e.isEvent)
              .toList();

      final upcomingEvents =
          events
              .where((e) => e.eventDate != null && e.eventDate!.isAfter(now))
              .toList();

      final pastEvents =
          events
              .where((e) => e.eventDate != null && e.eventDate!.isBefore(now))
              .toList();

      final citiesEvents = [
        'Todas',
        ...{...events.map((e) => e.city)},
      ];
      final citiesBlogs = [
        'Todas',
        ...{...blogs.map((e) => e.city)},
      ];

      _allEvents = events;
      _allBlogs = blogs;

      emit(
        EventsSuccess(
          events: events,
          blogs: blogs,
          importantEvents: importantEvents,
          importantBlogs: importantBlogs,
          upcomingEvents: upcomingEvents,
          pastEvents: pastEvents,
          citiesEvents: citiesEvents,
          citiesBlogs: citiesBlogs,
        ),
      );
    } catch (e) {
      emit(EventsError(errorMessage: e.toString()));
    }
  }

  void _onFilterEventsByCity(
    FilterEventsByCity event,
    Emitter<EventsState> emit,
  ) {
    final current = state;
    if (current is EventsSuccess) {
      final filtered =
          event.city == 'Todas'
              ? _allEvents
              : _allEvents.where((e) => e.city == event.city).toList();
      emit(current.copyWith(events: filtered));
    }
  }

  void _onFilterBlogsByCity(
    FilterBlogsByCity event,
    Emitter<EventsState> emit,
  ) {
    final current = state;
    if (current is EventsSuccess) {
      final filtered =
          event.city == 'Todas'
              ? _allBlogs
              : _allBlogs.where((e) => e.city == event.city).toList();
      emit(current.copyWith(blogs: filtered));
    }
  }
}
