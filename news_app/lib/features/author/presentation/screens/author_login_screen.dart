import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../auth/presentation/screens/auth_shell.dart';
import '../controllers/author_controller.dart';

class AuthorLoginScreen extends ConsumerStatefulWidget {
  const AuthorLoginScreen({super.key});

  @override
  ConsumerState<AuthorLoginScreen> createState() => _AuthorLoginScreenState();
}

class _AuthorLoginScreenState extends ConsumerState<AuthorLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _bioController = TextEditingController();
  bool _isRegister = false;

  @override
  void initState() {
    super.initState();
    ref.listenManual<AuthorState>(authorControllerProvider, (previous, next) {
      if (next.message != null && mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.message!)));
        ref.read(authorControllerProvider.notifier).clearMessage();
      }

      if ((previous?.session == null) && next.session != null && mounted) {
        context.go(AppRoutes.authorStudio);
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authorControllerProvider);

    return AuthShell(
      title: 'Author access for publishing.',
      subtitle:
          'Log in as an author to publish stories directly into the PulseWire feed that readers see.',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: false, label: Text('Login')),
                ButtonSegment(value: true, label: Text('Register')),
              ],
              selected: {_isRegister},
              onSelectionChanged: (selection) {
                setState(() => _isRegister = selection.first);
              },
            ),
            const SizedBox(height: 18),
            if (_isRegister) ...[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Author name',
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
                validator: (value) {
                  if (_isRegister &&
                      (value == null || value.trim().length < 2)) {
                    return 'Enter your author name.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
            ],
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.mail_outline_rounded),
              ),
              validator: (value) {
                if (value == null || !value.contains('@')) {
                  return 'Enter a valid email.';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock_outline_rounded),
              ),
              validator: (value) {
                if (value == null || value.length < 6) {
                  return 'Use at least 6 characters.';
                }
                return null;
              },
            ),
            if (_isRegister) ...[
              const SizedBox(height: 14),
              TextFormField(
                controller: _bioController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Short bio',
                  prefixIcon: Icon(Icons.edit_note_rounded),
                ),
              ),
            ],
            const SizedBox(height: 22),
            ElevatedButton(
              onPressed: state.isLoading
                  ? null
                  : () async {
                      if (!(_formKey.currentState?.validate() ?? false)) {
                        return;
                      }

                      if (_isRegister) {
                        await ref
                            .read(authorControllerProvider.notifier)
                            .register(
                              name: _nameController.text.trim(),
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim(),
                              bio: _bioController.text.trim(),
                            );
                      } else {
                        await ref
                            .read(authorControllerProvider.notifier)
                            .login(
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim(),
                            );
                      }
                    },
              child: state.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      _isRegister ? 'Create Author Account' : 'Login as Author',
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
