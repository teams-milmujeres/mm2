part of 'rating_bloc.dart';

sealed class RatingState {}

final class RatingInitial extends RatingState {}

final class RatingLoading extends RatingState {}

class RatingSuccess extends RatingState {
  final Rating rating;

  RatingSuccess(this.rating);
}

final class RatingSend extends RatingState {
  final String message;
  RatingSend(this.message);
}

final class RatingError extends RatingState {
  final String message;
  RatingError(this.message);
}
