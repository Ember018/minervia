import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:minervia_frontend/login_creen.dart';

final _storage = FlutterSecureStorage();

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool _isLoading = false;
  Future<void> _logOut() async {
    setState(() {
      _isLoading = true;
    });

    try {
      print("Attemping to delete tokens...");
      await _storage.delete(key: "accessToken");
      await _storage.delete(key: "refreshToken");
      print("Tokens deleted.");

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      print("Erorr $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Can't logout!! You have been bamboolized"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {
            _logOut();
          },
        ),
      ),
    );
  }
}
