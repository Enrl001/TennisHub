import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/validators.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/service_chip.dart';

class ServiceForm extends StatelessWidget {
  const ServiceForm({
    super.key,
    required this.selectedType,
    required this.locale,
    required this.onTypeChanged,
    required this.titleCtrl,
    required this.descCtrl,
    required this.durationCtrl,
    required this.priceCtrl,
    required this.currencyCtrl,
    required this.maxCtrl,
    required this.videoPlatformCtrl,
    required this.videoUrlCtrl,
    required this.locationCtrl,
    required this.equipmentCtrl,
    required this.onSubmit,
    required this.loading,
  });

  final String selectedType;
  final String locale;
  final ValueChanged<String> onTypeChanged;
  final TextEditingController titleCtrl;
  final TextEditingController descCtrl;
  final TextEditingController durationCtrl;
  final TextEditingController priceCtrl;
  final TextEditingController currencyCtrl;
  final TextEditingController maxCtrl;
  final TextEditingController videoPlatformCtrl;
  final TextEditingController videoUrlCtrl;
  final TextEditingController locationCtrl;
  final TextEditingController equipmentCtrl;
  final VoidCallback? onSubmit;
  final bool loading;

  static const _types = [
    'private_lesson',
    'group_lesson',
    'community_event',
    'virtual_session',
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isMn = locale == 'mn';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.serviceType,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _types.map((t) {
            final selected = selectedType == t;
            final color = AppColors.serviceColor(t);
            return GestureDetector(
              onTap: () => onTypeChanged(t),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: selected ? color.withOpacity(0.15) : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: selected ? color : AppColors.cardBorder,
                    width: selected ? 2 : 1,
                  ),
                ),
                child: ServiceChip(type: t, small: true),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: titleCtrl,
          decoration: InputDecoration(
            labelText: isMn ? l10n.titleMn : l10n.titleEn,
          ),
          validator: Validators.required,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: descCtrl,
          decoration: InputDecoration(
            labelText: isMn ? l10n.descriptionMn : l10n.descriptionEn,
            alignLabelWithHint: true,
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: durationCtrl,
                decoration: InputDecoration(labelText: l10n.durationMinutes),
                keyboardType: TextInputType.number,
                validator: Validators.positiveNumber,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: maxCtrl,
                decoration: InputDecoration(labelText: l10n.maxParticipants),
                keyboardType: TextInputType.number,
                validator: Validators.positiveNumber,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: locationCtrl,
          decoration: InputDecoration(
            labelText: l10n.sessionLocation,
            hintText: isMn ? 'Жишээ: Стадион А, 2-р корт' : 'e.g. Stadium A, Court 2',
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: equipmentCtrl,
          decoration: InputDecoration(
            labelText: l10n.requiredEquipment,
            hintText: isMn
                ? 'Жишээ: Теннисийн хар тамхи, ус'
                : 'e.g. Tennis racket, water bottle',
            alignLabelWithHint: true,
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: priceCtrl,
                decoration: InputDecoration(labelText: l10n.priceAmount),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: Validators.positiveNumber,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: currencyCtrl,
                decoration: InputDecoration(labelText: l10n.currency),
              ),
            ),
          ],
        ),
        if (selectedType == 'virtual_session') ...[
          const SizedBox(height: 12),
          TextFormField(
            controller: videoPlatformCtrl,
            decoration: InputDecoration(
              labelText: l10n.videoPlatform,
              hintText: 'Zoom, Google Meet...',
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: videoUrlCtrl,
            decoration: InputDecoration(labelText: l10n.videoUrl),
            keyboardType: TextInputType.url,
          ),
        ],
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: onSubmit,
          child: loading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(l10n.addService),
        ),
      ],
    );
  }
}
