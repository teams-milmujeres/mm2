import 'package:flutter/material.dart';

// Navigation
import 'package:go_router/go_router.dart';
import 'package:mm/presentation/navigation_options.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount = 2;

          if (constraints.maxWidth >= 1200) {
            crossAxisCount = 5;
          } else if (constraints.maxWidth >= 900) {
            crossAxisCount = 4;
          } else if (constraints.maxWidth >= 600) {
            crossAxisCount = 3;
          }

          return GridView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: dashboardOptions.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (context, index) {
              return DashboardCard(option: dashboardOptions[index]);
            },
          );
        },
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
      child: AnimatedScale(
        duration: const Duration(milliseconds: 120),
        scale: isPressed ? 0.97 : 1,
        child: Card(
          margin: EdgeInsets.zero,
          elevation: 3,
          color:
              isPressed ? theme.colorScheme.primary : theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: SizedBox.expand(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.option.icon,
                    size: 38,
                    color:
                        isPressed
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.primary,
                  ),

                  const SizedBox(height: 14),

                  Text(
                    widget.option.labelBuilder(context),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color:
                          isPressed
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
