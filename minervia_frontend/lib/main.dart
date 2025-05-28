import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:minervia_frontend/login_creen.dart';
import 'package:minervia_frontend/register_screen.dart';
import 'package:minervia_frontend/home.dart';
import 'package:minervia_frontend/theme/app_theme.dart';

Future<String?> getInitialRoute() async {
  final storage = FlutterSecureStorage();
  String? token = await storage.read(key: 'accessToken');
  // You might add token validation logic here later
  if (token != null) {
    return '/home'; // Or whatever your home route is
  }
  return '/login'; // Or your login route
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Important if main is async
  String initialRoute =
      await getInitialRoute() == '/home' ? '/home' : '/login'; // Simplified
  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Minervia",
      theme: AppTheme.darkTheme,
      initialRoute: initialRoute, // Set initial route
      routes: {
        // Define your routes
        '/login': (context) => LoginScreen(),
        '/home': (context) => Homepage(), // Your main app screen
        '/register': (context) => RegisterScreen(),
      },
      // You might set `home` instead of `initialRoute` if logic is simpler
    );
  }
}
