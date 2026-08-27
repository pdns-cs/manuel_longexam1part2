import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../providers/theme_provider.dart';
import '../services/user_service.dart';

/// User preferences + Sign Out.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const _kNotifications = 'pref_notifications';
  static const _kAutoplay = 'pref_autoplay';

  final UserService _userService = UserService();
  bool _notifications = true;
  bool _autoplay = false;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notifications = prefs.getBool(_kNotifications) ?? true;
      _autoplay = prefs.getBool(_kAutoplay) ?? false;
    });
  }

  Future<void> _setBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<void> _signOut() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kRadiusMd),
        ),
        title: const Text('Sign out?'),
        content: const Text('You will need to sign in again to use $kAppName.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: LOOP_DANGER),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    await _userService.signOut();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      backgroundColor: LOOP_BG,
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _section('Preferences'),
          _card([
            _switchTile(
              icon: Icons.dark_mode_outlined,
              title: 'Dark mode',
              subtitle: 'Switch between light and dark',
              value: themeProvider.isDarkMode,
              onChanged: themeProvider.toggleTheme,
            ),
            _divider(),
            _switchTile(
              icon: Icons.notifications_none_rounded,
              title: 'Notifications',
              subtitle: 'Push alerts for activity',
              value: _notifications,
              onChanged: (v) {
                setState(() => _notifications = v);
                _setBool(_kNotifications, v);
              },
            ),
            _divider(),
            _switchTile(
              icon: Icons.play_circle_outline,
              title: 'Autoplay videos',
              subtitle: 'Play media automatically in the feed',
              value: _autoplay,
              onChanged: (v) {
                setState(() => _autoplay = v);
                _setBool(_kAutoplay, v);
              },
            ),
          ]),
          const SizedBox(height: 24),
          _section('Account'),
          _card([
            ListTile(
              leading: Icon(Icons.logout_rounded, color: LOOP_DANGER),
              title: Text(
                'Sign out',
                style: TextStyle(
                  color: LOOP_DANGER,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: _signOut,
            ),
          ]),
          const SizedBox(height: 28),
          Center(
            child: Text(
              '$kAppName • v0.1.0',
              style: TextStyle(color: LOOP_MUTED, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(String text) => Padding(
    padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
    child: Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        letterSpacing: 1.2,
        fontWeight: FontWeight.w700,
        color: LOOP_MUTED,
      ),
    ),
  );

  Widget _card(List<Widget> children) => Container(
    decoration: BoxDecoration(
      color: LOOP_SURFACE,
      borderRadius: BorderRadius.circular(kRadiusMd),
      border: Border.all(color: LOOP_BORDER),
    ),
    clipBehavior: Clip.antiAlias,
    child: Column(children: children),
  );

  Widget _divider() => Divider(height: 1, color: LOOP_BORDER, indent: 56);

  Widget _switchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      secondary: Icon(icon, color: LOOP_MUTED),
      activeThumbColor: LOOP_TEAL,
      title: Text(
        title,
        style: TextStyle(color: LOOP_TEXT, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(subtitle, style: TextStyle(color: LOOP_MUTED)),
      value: value,
      onChanged: onChanged,
    );
  }
}
