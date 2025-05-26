import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/login_screen.dart'; // pastikan file login_screen.dart ada
import 'screens/home_screen.dart'; // kita akan buat file ini setelah ini

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://uontaihgjozndztsgzpf.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVvbnRhaWhnam96bmR6dHNnenBmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDgyMjAzMTAsImV4cCI6MjA2Mzc5NjMxMH0.gDa_LIXbw8Fq8l0hxDNIhQMk8VMSJvNOQpFUzHIHcAg',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthRedirect(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        // '/register': (context) => RegisterScreen(), // tambahkan jika sudah ada
      },
    );
  }
}

class AuthRedirect extends StatelessWidget {
  const AuthRedirect({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;

    if (session == null) {
      Future.microtask(() {
        Navigator.pushReplacementNamed(context, '/login');
      });
    } else {
      Future.microtask(() {
        Navigator.pushReplacementNamed(context, '/home');
      });
    }

    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
