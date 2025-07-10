import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:milmujeres_app/presentation/bloc/offices/bloc/offices_bloc.dart';

class OfficeScreen extends StatelessWidget {
  const OfficeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final translation = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(translation.offices)),
      body: BlocBuilder<OfficesBloc, OfficesState>(
        bloc: OfficesBloc()..add(GetOfficesEvent()),
        builder: (context, state) {
          switch (state.runtimeType) {
            case const (OfficesLoading):
              return const Center(child: CircularProgressIndicator());
            case const (OfficesError):
              final errorState = state as OfficesError;
              return Center(child: Text(errorState.errorMessage));
            case const (OfficesSuccess):
              final successState = state as OfficesSuccess;
              // Replace with actual office data
              return Center(
                child: GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300,
                    // childAspectRatio: 3 / 2,
                    // crossAxisSpacing: 20,
                    // mainAxisSpacing: 20,
                  ),
                  itemCount: successState.offices.length,
                  itemBuilder: (BuildContext context, int index) {
                    final office = successState.offices[index];
                    return TweenAnimationBuilder(
                      duration: Duration(milliseconds: 300 + (index * 100)),
                      tween: Tween<double>(begin: 0, end: 1),
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.scale(scale: value, child: child),
                        );
                      },
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Image.network(
                          office.imageUrl ?? '',
                          fit: BoxFit.cover,
                          errorBuilder:
                              (_, __, ___) =>
                                  const Icon(Icons.image_not_supported),
                        ),
                      ),
                    );
                  },
                ),
              );
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
