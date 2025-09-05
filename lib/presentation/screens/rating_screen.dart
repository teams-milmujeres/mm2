import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// Localizations
import 'package:milmujeres_app/l10n/app_localizations.dart';
import 'package:milmujeres_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:milmujeres_app/presentation/bloc/rating/rating_bloc.dart';
import 'package:milmujeres_app/widgets/widgets.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  int _selectedRating = 0;
  final TextEditingController _commentController = TextEditingController();
  bool _readOnly = false;
  bool _isInitialized = false;

  void _onStarTapped(int value) {
    if (_readOnly) return;
    setState(() {
      _selectedRating = value;
    });
  }

  Color _getColorByRating(int rating) {
    if (rating <= 2) return Colors.red;
    if (rating == 3) return Colors.orange;
    return Colors.green;
  }

  String _getEmojiByRating(int rating) {
    if (rating <= 2) return 'assets/images/rating/emoji-sad.png';
    if (rating == 3) return 'assets/images/rating/emoji-like.png';
    return 'assets/images/rating/emoji-love.png';
  }

  @override
  Widget build(BuildContext context) {
    final translation = AppLocalizations.of(context)!;
    final authState = context.watch<AuthBloc>().state;

    return BlocProvider(
      create:
          (context) =>
              RatingBloc()..add(
                GetRatingEvent(
                  clientId: (authState as AuthAuthenticated).user.id,
                ),
              ),
      child: BlocConsumer<RatingBloc, RatingState>(
        listener: (context, state) {
          if (state is RatingSend) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is RatingError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: ${state.message}')));
          }
        },
        builder: (context, state) {
          if (state is RatingLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is RatingSuccess) {
            final rating = state.rating;

            // Solo actualizamos los valores si no se ha inicializado o si el modo lectura ha cambiado
            if (!_isInitialized || rating.isRating) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _selectedRating = rating.rating;
                  _commentController.text = rating.comment;
                  _readOnly = rating.isRating;
                  _isInitialized = true;
                });
              });
            }
          }

          if (_readOnly) {
            final Color ratingColor = _getColorByRating(_selectedRating);

            // Scaffold para el modo lectura
            return Scaffold(
              backgroundColor: ratingColor,
              appBar: AppBar(
                title: Text(translation.rating),
                backgroundColor: ratingColor,
                foregroundColor: Colors.white,
              ),
              body: SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          translation.has_been_rating,
                          style: Theme.of(context).textTheme.headlineLarge
                              ?.copyWith(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 50),
                        CircleAvatar(
                          radius: 100,
                          backgroundColor: Colors.white,
                          child: Text(
                            '$_selectedRating/5',
                            style: TextStyle(
                              color: ratingColor,
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          alignment: WrapAlignment.center,
                          children: List.generate(5, (index) {
                            final starIndex = index + 1;
                            return Icon(
                              starIndex <= _selectedRating
                                  ? Icons.star
                                  : Icons.star_border,
                              size: 50,
                              color: Colors.white,
                            );
                          }),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          '"${_commentController.text}"',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.copyWith(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 50),
                        Text(
                          translation.thanks_for_rating,
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Image.asset(
                          _getEmojiByRating(_selectedRating),
                          width: 100,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }

          // Scaffold para MODO EDICIÓN
          return Scaffold(
            appBar: AppBar(title: Text(translation.rating)),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/rating/logo-full.png',
                          width: 200,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const CircleAvatar(
                      radius: 100,
                      backgroundImage: AssetImage(
                        'assets/images/rating/image-rating.png',
                      ),
                    ),
                    const SizedBox(height: 50),
                    Text(
                      translation.rating_title,
                      style: Theme.of(context).textTheme.headlineLarge,
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      translation.rating_text,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      alignment: WrapAlignment.center,
                      children: List.generate(5, (index) {
                        final starIndex = index + 1;
                        return IconButton(
                          icon: Icon(
                            starIndex <= _selectedRating
                                ? Icons.star
                                : Icons.star_border,
                            size: 50,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          onPressed: () => _onStarTapped(starIndex),
                        );
                      }),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: translation.comment,
                        hintText: translation.rating_title,
                      ),
                      maxLines: 4,
                    ),
                    const SizedBox(height: 20),
                    RoundedButton(
                      press: () {
                        if (_selectedRating == 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(translation.select_rating_first),
                            ),
                          );
                          return;
                        }
                        if (_commentController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                translation.is_required(translation.comment),
                              ),
                            ),
                          );
                          return;
                        }

                        final authState = context.read<AuthBloc>().state;
                        if (authState is AuthAuthenticated) {
                          context.read<RatingBloc>().add(
                            SendRatingEvent(
                              clientId: authState.user.id,
                              rating: _selectedRating,
                              comment: _commentController.text,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(translation.error_try_again_later),
                            ),
                          );
                        }
                      },
                      text: translation.send,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
