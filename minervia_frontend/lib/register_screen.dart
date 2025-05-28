import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:minervia_frontend/login_creen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>(); // For form validation
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscurePasswordConfirm = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
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

  Future<void> _registerUser() async {
    // Hide keyboard
    FocusScope.of(context).unfocus();

    // Validate the from
    if (!_formKey.currentState!.validate()) {
      return; // If form is not valid, don't proceed
    }

    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse("http://127.0.0.1:8000/accounts/register/");
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final password2 = _passwordConfirmController.text;

    final body = jsonEncode({
      'username': username,
      'email': email,
      'password': password,
      'password2': password2,
    });

    try {
      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: body,
          )
          .timeout(const Duration(seconds: 10));

      if (!mounted) return;

      if (response.statusCode == 201) {
        print("Registration successful!");
        final responseBody = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "Congrats $username, you have successfully created your account!"),
              backgroundColor: Colors.green),
        );
      } else {
        String errorMessage = "Registration failed. Please try again";
        if (response.body.isNotEmpty) {
          try {
            final errorBody = jsonDecode(response.body);
            errorMessage = _parseError(errorBody) ?? errorMessage;
          } catch (e) {
            print("Failed to decode error JSON: ${response.body}");
            errorMessage =
                "An unexpected error format was received from the server.";
          }
        } else {
          errorMessage =
              "Registration failed with status code: ${response.statusCode}";
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
      print("An error occurred: $e");
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
        child: Form(
          key: _formKey,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter a username";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        labelText: "username",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person)),
                    controller: _usernameController),
                const SizedBox(height: 16),
                TextFormField(
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter an email';
                      }
                      if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "email",
                      border: OutlineInputBorder(),
                      prefix: Icon(Icons.email),
                    ),
                    controller: _emailController),
                const SizedBox(height: 16),
                TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: "password",
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    obscureText: _obscurePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 8) {
                        return "Password must have at least 8 character";
                      }
                      return null;
                    }),
                const SizedBox(height: 16),
                TextFormField(
                    controller: _passwordConfirmController,
                    decoration: InputDecoration(
                      labelText: "password confirmation",
                      border: const OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePasswordConfirm
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _obscurePasswordConfirm = !_obscurePasswordConfirm;
                          });
                        },
                      ),
                    ),
                    obscureText: _obscurePasswordConfirm,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please confirm your password";
                      }
                      if (value != _passwordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    }),
                const SizedBox(height: 32),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                        child: const Text("Register"),
                        onPressed: () {
                          _registerUser();
                        }),
                const SizedBox(height: 32),
                InkWell(
                    child: Text("Already have an account? Log in!"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    }),
              ]),
        ),
      ),
    );
  }
}
