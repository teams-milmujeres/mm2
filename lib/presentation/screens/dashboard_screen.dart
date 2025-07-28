import 'package:flutter/material.dart';
// Navigation
import 'package:go_router/go_router.dart';
import 'package:milmujeres_app/presentation/navigation_options.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final translation = AppLocalizations.of(context)!;
    final dashboardOptions =
        navigationOptions
            .where(
              (opt) => [
                '/profile',
                '/upload_document',
                '/deposits',
                '/caases_stage',
                '/complaints',
                '/contact_us',
              ].contains(opt.route),
            )
            .toList();

    return Scaffold(
      // appBar: AppBar(title: Text(translation.dashboard)),
      body: Center(
        child: GridView.builder(
          padding: const EdgeInsets.all(10),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300,
          ),
          itemCount: dashboardOptions.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: DashboardCard(option: dashboardOptions[index]),
            );
          },
        ),
      ),
    );
  }
}

class DashboardCard extends StatefulWidget {
  final NavigationOption option;

  const DashboardCard({super.key, required this.option});

  @override
  State<DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTapDown: (_) => setState(() => isPressed = true),
      onTapUp: (_) => setState(() => isPressed = false),
      onTapCancel: () => setState(() => isPressed = false),
      onTap: () {
        setState(() => isPressed = false);
        context.push(widget.option.route);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        child: Card(
          color:
              isPressed
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onPrimary,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.option.icon,
                size: 30,
                color:
                    isPressed
                        ? theme.colorScheme.onPrimary
                        : theme.primaryColor,
              ),
              const SizedBox(height: 10),
              Flexible(
                child: Text(
                  widget.option.labelBuilder(context),
                  style: TextStyle(
                    color:
                        isPressed
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
