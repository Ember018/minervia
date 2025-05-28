import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:minervia_frontend/home.dart';
import 'package:minervia_frontend/register_screen.dart';
import 'package:minervia_frontend/theme/app_theme.dart';

final _storage = FlutterSecureStorage();

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _parseError(dynamic errorBody) {
    if (errorBody is Map<String, dynamic>) {
      // Try to get the first error message from the map
      for (var key in errorBody.keys) {
        if (errorBody[key] is List && (errorBody[key] as List).isNotEmpty) {
          return errorBody[key][0].toString();
        } else if (errorBody[key] is String) {
          return errorBody[key].toString();
        }
      }
      return "An unknown validation error occurred.";
    } else if (errorBody is String) {
      return errorBody;
    }
    return "Failed to parse error.";
  }

  Future<void> _loginUser() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse("http://127.0.0.1:8000/accounts/token/");
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    final body = jsonEncode({
      'username': username,
      'password': password,
    });

    try {
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: body,
          )
          .timeout(const Duration(seconds: 10));

      if (!mounted) return;

      if (response.statusCode == 200) {
        print("login successfully");
        final responseBody = jsonDecode(response.body);

        final access = responseBody['access'];
        final refresh = responseBody['refresh'];
        if (access != null && refresh != null) {
          // Write tokens
          await _storage.write(key: 'accessToken', value: access);
          await _storage.write(key: 'refreshToken', value: refresh);

          // Read tokens
          String? accessToken = await _storage.read(key: 'accessToken');
          String? refreshToken = await _storage.read(key: 'refreshToken');

          print(accessToken);
          print(refreshToken);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Congrats $username, you have logged in!"),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Homepage()));
        } else {
          print("Access or Refresh token is null in response");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text("Login failed: Invalid token response from server."),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        String errorMessage = "Login failed. Please try again";
        if (response.body.isNotEmpty) {
          try {
            final errorBody = jsonDecode(response.body);
            errorMessage = _parseError(errorBody) ?? errorMessage;
          } catch (e) {
            print("Failed to decode JSON error: ${response.body}");
            errorMessage =
                "An unexpected error format was received from the server";
          }
        } else {
          errorMessage =
              "Login failed with status code: ${response.statusCode}";
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      print("An erorr occurred: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An error occurred: ${e.toString()}"),
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
        body: Padding(
      padding: const EdgeInsets.all(18.0),
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(minHeight: viewportConstraints.maxHeight),
            child: IntrinsicHeight(
              child: Form(
                key: _formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Please enter an username";
                            }
                            return null;
                          },
                          controller: _usernameController,
                          decoration: InputDecoration(
                              labelText: "Username",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.person))),
                      const SizedBox(height: 16),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter a password";
                          }
                          return null;
                        },
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: "Password",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                              icon: Icon(_obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              }),
                        ),
                        obscureText: _obscurePassword,
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        child: _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : const Text("Login"),
                        onPressed: _isLoading ? null : _loginUser,
                      ),
                      const SizedBox(height: 32),
                      InkWell(
                          child: Text("Don't have an account? Register now!",
                              style: TextStyle(color: AppTheme.primaryPink)),
                          onTap: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const RegisterScreen()),
                              (Route<dynamic> route) => false,
                            );
                          }),
                    ]),
              ),
            ),
          ),
        );
      }),
    ));
  }
}
