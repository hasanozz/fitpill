import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitpill/core/ui/widgets/app_schimmer.dart';
import 'package:fitpill/features/auth/auth_notifier.dart';
import 'package:fitpill/features/auth/pages/register_page.dart';
import 'package:fitpill/features/profile/setup_pages/setup_screen_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitpill/generated/l10n/l10n.dart';
import 'package:fitpill/app/shell/bottom_nav_shell.dart';

// import '../../profile/setup_pages/setup_screen_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool _passwordVisible = false;
  bool _isSendingReset = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login(WidgetRef ref) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => isLoading = true);

    final authNotifier = ref.read(authProvider.notifier);
    final errorMessage = await authNotifier.signIn(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    setState(() => isLoading = false);

    if (errorMessage == null) {
      if (!mounted) return;
      FocusScope.of(context).unfocus();

      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        final setupCompleted = userDoc.data()?['setupCompleted'] == true;

        if (!mounted) return;

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) =>
                setupCompleted ? const MainMenu() : const SetupPage(),
          ),
          (route) => false,
        );
      }
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_translateErrorMessage(errorMessage))),
      );
    }
  }

  String _translateErrorMessage(String errorMessage) {
    switch (errorMessage) {
      case "user_not_found":
        return S.of(context)!.userNotFound;
      case "wrong_password":
        return S.of(context)!.wrongPassword;
      case "unknown_error":
        return S.of(context)!.unknownError;
      default:
        return S.of(context)!.loginFailed;
    }
  }

  Future<void> _sendResetEmail(String email) async {
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context)!.emailEmpty)),
      );
      return;
    }

    setState(() => _isSendingReset = true);

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context)!.passwordResetLink)),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      late String message;
      switch (e.code) {
        case 'user-not-found':
          message = S.of(context)!.userNotFound;
          break;
        case 'invalid-email':
          message = S.of(context)!.emailInvalid;
          break;
        default:
          message = S.of(context)!.loginFailed;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } finally {
      if (mounted) {
        setState(() => _isSendingReset = false);
      }
    }
  }

  void _showForgotPasswordDialog() {
    final controller =
        TextEditingController(text: emailController.text.trim());

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(S.of(ctx)!.resetPassword),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(ctx)!.resetEmailWillBeSentTo,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email_outlined),
                  hintText: S.of(ctx)!.email,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text(S.of(ctx)!.cancel),
            ),
            ElevatedButton(
              onPressed: _isSendingReset
                  ? null
                  : () {
                      final email = controller.text.trim();
                      Navigator.of(ctx).pop();
                      _sendResetEmail(email);
                    },
              child: _isSendingReset
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(S.of(ctx)!.send),
            ),
          ],
        );
      },
    ).then((_) => controller.dispose());
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
          body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.blue.shade800,
              Colors.blue.shade600,
              Colors.blue.shade400,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).viewPadding.top,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    _buildHeader(),
                    const SizedBox(height: 30),
                    _buildAuthCard(),
                    const SizedBox(height: 20),
                    _buildRegisterButton(),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ),
      )),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          S.of(context)!.welcome,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          S.of(context)!.fitpillSlogan,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildAuthCard() {
    return Card(
      color: Colors.white70,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildEmailField(),
              const SizedBox(height: 20),
              _buildPasswordField(),
              const SizedBox(height: 12),
              _buildForgotPasswordButton(),
              const SizedBox(height: 30),
              _buildLoginButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return S.of(context)!.emailEmpty;
        }
        String pattern =
            r'^[a-zA-Z0-9.a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
        RegExp regex = RegExp(pattern);
        if (!regex.hasMatch(value)) {
          return S.of(context)!.emailInvalid;
        }
        return null;
      },
      style: TextStyle(color: Colors.blue.shade800),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.email, color: Colors.blue.shade600),
        labelText: S.of(context)!.email,
        labelStyle: TextStyle(color: Colors.blue.shade600),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: passwordController,
      obscureText: !_passwordVisible,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return S.of(context)!.passwordEmpty;
        }
        if (value.length < 6) {
          return S.of(context)!.passwordMinLength;
        }
        return null;
      },
      style: TextStyle(color: Colors.blue.shade800),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock, color: Colors.blue.shade600),
        labelText: S.of(context)!.password,
        labelStyle: TextStyle(color: Colors.blue.shade600),
        suffixIcon: IconButton(
          icon: Icon(
            _passwordVisible ? Icons.visibility_off : Icons.visibility,
            color: Colors.blue.shade600,
          ),
          onPressed: () {
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildForgotPasswordButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: _isSendingReset ? null : _showForgotPasswordDialog,
        child: Text(
          S.of(context)!.forgotPassword,
          style: TextStyle(
            color: Colors.blue.shade800,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : () => _login(ref),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade800,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
        ),
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: AppShimmer(
                  height: 24,
                  width: 24,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              )
            : Text(
                S.of(context)!.login,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return TextButton(
      onPressed: () => Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (_, __, ___) => const RegisterPage(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      ),
      child: RichText(
        text: TextSpan(
          text: "${S.of(context)!.noAccountQuestion} ",
          style: const TextStyle(color: Colors.white70),
          children: [
            TextSpan(
              text: S.of(context)!.register,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
