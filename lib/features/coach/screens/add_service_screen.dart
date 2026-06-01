import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/validators.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/coach_provider.dart';
import '../widgets/service_form.dart';

class AddServiceScreen extends ConsumerStatefulWidget {
  const AddServiceScreen({super.key});

  @override
  ConsumerState<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends ConsumerState<AddServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  String _type = 'private_lesson';
  final _titleCtrl = TextEditingController();
  final _titleMnCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _descMnCtrl = TextEditingController();
  final _durationCtrl = TextEditingController(text: '60');
  final _priceCtrl = TextEditingController();
  final _currencyCtrl = TextEditingController(text: 'USD');
  final _maxCtrl = TextEditingController(text: '1');
  final _videoPlatformCtrl = TextEditingController();
  final _videoUrlCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _titleMnCtrl.dispose();
    _descCtrl.dispose();
    _descMnCtrl.dispose();
    _durationCtrl.dispose();
    _priceCtrl.dispose();
    _currencyCtrl.dispose();
    _maxCtrl.dispose();
    _videoPlatformCtrl.dispose();
    _videoUrlCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final profile = ref.read(currentProfileProvider);
      if (profile == null) return;
      final coachId = await ref
          .read(coachProfileProvider.notifier)
          .ensureCoachRecord(profile.id);

      await ref.read(coachProfileProvider.notifier).addService({
        'coach_id': coachId,
        'type': _type,
        'title': _titleCtrl.text.trim(),
        'title_mn': _titleMnCtrl.text.trim(),
        'description': _descCtrl.text.trim(),
        'description_mn': _descMnCtrl.text.trim(),
        'duration_minutes': int.tryParse(_durationCtrl.text) ?? 60,
        'price_amount': double.tryParse(_priceCtrl.text) ?? 0,
        'currency': _currencyCtrl.text.trim(),
        'max_participants': int.tryParse(_maxCtrl.text) ?? 1,
        if (_type == 'virtual_session') ...<String, dynamic>{
          'video_platform': _videoPlatformCtrl.text.trim(),
          'video_url': _videoUrlCtrl.text.trim(),
        },
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Service added!')));
      context.pop();
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
      appBar: AppBar(title: Text(l10n.addService)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ServiceForm(
              selectedType: _type,
              onTypeChanged: (t) => setState(() => _type = t),
              titleCtrl: _titleCtrl,
              titleMnCtrl: _titleMnCtrl,
              descCtrl: _descCtrl,
              descMnCtrl: _descMnCtrl,
              durationCtrl: _durationCtrl,
              priceCtrl: _priceCtrl,
              currencyCtrl: _currencyCtrl,
              maxCtrl: _maxCtrl,
              videoPlatformCtrl: _videoPlatformCtrl,
              videoUrlCtrl: _videoUrlCtrl,
              onSubmit: _loading ? null : _save,
              loading: _loading,
            ),
          ),
        ),
      ),
    );
  }
}
