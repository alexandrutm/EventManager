import 'package:eventmanager/components/icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

class AccountSettings extends StatelessWidget {
  const AccountSettings({super.key});
  static const keyLanguage = 'key-language';
  static const keyPassword = 'key-password';

  @override
  Widget build(BuildContext context) => SimpleSettingsTile(
        title: 'Account Settings',
        subtitle: 'Privacy, Security, Language',
        leading: const IconWidget(icon: Icons.person, color: Colors.grey),
        child: SettingsScreen(title: 'Account Settings', children: <Widget>[
          buildLanguage(),
          buildPassword(),
        ]),
      );

  Widget buildLanguage() => DropDownSettingsTile(
        title: 'Language',
        settingKey: keyLanguage,
        selected: 1,
        values: <int, String>{
          1: 'English',
          2: 'Spanish',
        },
        onChange: (language) {},
      );

  Widget buildPassword() => TextInputSettingsTile(
        title: 'Change Password',
        settingKey: keyPassword,
        obscureText: true,
        validator: (password) => password != null && password.length < 6
            ? null
            : 'You password must be at least 6 characters',
      );
}
