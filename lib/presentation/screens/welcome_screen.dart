import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mil Mujeres'),
        actions: [
          TextButton(onPressed: () {}, child: Text('About Us')),
          TextButton(onPressed: () {}, child: Text('Join Us')),
          TextButton(onPressed: () {}, child: Text('Contact Us')),
          TextButton(onPressed: () {}, child: Text('Services')),
          TextButton(onPressed: () {}, child: Text('Offices')),
          TextButton(onPressed: () {}, child: Text('Consulates')),
          TextButton(onPressed: () {}, child: Text('Events')),
          FilledButton(
            onPressed: () {
              // Navigate to settings screen
            },
            child: Row(
              children: [
                Icon(Icons.favorite),
                SizedBox(width: 4),
                Text('Donate'),
              ],
            ),
          ),
          // Un espacio entre los botones de donate y login
          SizedBox(width: 8),
          FilledButton(
            onPressed: () {
              // Navigate to settings screen
            },
            child: Row(
              children: [Icon(Icons.person), SizedBox(width: 4), Text('Login')],
            ),
          ),
        ],
      ),
      body: Center(child: Text('Welcome to the app!')),
    );
  }
}
