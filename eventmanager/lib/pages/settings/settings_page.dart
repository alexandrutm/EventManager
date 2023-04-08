import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

import '../../components/icon_widget.dart';
import '../../providers/auth_methods.dart';
import '../login_page.dart';
import 'account_settings_page.dart';
import 'notifications_settings_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  static const keyDarkMode = 'key-dark-mode';

  @override
  Widget build(BuildContext context) {
    return Stack(
        alignment: AlignmentDirectional.topCenter,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 8,
            child: Container(
              width: 60,
              height: 7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          Column(
            children: [
              SettingsGroup(
                title: 'General',
                children: <Widget>[
                  const AccountSettings(),
                  const NotificationSettings(),
                  buildLogout(context),
                ],
              ),
              SettingsGroup(
                title: 'Feedback',
                children: <Widget>[
                  buildSendFeedback(context),
                  buildReportBug(context),
                ],
              ),
            ],
          ),
        ]);
  }

  // Widget buildDarkMode() => SwitchSettingsTile(
  //       title: 'Dark Mode',
  //       settingKey: keyDarkMode,
  //       leading: const IconWidget(icon: Icons.dark_mode, color: Colors.blue),
  //       onChange: (isDarkMode) {},
  //     );

  Widget buildLogout(BuildContext aContext) => SimpleSettingsTile(
        title: 'Logout',
        leading: const IconWidget(
          icon: Icons.logout,
          color: Colors.blueAccent,
        ),
        onTap: () async {
          await AuthMethods().signOut();
          if (aContext.mounted) {
            Navigator.of(aContext).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          }
        },
      );

  Widget buildReportBug(BuildContext context) => SimpleSettingsTile(
        title: 'Report A Bug',
        subtitle: '',
        leading: const IconWidget(icon: Icons.bug_report, color: Colors.blue),
        onTap: () {},
      );

  Widget buildSendFeedback(BuildContext aContext) => SimpleSettingsTile(
        title: 'Send Feedback',
        subtitle: '',
        leading: const IconWidget(icon: Icons.thumb_up, color: Colors.blue),
        onTap: () {},
      );
}
