import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitpill/generated/l10n/l10n.dart';
import 'package:fitpill/features//auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitpill/features/auth/auth_notifier.dart';
class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  ConsumerState<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPassword = TextEditingController();
  final _newPassword = TextEditingController();
  final _confirmPassword = TextEditingController();
  bool _canSendReset = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _currentPassword.dispose();
    _newPassword.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    if (_newPassword.text == _currentPassword.text) {
      _showError(S.of(context)!.newPasswordSameAsOld);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = ref.read(authProvider).value;

      if (user == null || user.email == null) {
        _showError(S.of(context)!.generalError);
        return;
      }

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: _currentPassword.text.trim(),
      );

      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(_newPassword.text.trim());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context)!.passwordChanged)),
        );
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String message;
      switch (e.code) {
        case 'wrong-password':
          message = S.of(context)!.wrongPassword;
          break;
        case 'weak-password':
          message = S.of(context)!.weakPassword;
          break;
        default:
          message = S.of(context)!.generalError;
      }
      _showError(message);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _sendResetEmail() async {
    if (!_canSendReset) return;

    final user = ref.read(authProvider).value;

    if (user?.email == null) {
      _showError(S.of(context)!.generalError);
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: user!.email!);
      if (!mounted) return;

      setState(() => _canSendReset = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context)!.passwordResetEmailSent)),
      );

      Future.delayed(const Duration(seconds: 60), () {
        if (mounted) setState(() => _canSendReset = true);
      });
    } catch (_) {
      _showError(S.of(context)!.generalError);
    }
  }

  void _showResetConfirmation() {
    final user = ref.read(authProvider).value;

    if (user?.email == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Icon(Icons.email_outlined,
            size: 40, color: Colors.blueAccent),
        content: Text(
          "${S.of(context)!.resetEmailWillBeSentTo}\n\n${user!.email!}",
          textAlign: TextAlign.center,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(S.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _sendResetEmail();
            },
            child: Text(S.of(context)!.send),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context)!.passwordChange),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildField(
                  _currentPassword, S.of(context)!.currentPassword, Icons.lock),
              const SizedBox(height: 15),
              _buildField(
                  _newPassword, S.of(context)!.newPassword, Icons.lock_reset),
              const SizedBox(height: 15),
              TextFormField(
                controller: _confirmPassword,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: S.of(context)!.confirmPassword,
                  prefixIcon: const Icon(Icons.lock_reset),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value != _newPassword.text.trim()) {
                    return S.of(context)!.passwordsNotMatch;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: Text(S.of(context)!.save),
                onPressed: _isLoading ? null : _changePassword,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: _canSendReset ? _showResetConfirmation : null,
                child: Text(
                  _canSendReset
                      ? S.of(context)!.forgotPassword
                      : S.of(context)!.emailSent,
                  style: TextStyle(
                    color: _canSendReset ? null : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(
      TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      validator: (value) =>
          value == null || value.isEmpty ? S.of(context)!.requiredField : null,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'\s')),
      ],
    );
  }
}
