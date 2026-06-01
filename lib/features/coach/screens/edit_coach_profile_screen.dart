import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/validators.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/coach_provider.dart';

class EditCoachProfileScreen extends ConsumerStatefulWidget {
  const EditCoachProfileScreen({super.key});

  @override
  ConsumerState<EditCoachProfileScreen> createState() =>
      _EditCoachProfileScreenState();
}

class _EditCoachProfileScreenState
    extends ConsumerState<EditCoachProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();
  final _bioMnCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _yearsCtrl = TextEditingController();
  final _certCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _bioCtrl.dispose();
    _bioMnCtrl.dispose();
    _locationCtrl.dispose();
    _yearsCtrl.dispose();
    _certCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final profile = ref.read(currentProfileProvider);
      if (profile == null) return;

      // Update profile name
      await ref.read(authProvider.notifier).updateProfile({
        'full_name': _nameCtrl.text.trim(),
      });

      // Ensure coach record exists
      final coachId = await ref
          .read(coachProfileProvider.notifier)
          .ensureCoachRecord(profile.id);

      // Update coach record
      final certs = _certCtrl.text.isEmpty
          ? []
          : _certCtrl.text.split(',').map((e) => e.trim()).toList();
      await ref.read(coachProfileProvider.notifier).updateCoachProfile(
        coachId,
        {
          'bio': _bioCtrl.text.trim(),
          'bio_mn': _bioMnCtrl.text.trim(),
          'location': _locationCtrl.text.trim(),
          if (_yearsCtrl.text.isNotEmpty)
            'years_experience': int.tryParse(_yearsCtrl.text) ?? 0,
          'certifications': certs,
        },
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved!')),
      );
      context.go('/coach-dashboard');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: AppColors.statusCancelled,
      ));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.editProfile)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameCtrl,
                  decoration: InputDecoration(
                    labelText: l10n.fullName,
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                  validator: Validators.required,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _bioCtrl,
                  decoration: InputDecoration(
                    labelText: l10n.bio,
                    alignLabelWithHint: true,
                  ),
                  maxLines: 4,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _bioMnCtrl,
                  decoration: InputDecoration(
                    labelText: l10n.bioMn,
                    alignLabelWithHint: true,
                  ),
                  maxLines: 4,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _locationCtrl,
                  decoration: InputDecoration(
                    labelText: l10n.courtAddress,
                    prefixIcon: const Icon(Icons.location_on_outlined),
                  ),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _yearsCtrl,
                  decoration: InputDecoration(
                    labelText: l10n.yearsExperience,
                    prefixIcon: const Icon(Icons.workspace_premium_outlined),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _certCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Certifications (comma-separated)',
                    hintText: 'e.g. ITF Level 1, PTR Professional',
                    prefixIcon: Icon(Icons.verified_outlined),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _loading ? null : _save,
                  child: _loading
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text(l10n.saveChanges),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
