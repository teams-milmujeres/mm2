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
      child: Scaffold(
        appBar: AppBar(title: Text(translation.rating)),
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: BlocConsumer<RatingBloc, RatingState>(
            listener: (context, state) {
              if (state is RatingSend) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              } else if (state is RatingError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${state.message}')),
                );
              }
            },
            builder: (context, state) {
              if (state is RatingLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is RatingSuccess && !_isInitialized) {
                final rating = state.rating;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    _selectedRating = rating.rating;
                    _commentController.text = rating.comment;
                    _readOnly = rating.isRating;
                    _isInitialized = true;
                  });
                });
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  CircleAvatar(
                    radius: 100,
                    backgroundImage: AssetImage('assets/images/about.webp'),
                  ),

                  const SizedBox(height: 50),

                  Text(
                    translation.rating_text,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.left,
                  ),

                  const SizedBox(height: 20),

                  // Estrellas
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                        onPressed:
                            _readOnly ? null : () => _onStarTapped(starIndex),
                      );
                    }),
                  ),

                  const SizedBox(height: 20),

                  // Comentario
                  TextField(
                    controller: _commentController,
                    readOnly: _readOnly,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: translation.comment,
                    ),
                    maxLines: 4,
                  ),

                  const SizedBox(height: 20),

                  // Botón de enviar solo si no está calificado
                  if (!_readOnly)
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
              );
            },
          ),
        ),
      ),
    );
  }
}
