import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/validators.dart';
import '../../../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _pwCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  String _selectedRole = 'customer';

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _pwCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context);
    setState(() => _loading = true);
    try {
      final needsConfirmation = await ref.read(authProvider.notifier).signUp(
            email: _emailCtrl.text.trim(),
            password: _pwCtrl.text,
            role: _selectedRole,
            fullName: _nameCtrl.text.trim(),
          );
      if (!mounted) return;
      if (needsConfirmation) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(l10n.checkEmailConfirm),
          duration: const Duration(seconds: 6),
        ));
      } else {
        if (_selectedRole == 'coach') {
          context.go('/edit-coach-profile');
        } else {
          context.go('/home');
        }
      }
    } catch (e, st) {
      debugPrint('REGISTER ERROR: $e\n$st');
      if (!mounted) return;
      String message = e.toString();
      if (message.contains('already registered') || message.contains('already been registered')) {
        message = l10n.emailAlreadyRegistered;
      } else if (message.contains('Password should be')) {
        message = l10n.passwordTooShort;
      } else if (message.contains('Unable to validate email')) {
        message = l10n.invalidEmail;
      }
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: AppColors.statusCancelled));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: HubStyle.pageBg,
      appBar: AppBar(title: Text(l10n.register)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.signUp,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text(l10n.createAccountSubtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey)),
                const SizedBox(height: 32),

                // Full name
                TextFormField(
                  controller: _nameCtrl,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: l10n.fullName,
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? l10n.enterYourName : null,
                ),
                const SizedBox(height: 16),

                // Email
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: l10n.email,
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                  validator: Validators.email,
                ),
                const SizedBox(height: 16),

                // Password
                TextFormField(
                  controller: _pwCtrl,
                  obscureText: _obscure,
                  decoration: InputDecoration(
                    labelText: l10n.password,
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  validator: Validators.password,
                ),
                const SizedBox(height: 28),

                // Role selection
                Text(l10n.roleSelectTitle,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(
                    child: _RoleOption(
                      icon: Icons.person,
                      label: l10n.roleCustomer,
                      selected: _selectedRole == 'customer',
                      onTap: () => setState(() => _selectedRole = 'customer'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _RoleOption(
                      icon: Icons.sports_tennis,
                      label: l10n.roleCoach,
                      selected: _selectedRole == 'coach',
                      onTap: () => setState(() => _selectedRole = 'coach'),
                    ),
                  ),
                ]),
                const SizedBox(height: 32),

                // Submit
                ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  child: _loading
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text(l10n.signUp),
                ),
                const SizedBox(height: 24),
                Row(children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(l10n.orDivider, style: const TextStyle(color: Colors.grey)),
                  ),
                  const Expanded(child: Divider()),
                ]),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () => ref.read(authProvider.notifier).signInWithGoogle(),
                  icon: const Icon(Icons.g_mobiledata_rounded, size: 22),
                  label: Text(l10n.continueWithGoogle),
                ),
                const SizedBox(height: 24),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(l10n.alreadyAccount),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: Text(l10n.signIn),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleOption extends StatelessWidget {
  const _RoleOption({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.cardBorder,
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: selected ? AppColors.primary : Colors.grey, size: 28),
            const SizedBox(height: 6),
            Text(label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: selected ? AppColors.primary : Colors.grey,
                )),
          ],
        ),
      ),
    );
  }
}
