import 'package:flutter/material.dart';
import 'package:milmujeres_app/l10n/app_localizations.dart';
import 'package:milmujeres_app/data/helpers/launch_url.dart';
import 'package:milmujeres_app/widgets/rounded_button_large.dart';

class DonateScreen extends StatelessWidget {
  const DonateScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final translation = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(translation.donate)),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.3,
                    'assets/images/about.webp',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              translation.donate_message,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              translation.mm_donate_txt,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 30),
            RoundedButtonLarge(
              text: translation.donate,
              press:
                  () => UrlLauncherHelper.launchURL(
                    url: 'https://givebutter.com/KI0Y2G',
                  ),
              icon: Icons.favorite,
            ),
          ],
        ),
      ),
    );
  }
}
