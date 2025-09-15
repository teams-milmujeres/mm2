part of 'rating_bloc.dart';

sealed class RatingEvent {}

class GetRatingEvent extends RatingEvent {
  final int clientId;

  GetRatingEvent({required this.clientId});
}

class SendRatingEvent extends RatingEvent {
  final int clientId;
  final int rating;
  final String comment;

  SendRatingEvent({
    required this.clientId,
    required this.rating,
    required this.comment,
  });
}
