import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../controllers/auth_controller.dart';
import 'auth_shell.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    ref.listenManual<AuthState>(authControllerProvider, (previous, next) {
      if (next.message != null && mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.message!)));
        ref.read(authControllerProvider.notifier).clearMessage();
      }

      if ((previous?.user == null) && next.user != null && mounted) {
        context.go(AppRoutes.home);
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final theme = Theme.of(context);

    return AuthShell(
      title: 'A calmer way to follow the world.',
      subtitle:
          'Sign in to unlock personalized briefings, bookmarks, and a reading experience designed to feel premium on every screen.',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome back', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 6),
            Text(
              'Smart curation, smooth reading, and alerts that matter.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 22),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email address',
                prefixIcon: Icon(Icons.mail_outline_rounded),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Email is required.';
                }
                if (!value.contains('@')) {
                  return 'Enter a valid email.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Password is required.';
                }
                if (value.length < 6) {
                  return 'Use at least 6 characters.';
                }
                return null;
              },
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => context.push(AppRoutes.forgotPassword),
                child: const Text('Forgot password?'),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: authState.isLoading
                  ? null
                  : () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        await ref
                            .read(authControllerProvider.notifier)
                            .signIn(
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim(),
                            );
                      }
                    },
              child: authState.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2.2),
                    )
                  : const Text('Sign In'),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(child: Divider(color: theme.dividerColor)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text('or', style: theme.textTheme.bodySmall),
                ),
                Expanded(child: Divider(color: theme.dividerColor)),
              ],
            ),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: authState.isLoading
                  ? null
                  : () => ref
                        .read(authControllerProvider.notifier)
                        .signInWithGoogle(),
              icon: const Icon(Icons.g_mobiledata_rounded, size: 28),
              label: const Text('Continue with Google'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: authState.isLoading
                  ? null
                  : () => ref
                        .read(authControllerProvider.notifier)
                        .continueAsGuest(),
              child: const Text('Explore in guest mode'),
            ),
            TextButton(
              onPressed: () => context.push(AppRoutes.authorLogin),
              child: const Text('Login as author and publish news'),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('New here?'),
                TextButton(
                  onPressed: () => context.push(AppRoutes.signUp),
                  child: const Text('Create account'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
