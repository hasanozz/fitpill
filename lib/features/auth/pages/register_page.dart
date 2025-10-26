import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitpill/core/ui//widgets/app_schimmer.dart';
import 'package:fitpill/features/auth/auth_notifier.dart';
import 'package:fitpill/features/auth/pages/login_page.dart';
import 'package:fitpill/features/profile/setup_pages/setup_screen_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:fitpill/generated/l10n/l10n.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  bool isLoading = false;
  bool _passwordVisible = false;
  bool _isSendingReset = false;
  bool isPrivacyAccepted = false; // KVKK onay değişkeni

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => isLoading = true);

    String formattedName = nameController.text
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ')
        .split(' ')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
            : '')
        .join(' ');

    final authNotifier = ref.read(authProvider.notifier); // ✅
    final errorMessage = await authNotifier.signUp(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      name: formattedName,
    );

    setState(() => isLoading = false);

    if (!mounted) return;

    _handleRegistrationResult(errorMessage);
  }

  void _handleRegistrationResult(String? errorMessage) async {
    if (errorMessage == null) {
      FocusScope.of(context).unfocus();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context)!.registrationSuccessful)),
      );

      // Kullanıcıyı otomatik giriş yaptır
      final authNotifier = ref.read(authProvider.notifier);
      await authNotifier.signIn(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // `MainMenu`'ye yönlendir
      if (!mounted) return;
      FocusScope.of(context).unfocus(); // klavyeyi kapat
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SetupPage()),
          (route) => false,
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_translateErrorMessage(errorMessage))),
      );
    }
  }

  String _translateErrorMessage(String errorMessage) {
    switch (errorMessage) {
      case "weak_password":
        return S.of(context)!.weakPassword;
      case "email_exists":
        return S.of(context)!.emailExists;
      case "user_not_found":
        return S.of(context)!.userNotFound;
      case "wrong_password":
        return S.of(context)!.wrongPassword;
      case "firestore_error":
        return S.of(context)!.firestoreError;
      default:
        return S.of(context)!.unknownError;
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
          message = S.of(context)!.unknownError;
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
              onPressed: () => Navigator.of(ctx).pop(),
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
        resizeToAvoidBottomInset: true,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                Colors.teal.shade800,
                Colors.teal.shade600,
                Colors.teal.shade400,
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      _buildHeader(),
                      const SizedBox(height: 20),
                      _buildRegistrationForm(),
                      _buildLoginButton(),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          S.of(context)!.createNewAccount,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          S.of(context)!.registerSlogan,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'\s')),
      ],
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
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'\s')),
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return S.of(context)!.passwordEmpty;
        }
        if (value.length < 6) {
          return S.of(context)!.passwordMinLength;
        }
        if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$')
            .hasMatch(value)) {
          return S.of(context)!.passwordRequirements;
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
            color: Colors.teal.shade800,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: nameController,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'\s{2,}')),
        // Birden fazla boşluğu engelle
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return S.of(context)!.nameEmpty;
        }
        if (value.length < 3) {
          return S.of(context)!.nameMinLength;
        }
        return null;
      },
      style: TextStyle(color: Colors.blue.shade800),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.person, color: Colors.blue.shade600),
        labelText: S.of(context)!.name,
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

  Widget _buildPrivacyPolicyCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Checkbox(
          value: isPrivacyAccepted,
          onChanged: (value) {
            setState(() {
              isPrivacyAccepted = value ?? false;
            });
          },
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              launchUrl(
                  Uri.parse("https://yourwebsite.com/kvkk")); // KVKK Linki
            },
            child: Text(
              S.of(context)!.privacyPolicy,
              style: const TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.blue,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading
            ? null
            : () {
                if (!isPrivacyAccepted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(S.of(context)!.acceptPrivacyPolicy),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                  return;
                }
                _register();
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal.shade800,
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
                S.of(context)!.register,
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

  Widget _buildRegistrationForm() {
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
              _buildNameField(),
              const SizedBox(height: 20),
              _buildEmailField(),
              const SizedBox(height: 20),
              _buildPasswordField(),
              const SizedBox(height: 12),
              _buildForgotPasswordButton(),
              const SizedBox(height: 10),
              _buildPrivacyPolicyCheckbox(),
              const SizedBox(height: 30),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return TextButton(
      onPressed: () => Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (_, __, ___) => const LoginPage(),
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
          text: "${S.of(context)!.alreadyHaveAccountQuestion} ",
          style: const TextStyle(color: Colors.white70),
          children: [
            TextSpan(
              text: S.of(context)!.login,
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
