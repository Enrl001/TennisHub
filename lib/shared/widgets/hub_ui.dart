import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Stitch / Coach Hub shared UI primitives.
class HubBrandAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HubBrandAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = false,
    this.toolbarHeight = 56,
  });

  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final double toolbarHeight;

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: HubStyle.pageBg,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: centerTitle,
      leading: leading,
      title: Text(title, style: HubStyle.brandTitle),
      iconTheme: const IconThemeData(color: HubStyle.hubOlive),
      actions: actions,
    );
  }
}

class HubScreen extends StatelessWidget {
  const HubScreen({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
  });

  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HubStyle.pageBg,
      appBar: appBar,
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}

class HubCard extends StatelessWidget {
  const HubCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.onTap,
    this.color,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? HubStyle.cardBg,
        borderRadius: BorderRadius.circular(HubStyle.radiusSm),
        border: Border.all(color: HubStyle.cardBorder),
      ),
      child: child,
    );
    if (onTap == null) return card;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(HubStyle.radiusSm),
        child: card,
      ),
    );
  }
}

class HubSectionLabel extends StatelessWidget {
  const HubSectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text.toUpperCase(), style: HubStyle.sectionLabel);
  }
}

class HubPrimaryButton extends StatelessWidget {
  const HubPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.icon,
    this.minimumHeight = 48,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;
  final double minimumHeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: minimumHeight,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: HubStyle.hubOlive,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(HubStyle.radiusSm),
          ),
        ),
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : icon == null
            ? Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class HubOutlinedButton extends StatelessWidget {
  const HubOutlinedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.minimumHeight = 48,
  });

  final String label;
  final VoidCallback onPressed;
  final double minimumHeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: minimumHeight,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: HubStyle.hubOlive,
          side: const BorderSide(color: HubStyle.hubOlive),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(HubStyle.radiusSm),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
    );
  }
}

class HubDarkPanel extends StatelessWidget {
  const HubDarkPanel({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: HubStyle.darkPanel,
        borderRadius: BorderRadius.circular(HubStyle.radiusSm),
      ),
      child: child,
    );
  }
}

class HubAccentPanel extends StatelessWidget {
  const HubAccentPanel({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: HubStyle.accentLime,
        borderRadius: BorderRadius.circular(HubStyle.radiusSm),
      ),
      child: child,
    );
  }
}
