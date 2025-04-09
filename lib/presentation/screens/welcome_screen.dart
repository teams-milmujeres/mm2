import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kIsWeb ? WebAppBar() : AndroidAppBar(),
      body: Center(child: Text('Welcome to the app!')),
    );
  }
}

class AndroidAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  const AndroidAppBar({super.key})
    : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Mil Mujeres'),
      actions: [
        TextButton(onPressed: () {}, child: Text('Contact Us')),
        TextButton(onPressed: () {}, child: Text('Offices')),
        TextButton(onPressed: () {}, child: Text('Consulates')),
        TextButton(onPressed: () {}, child: Text('Events')),
      ],
    );
  }
}

class WebAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  const WebAppBar({super.key})
    : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  State<WebAppBar> createState() => _WebAppBarState();
}

class _WebAppBarState extends State<WebAppBar> {
  String selectedLocale = "en"; // Idioma predeterminado

  void _onLocaleChanged(String value) {
    setState(() {
      selectedLocale = value;
    });

    if (kDebugMode) {
      print('Idioma seleccionado: $value');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Mil Mujeres'),
      actions: [
        TextButton(onPressed: () {}, child: Text('Contact Us')),
        TextButton(onPressed: () {}, child: Text('Offices')),
        TextButton(onPressed: () {}, child: Text('Consulates')),
        TextButton(onPressed: () {}, child: Text('Events')),
        _CustomDropDownUnderlineWelcome(
          selectedLocale: selectedLocale,
          onLocaleChanged: _onLocaleChanged,
        ),
        FilledButton(
          onPressed: () {
            // Navegar a la pantalla de donaciones
          },
          child: Row(
            children: [
              Icon(Icons.favorite),
              SizedBox(width: 4),
              Text('Donate'),
            ],
          ),
        ),
        SizedBox(width: 8),
        FilledButton(
          onPressed: () {
            // Navegar a la pantalla de inicio de sesión
          },
          child: Row(
            children: [Icon(Icons.person), SizedBox(width: 4), Text('Login')],
          ),
        ),
      ],
    );
  }
}

class _CustomDropDownUnderlineWelcome extends StatelessWidget {
  _CustomDropDownUnderlineWelcome({
    required this.selectedLocale,
    required this.onLocaleChanged,
  });

  final String selectedLocale;
  final ValueChanged<String> onLocaleChanged;
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButton<String>(
          focusNode: _focusNode,
          underline: const SizedBox(),
          value: selectedLocale,
          items: [
            DropdownMenuItem(
              value: "en",
              child: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    Icon(Icons.language, color: Colors.blue),
                    const SizedBox(width: 10),
                    Text(
                      'English',
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            DropdownMenuItem(
              value: "es",
              child: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    Icon(Icons.language, color: Colors.red),
                    const SizedBox(width: 10),
                    Text(
                      'Español',
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ],
          onChanged: (String? value) {
            if (value != null) {
              onLocaleChanged(value);
            }
            _focusNode.unfocus(); // Desenfocar el DropdownButton
          },
        ),
      ),
    );
  }
}
