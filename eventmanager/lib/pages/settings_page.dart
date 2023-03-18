import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

import '../components/icon_widget.dart';
import '../providers/auth_methods.dart';
import '../utils/colors.dart';
import 'login_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: backgroundGradientColor,
        ),
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            SettingsGroup(
              title: 'General',
              children: <Widget>[
                buildLogout(context),
              ],
            ),
            SettingsGroup(
              title: 'General',
              titleTextStyle: TextStyle(color: Colors.black),
              children: <Widget>[
                buildLogout(context),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildLogout(BuildContext aContext) => SimpleSettingsTile(
      title: 'Logout',
      titleTextStyle: TextStyle(color: Colors.black),
      leading: const IconWidget(
        icon: Icons.logout,
        color: Colors.blueAccent,
      ),
      onTap: () async {
        await AuthMethods().signOut();
        Navigator.of(aContext).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      },
    );
