import 'package:flutter/material.dart';
import 'package:heylex/features/auth/pages/auth_page.dart';
import 'package:heylex/features/home/presentation/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:  Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
          
        }

        final session = snapshot.hasData ? snapshot.data!.session : null;

        if (session != null) {
          return HomePage();
        } else {
          return AuthPage();
          
        }
      },
    );
  }
}