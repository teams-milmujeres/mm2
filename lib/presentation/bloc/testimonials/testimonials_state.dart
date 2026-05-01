part of 'testimonials_bloc.dart';

sealed class TestimonialsState extends Equatable {
  const TestimonialsState();
  
  @override
  List<Object> get props => [];
}

final class TestimonialsInitial extends TestimonialsState {}
