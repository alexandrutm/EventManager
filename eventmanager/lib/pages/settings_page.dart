import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

import '../components/icon_widget.dart';
import '../providers/auth_methods.dart';
import 'account_settings_page.dart';
import 'login_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
        alignment: AlignmentDirectional.topCenter,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            child: Container(
              width: 60,
              height: 7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
            ),
          ),
          Column(
            children: [
              SettingsGroup(
                title: 'General',
                children: <Widget>[
                  const AccountSettings(),
                  buildLogout(context),
                ],
              ),
              SettingsGroup(
                title: 'FEEDBACK',
                children: <Widget>[
                  const SizedBox(
                    height: 8,
                  ),
                  buildSendFeedback(context),
                  buildReportBug(context),
                ],
              ),
            ],
          ),
        ]);
  }
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
        Navigator.of(aContext).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      },
    );

Widget buildReportBug(BuildContext context) => SimpleSettingsTile(
      title: 'Report A Bug',
      subtitle: '',
      leading: IconWidget(icon: Icons.bug_report, color: Colors.blue),
      onTap: () {},
    );

Widget buildSendFeedback(BuildContext context) => SimpleSettingsTile(
      title: 'Send Feedback',
      subtitle: '',
      leading: IconWidget(icon: Icons.thumb_up, color: Colors.blue),
      onTap: () {},
    );
