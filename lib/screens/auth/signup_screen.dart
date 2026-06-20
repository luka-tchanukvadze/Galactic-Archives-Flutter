import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/space_scaffold.dart';
import '../../providers/auth_provider.dart';
import 'auth_widgets.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  String _faction = 'jedi';
  bool _submitting = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_name.text.trim().isEmpty || _email.text.trim().isEmpty) {
      _showMessage('Enter your name and email');
      return;
    }
    if (_password.text.length < 8) {
      _showMessage('Password must be at least 8 characters long');
      return;
    }
    if (_password.text != _confirm.text) {
      _showMessage('Passwords do not match');
      return;
    }
    setState(() => _submitting = true);
    final auth = context.read<AuthProvider>();
    final ok = await auth.signup(
      name: _name.text,
      email: _email.text,
      password: _password.text,
      faction: _faction,
    );
    if (!mounted) return;
    setState(() => _submitting = false);
    if (ok) {
      Navigator.of(context).pop(true);
    } else {
      _showMessage(auth.error ?? 'Signup failed');
    }
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    final color = factionColor(_faction);

    return SpaceScaffold(
      appBar: AppBar(title: const Text('NEW RECRUIT')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.panel.withValues(alpha: 0.85),
                border: Border.all(color: color.withValues(alpha: 0.5)),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(Icons.person_add_alt, color: color, size: 48),
                  const SizedBox(height: 12),
                  Center(child: Text('NEW RECRUIT', style: AppTheme.title(24))),
                  const SizedBox(height: 4),
                  const Center(
                    child: Text(
                      'Choose your destiny',
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FactionToggle(
                    faction: _faction,
                    onChanged: (value) => setState(() => _faction = value),
                  ),
                  const SizedBox(height: 20),
                  SwTextField(controller: _name, label: 'NAME', accent: color),
                  const SizedBox(height: 16),
                  SwTextField(
                    controller: _email,
                    label: 'EMAIL',
                    keyboardType: TextInputType.emailAddress,
                    accent: color,
                  ),
                  const SizedBox(height: 16),
                  SwTextField(
                    controller: _password,
                    label: 'PASSWORD',
                    obscure: true,
                    accent: color,
                  ),
                  const SizedBox(height: 16),
                  SwTextField(
                    controller: _confirm,
                    label: 'CONFIRM PASSWORD',
                    obscure: true,
                    accent: color,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _submitting ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        foregroundColor: Colors.black,
                      ),
                      child: _submitting
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text(
                              'JOIN',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Already trained? Access terminal',
                      style: TextStyle(color: color),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
