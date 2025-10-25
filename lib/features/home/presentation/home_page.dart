import 'package:flutter/material.dart';
import 'package:heylex/core/theme/theme_provider.dart';
import 'package:heylex/features/auth/service/auth_service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("HeyLex"),
        actions: [
          IconButton(
            icon: Icon(Icons.sunny),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
          IconButton(
            onPressed: AuthService().signOut,
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Text(
          AuthService().getCurrentUserEmail() ?? "Hoşgeldiniz!",
          style: TextStyle(
            fontFamily: 'OpenDyslexic',
            fontSize: 24,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
      ),
    );
  }
}
