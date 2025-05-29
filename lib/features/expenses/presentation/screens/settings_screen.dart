import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:masraf_app/shared/providers/settings_provider.dart';
import 'package:masraf_app/features/expenses/presentation/screens/profile_settings_screen.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar')),
      body: ListView(
        children: [
          ExpansionTile(
            title: const Text('Görünüm Ayarları'),
            children: [
              RadioListTile<ThemeMode>(
                title: const Text('Açık'),
                value: ThemeMode.light,
                groupValue: settings.themeMode,
                onChanged: (value) {
                  if (value != null) notifier.updateThemeMode(value);
                },
              ),
              RadioListTile<ThemeMode>(
                title: const Text('Koyu'),
                value: ThemeMode.dark,
                groupValue: settings.themeMode,
                onChanged: (value) {
                  if (value != null) notifier.updateThemeMode(value);
                },
              ),
              RadioListTile<ThemeMode>(
                title: const Text('Sistem'),
                value: ThemeMode.system,
                groupValue: settings.themeMode,
                onChanged: (value) {
                  if (value != null) notifier.updateThemeMode(value);
                },
              ),
              ListTile(
                title: const Text('Yazı Tipi Boyutu'),
                trailing: DropdownButton<AppFontSize>(
                  value: settings.fontSize,
                  items: const [
                    DropdownMenuItem(value: AppFontSize.small, child: Text('Küçük')),
                    DropdownMenuItem(value: AppFontSize.medium, child: Text('Orta')),
                    DropdownMenuItem(value: AppFontSize.large, child: Text('Büyük')),
                  ],
                  onChanged: (value) {
                    if (value != null) notifier.updateFontSize(value);
                  },
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('Dil Ayarları'),
            children: [
              ListTile(
                title: const Text('Uygulama Dili'),
                trailing: DropdownButton<String>(
                  value: settings.locale.languageCode,
                  items: const [
                    DropdownMenuItem(value: 'tr', child: Text('Türkçe')),
                    DropdownMenuItem(value: 'en', child: Text('English')),
                  ],
                  onChanged: (value) {
                    if (value != null) notifier.updateLanguage(value);
                  },
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('Bildirimler'),
            children: [
              SwitchListTile(
                title: const Text('Push Bildirimleri'),
                value: settings.pushNotifications,
                onChanged: (value) => notifier.updatePushNotifications(value),
              ),
              SwitchListTile(
                title: const Text('Haftalık Özet Raporu'),
                value: settings.weeklySummary,
                onChanged: (value) => notifier.updateWeeklySummary(value),
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('Profil Ayarları'),
            children: [
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profil Bilgileri'),
                onTap: () => context.go('/profile-settings'),
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('Uygulama Bilgileri'),
            children: [
              ListTile(
                title: const Text('Hakkında'),
                subtitle: const Text('v1.0.0'),
              ),
              ListTile(
                title: const Text('Kullanım Şartları & Gizlilik Politikası'),
                onTap: () {
                  // TODO: Open terms & privacy
                },
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Ana Menüye Dön'),
                onTap: () => context.go('/'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}