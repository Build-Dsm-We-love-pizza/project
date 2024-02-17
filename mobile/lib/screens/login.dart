// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile/constants/text.dart';
import 'package:mobile/helpers/fire_auth.dart';
import 'package:mobile/screens/HomeScreen.dart';
import 'package:mobile/widgets/custom_snackbar.dart';
import 'package:mobile/wrapper.dart';
// import 'package:login_app/components/components.dart';
// import 'package:login_app/constants.dart';
// import 'package:login_app/screens/welcome.dart';
// import 'package:loading_overlay/loading_overlay.dart';
// import 'package:login_app/screens/home_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String id = 'login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // final _auth = FirebaseAuth.instance;
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            Text('Hello!', style: loginHeading),
            SizedBox(height: 22),
            Text('Please Sign in to continue',
                style: login2.copyWith(fontSize: 16)),
            SizedBox(height: 54),
            //LOGIN FORM
            Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //EMAIL SECTION
                  Text('Email', style: login2),
                  SizedBox(height: 8),
                  TextFormField(
                    validator: _validateEmail,
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  //PASSWORD SECTION
                  Text('Password', style: login2),
                  const SizedBox(height: 8),
                  TextFormField(
                    validator: _validatePassword,
                    controller: _passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () => _togglePasswordVisibility()),
                    ),
                  ),

                  //
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      User? usr = await FireAuth.loginWithEmailPass(
                          email: _emailController.text,
                          password: _passwordController.value.text,
                          ctx: context);

                      if (usr != null) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => Wrapper()),
                        );
                      }
                      // if (_shouldAccept()) {
                      //   await AuthService().emailSignIn(
                      //     email: _emailController.value.text,
                      //     password: _passwordController.text,
                      //     context: context,
                      //   );
                      //   await AuthService().auth.updateUser(
                      //         UserAttributes(data: {
                      //           'isOrganizer': true,
                      //         }),
                      //       );
                      // } else {
                      //   context
                      //       .showErrorSnackBar('Please fill the above fields');
                      // }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(double.infinity, 0),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                      child: Text(
                        'Sign in',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Spacer(),
          ],
        ),
      ),
    );
  }

  bool _shouldAccept() {
    if (_emailController.value.text.isNotEmpty &&
        _passwordController.value.text.isNotEmpty &&
        _validateEmail(_emailController.value.text) == null &&
        _validatePassword(_passwordController.value.text) == null) {
      return true;
    } else {
      return false;
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  String? _validateEmail(String? email) {
    if (email != null) {
      if (email.isEmpty) {
        return 'Email is required.';
      } else if (!RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
          .hasMatch(email)) {
        return 'Enter a valid email address.';
      }
    }
    return null;
  }

  String? _validatePassword(String? password) {
    if (password != null) {
      if (password.isEmpty) {
        return 'Password is required';
      }
      if (password.length < 4) {
        return 'Password must be at least 8 characters long';
      }
      // if (!password.contains(RegExp(r'[A-Z]'))) {
      //   return 'Password must contain at least one uppercase letter';
      // }
      if (!password.contains(RegExp(r'[a-z]'))) {
        return 'Password must contain at least one lowercase letter';
      }
      // if (!password.contains(RegExp(r'[0-9]'))) {
      //   return 'Password must contain at least one number';
      // }
    }
    return null;
  }
}
