import '../../../../export_file.dart';

class WaitingRoomScreen extends StatelessWidget {
  final Map<String, dynamic> mapData;

  const WaitingRoomScreen({super.key, required this.mapData});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<WaitingRoomBloc>();
    final roomCode = mapData['roomCode'];
    bloc.add(InitialWaitingRoomEvent(roomCode));

    return BlocConsumer<WaitingRoomBloc, WaitingRoomState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: TextView(
              text: 'Waiting Room',
              textStyle: textStyleHeadingMedium(context),
            ),
          ),
          body: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('rooms')
                .doc(roomCode)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              final data = snapshot.data!.data() as Map<String, dynamic>;
              final invitedUsers =
                  List<Map<String, dynamic>>.from(data['invitedUsers'] ?? []);
              final host = data['host'];
              final List<Map<String, dynamic>> playerList = [
                host,
                ...invitedUsers
              ];
              if (data['status'] == 'active') {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pushReplacementNamed(
                    context,
                    RouteName.multiPlayerBlackJackScreenRoute,
                    arguments: {
                      "roomCode": roomCode,
                      "players": playerList,
                      "isGameActiveStatus": mapData['isGameActiveStatus']
                    },
                  );
                });
                return SizedBox
                    .shrink(); // Hide waiting room UI during navigation
              }

              final allAccepted = invitedUsers.isNotEmpty &&
                  invitedUsers.every((user) => user['status'] == 'accepted');

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextView(
                      text: 'Room Code: $roomCode',
                      textStyle: textStyleBodyMedium(context),
                    ),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextView(
                      text: 'Host: ${host['nickname']}',
                      textStyle: textStyleBodyMedium(context),
                    ),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: invitedUsers.length,
                      itemBuilder: (context, index) {
                        final user = invitedUsers[index];
                        final status = user['status'] ?? 'pending';
                        IconData statusIcon;
                        Color iconColor;

                        switch (status) {
                          case 'accepted':
                            statusIcon = Icons.check_circle;
                            iconColor = Colors.green;
                            break;
                          case 'declined':
                            statusIcon = Icons.cancel;
                            iconColor = Colors.red;
                            break;
                          default:
                            statusIcon = Icons.hourglass_empty;
                            iconColor = Colors.grey;
                        }

                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.deepPurple.shade100,
                              child:
                                  Icon(Icons.person, color: Colors.deepPurple),
                            ),
                            title: TextView(
                              text: user['nickname'] ?? '',
                              textStyle: textStyleBodyMedium(context),
                            ),
                            subtitle: TextView(
                              text: user['email'] ?? '',
                              textStyle: textStyleBodySmall(context),
                            ),
                            trailing: Icon(statusIcon, color: iconColor),
                          ),
                        );
                      },
                    ),
                  ),
                  if ((data['status'] ?? '') == 'waiting' &&
                      currentUserModel.uid == host['uid'])
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  allAccepted ? Colors.green : Colors.grey,
                            ),
                            onPressed: () async {
                              if (allAccepted) {
                                final roomRef = FirebaseFirestore.instance
                                    .collection('rooms')
                                    .doc(roomCode);

                                await roomRef.update({
                                  'status': 'active',
                                  'currentTurn': host['uid'],
                                  'turnStartTime': FieldValue.serverTimestamp(),
                                  'turnId': 1,
                                });
                              }
                            },
                            child: TextView(
                              text: 'Start Game',
                              textStyle: textStyleBodyMedium(context).copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
