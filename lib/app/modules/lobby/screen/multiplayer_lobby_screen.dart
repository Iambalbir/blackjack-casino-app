import 'package:app/app/modules/lobby/screen/room_create_screen.dart';
import 'package:app/core/utils/values/textStyles.dart';
import 'package:app/core/utils/widgets/text_view.dart';
import 'package:flutter/material.dart';

class MultiplayerLobbyScreen extends StatefulWidget {
  const MultiplayerLobbyScreen({Key? key}) : super(key: key);

  @override
  _MultiplayerLobbyScreenState createState() => _MultiplayerLobbyScreenState();
}

class _MultiplayerLobbyScreenState extends State<MultiplayerLobbyScreen> {
  final TextEditingController _roomCodeController = TextEditingController();

  @override
  void dispose() {
    _roomCodeController.dispose();
    super.dispose();
  }

  void _joinPublicMatch() {
    // TODO: Navigate to matchmaking or auto-join logic
    print("Joining public match...");
  }

  void _createPrivateRoom() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => CreatePrivateRoomView()));
    print("Creating private room...");
  }

  void _enterRoomCode() {
    final code = _roomCodeController.text.trim();
    if (code.isNotEmpty) {
      // TODO: Attempt to join room with the code
      print("Joining room with code: $code");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a room code")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextView(
          text: "Multiplayer Lobby",
          textStyle: textStyleHeadingMedium(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.public),
              label: Text("Join Public Match"),
              onPressed: _joinPublicMatch,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.green,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.lock),
              label: Text("Create Private Room"),
              onPressed: _createPrivateRoom,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.blue,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _roomCodeController,
              decoration: InputDecoration(
                labelText: "Enter Room Code",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton.icon(
              icon: Icon(Icons.vpn_key),
              label: Text("Join Room"),
              onPressed: _enterRoomCode,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
