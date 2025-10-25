import 'package:flutter/material.dart';
import 'package:heylex/core/theme/theme_provider.dart';
import 'package:heylex/features/auth/pages/auth_gate.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://ucexexydpoelxkcfdxdt.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVjZXhleHlkcG9lbHhrY2ZkeGR0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjEzMjg3NzQsImV4cCI6MjA3NjkwNDc3NH0.LHoGLJs8fSsJkmt7VMpWyAWTuNDlGK8A-JUE2g9EnC8',
  );


  runApp( MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ThemeProvider()),
  ],
  child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HeyLex',
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: AuthGate(),
    );
  }
}