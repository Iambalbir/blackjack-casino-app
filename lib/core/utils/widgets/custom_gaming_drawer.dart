import 'package:app/constants.dart';
import 'package:app/core/utils/widgets/dimens.dart';
import 'package:flutter/material.dart';

typedef DrawerOptionTapCallback = void Function(String option);

class CustomGamingDrawer extends StatelessWidget {
  final DrawerOptionTapCallback onOptionTap;

  const CustomGamingDrawer({Key? key, required this.onOptionTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(top: margin_80, bottom: margin_100, right: margin_10),
      child: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Optional header (you can customize it or remove)
            DrawerHeader(
              decoration: BoxDecoration(
                color: kBackground,
              ),
              child: Text(
                'Game Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.rule),
              title: Text('Rules'),
              onTap: () {
                Navigator.of(context).pop(); // Close the drawer
                onOptionTap('rules');
              },
            ),
            Divider(height: 1),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Leave the Lobby'),
              onTap: () {
                Navigator.of(context).pop(); // Close the drawer
                onOptionTap('leave');
              },
            ),
          ],
        ),
      ),
    );
  }
}
