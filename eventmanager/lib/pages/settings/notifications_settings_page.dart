import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

import '../../components/icon_widget.dart';

class NotificationSettings extends StatelessWidget {
  const NotificationSettings({super.key});
  static const keyMuteAll = 'key-mute-all';

  @override
  Widget build(BuildContext context) => SimpleSettingsTile(
        title: 'Notifications',
        subtitle: '',
        leading: const IconWidget(icon: Icons.notifications, color: Colors.red),
        child: SettingsScreen(title: 'Notifications', children: <Widget>[
          buildAllNotifications(),
        ]),
      );

  Widget buildAllNotifications() => SwitchSettingsTile(
        title: 'Mute all notifications',
        settingKey: keyMuteAll,
        leading:
            const IconWidget(icon: Icons.notifications_off, color: Colors.blue),
        onChange: (keyMuteAll) {},
      );
}
