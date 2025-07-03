// Flutter and Riverpod imports
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:frontend/core/theme/app_pallete.dart';
import 'package:frontend/core/utils.dart';
import 'package:frontend/core/widgets/loader.dart';
import 'package:frontend/features/auth/view/pages/signup_page.dart';
import 'package:frontend/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:frontend/core/widgets/custom_field.dart';
import 'package:frontend/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:frontend/features/home/view/pages/home_page.dart';
import 'package:frontend/features/home/view/pages/upload_song_page.dart';

// LoginPage is a stateful widget that uses Riverpod for state management
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends ConsumerState<LoginPage> {
  // Controllers for the email and password text fields
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Form key to validate form input
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Dispose controllers when the widget is removed from the widget tree
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch if authViewModel is currently loading
    final isLoading = ref.watch(
      authViewModelProvider.select((val) => val?.isLoading == true),
    );

    // Listen to changes in AuthViewModel
    ref.listen(authViewModelProvider, (_, next) {
      next?.when(
        data: (data) {
          // Show success message and navigate to HomePage on successful login
          showSnackbar(context, "You have logged in successfully");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UploadSongPage()),
          );
        },
        error: (error, st) {
          // Show error message if login fails
          showSnackbar(context, error.toString());
        },
        loading: () {}, // Do nothing explicitly on loading
      );
    });

    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? LoaderWidget() // Show loader while authenticating
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Page title
                    Text(
                      'Sign In.',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 30),

                    // Email input field
                    CustomField(hintText: "Email", controller: emailController),
                    SizedBox(height: 15),

                    // Password input field
                    CustomField(
                      hintText: "Password",
                      controller: passwordController,
                      isObscureText: true,
                    ),
                    SizedBox(height: 20),

                    // Sign In button
                    AuthGradientButton(
                      buttonText: 'Sign In',
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          // Call login method from AuthViewModel if form is valid
                          await ref
                              .read(authViewModelProvider.notifier)
                              .loginUser(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                          Future.microtask(() {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UploadSongPage(),
                              ),
                              (_) => false,
                            );
                          });
                        } else {
                          // Show error if form fields are empty/invalid
                          showSnackbar(context, 'Missing Fields');
                        }
                      },
                    ),
                    SizedBox(height: 20),

                    // Link to Sign Up page
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpPage()),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          text: 'Don\'t have an account ? ',
                          style: Theme.of(context).textTheme.titleMedium,
                          children: [
                            TextSpan(
                              text: 'Sign up',
                              style: TextStyle(
                                color: Pallete.gradient2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
