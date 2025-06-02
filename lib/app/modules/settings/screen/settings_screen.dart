import 'package:app/core/utils/dialogs/set_nickname_dialogue.dart';

import '../../../../export_file.dart';

class SettingsScreen extends StatelessWidget {
  final bool isGuest;

  const SettingsScreen({Key? key, this.isGuest = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SettingsBloc>();
    bloc.add(LoadSettings());

    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ListTile(
                  title: Text('Reset Nickname'),
                  subtitle: TextView(
                    text: currentUserModel.nickname ?? 'No nickname set',
                    textStyle: textStyleBodyMedium(context),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      showNicknameDialog(context, (nickname) {
                        apiRepository.updateUserNickname(nickname);
                      });
                    },
                  ),
                ),
                Divider(),
                SwitchListTile(
                  title: Text('Sound'),
                  value: state.soundOn,
                  onChanged: (_) => bloc.add(ToggleSound()),
                  secondary:
                      Icon(state.soundOn ? Icons.volume_up : Icons.volume_off),
                ),
                Divider(),
                SwitchListTile(
                  title: Text('Dark Theme'),
                  value: state.darkTheme,
                  onChanged: (_) => bloc.add(ToggleTheme()),
                  secondary: Icon(Icons.brightness_6),
                ),
                Spacer(),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: TextView(
                    text: "Logout",
                    textAlign: TextAlign.start,
                    textStyle: textStyleBodyMedium(context),
                  ),
                  onTap: () async {
                    // Check if the user is a guest
                    final isGuest =
                        await isGuestUser(); // Assuming you have this method available

                    if (isGuest) {
                      showDialog(
                        context: context,
                        builder: (context) => LogoutDialog(
                          onLogout: () async {
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.remove("guest_id");
                            await prefs.setBool(
                                "is_guest", false); // Set is_guest to false

                            Navigator.of(context).pop(); // Close the dialog
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                RouteName.streamUserStateScreenRoute,
                                (_) => false);
                          },
                          onCancel: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                        ),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => LogoutDialog(
                          onLogout: () async {
                            await auth
                                .signOut(); // Sign out the authenticated user
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.remove("guest_id");
                            await prefs.setBool(
                                "is_guest", false); // Set is_guest to false

                            Navigator.of(context).pop(); // Close the dialog
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                RouteName.streamUserStateScreenRoute,
                                (_) => false);
                          },
                          onCancel: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                        ),
                      );
                    }
                  },
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  visualDensity: VisualDensity.compact,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
