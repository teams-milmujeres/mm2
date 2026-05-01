import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'testimonials_event.dart';
part 'testimonials_state.dart';

class TestimonialsBloc extends Bloc<TestimonialsEvent, TestimonialsState> {
  TestimonialsBloc() : super(TestimonialsInitial()) {
    on<TestimonialsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
