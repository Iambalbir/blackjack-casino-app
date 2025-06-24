import 'package:app/core/utils/dialogs/remove_user_dialog.dart';

import '../../../../export_file.dart';

class WaitingRoomScreen extends StatefulWidget {
  final Map<String, dynamic> mapData;

  const WaitingRoomScreen({super.key, required this.mapData});

  @override
  State<WaitingRoomScreen> createState() => _WaitingRoomScreenState();
}

class _WaitingRoomScreenState extends State<WaitingRoomScreen> {
  late final WaitingRoomBloc _bloc;

  @override
  void didChangeDependencies() {
    _bloc = context.read<WaitingRoomBloc>();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<WaitingRoomBloc>();
    final roomCode = widget.mapData['roomCode'];
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
                .collection(roomCollectionPath)
                .doc(roomCode)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              final data = snapshot.data!.data() as Map<String, dynamic>;
              final invitedUsers =
                  List<Map<String, dynamic>>.from(data[playersListing] ?? []);
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
                      "isGameActiveStatus":
                          widget.mapData['isGameActiveStatus'],
                      "type": data['type']
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
                            trailing: data['type'] == 'public'
                                ? SizedBox()
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(statusIcon, color: iconColor),
                                      status == "accepted"
                                          ? SizedBox()
                                          : InkWell(
                                              onTap: () async {
                                                final shouldRemove =
                                                    await showRemoveUserDialog(
                                                        context,
                                                        user['nickname'] ?? '');
                                                if (shouldRemove == true) {
                                                  if (invitedUsers.length > 1) {
                                                    context
                                                        .read<WaitingRoomBloc>()
                                                        .add(RemoveUserEvent(
                                                            user['uid']));

                                                    showToast(
                                                        '${user['nickname']} has been removed from the waiting room.');
                                                  } else {
                                                    showToast(
                                                        "You are not allowed to perform this action.At least one player is required");
                                                  }
                                                }
                                              },
                                              child: Container(
                                                  margin: EdgeInsets.only(
                                                      left: margin_3),
                                                  padding:
                                                      EdgeInsets.all(margin_1),
                                                  decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      shape: BoxShape.circle),
                                                  child: Icon(Icons.close,
                                                      color: Colors.white)),
                                            ),
                                    ],
                                  ),
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
                                    .collection(roomCollectionPath)
                                    .doc(roomCode);
                                final roomSnapshot = await roomRef.get();
                                final roomData = roomSnapshot.data();

                                if (roomData != null) {
                                  // Step 1: Retrieve the host's bet amount
                                  final hostBetAmount =
                                      roomData['entryFee'] ?? 0;

                                  if (int.parse(bankAmount.value.toString()) <
                                      int.parse(hostBetAmount.toString())) {
                                    showToast(
                                        'Host has insufficient balance to start the game');
                                    return;
                                  }
                                  await firebaseRepository.updateUserCoins(
                                      userId: host['uid'],
                                      amount: hostBetAmount);

                                  await roomRef.update({
                                    'host': {
                                      'uid': host['uid'],
                                      'nickname': host['nickname'],
                                      'email': host['email'],
                                      'betAmount': hostBetAmount,
                                    },
                                  });

                                  // Step 5: Update the room status to active
                                  await roomRef.update({
                                    'status': 'active',
                                    'currentTurn': host['uid'],
                                    'turnStartTime':
                                        DateTime.now().millisecondsSinceEpoch,
                                    'turnId': 1,
                                  });

                                  final invitationsRef = FirebaseFirestore
                                      .instance
                                      .collection('invitations');
                                  final batch =
                                      FirebaseFirestore.instance.batch();
                                  final querySnapshot = await invitationsRef
                                      .where('roomCode', isEqualTo: roomCode)
                                      .get();
                                  for (final doc in querySnapshot.docs) {
                                    batch.delete(doc.reference);
                                  }

                                  await batch.commit();
                                }
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
