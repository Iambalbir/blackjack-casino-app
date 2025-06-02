import '../../../../export_file.dart';

class InvitationScreen extends StatefulWidget {
  @override
  State<InvitationScreen> createState() => _InvitationScreenState();
}

class _InvitationScreenState extends State<InvitationScreen> {
  bool _hasNavigated = false;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<InvitationBloc>();
    bloc.add(LoadInvitationsEvent());

    return BlocConsumer<InvitationBloc, InvitationState>(
      listener: (context, state) async {
        final room = state.navigateToRoom;
        if (room != null && !_hasNavigated) {
          _hasNavigated = true;
          final roomCode = room['roomCode'];
          final status = room['status'];
          if (status == 'waiting') {
            Navigator.pushNamed(context, RouteName.waitingRoomScreenRoute,
                arguments: {"roomCode": roomCode});
          } else if (status == 'active') {
            Navigator.pushNamed(
                context, RouteName.multiPlayerBlackJackScreenRoute,
                arguments: {"roomData": roomCode});
          }

          ///may be required for future use
        }
      },
      builder: (context, state) {
        if (state.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        final invitations = state.invitations;

        return Scaffold(
          appBar: AppBar(
            title: TextView(
              text: 'Your Invitations',
              textStyle: textStyleHeadingMedium(context),
            ),
          ),
          body: invitations.isEmpty
              ? Center(
                  child: TextView(
                    text: 'No invitations at the moment.',
                    textStyle: textStyleBodyMedium(context),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: invitations.length,
                  itemBuilder: (context, index) {
                    final invite = invitations[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.purple.shade100,
                              child:
                                  Icon(Icons.person, color: Colors.deepPurple),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextView(
                                    text:
                                        '${invite['from']['nickname']} invited you',
                                    textStyle: textStyleBodyMedium(context),
                                  ),
                                  const SizedBox(height: 4),
                                  TextView(
                                    text: 'Game: ${invite['game']}',
                                    textStyle: textStyleBodySmall(context),
                                  ),
                                  const SizedBox(height: 2),
                                  TextView(
                                    text:
                                        'Time: ${formatTimestamp(invite['time'])}',
                                    textStyle: textStyleBodySmall(context),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Wrap(
                              spacing: 4,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.check, color: Colors.green),
                                  onPressed: () {
                                    context.read<InvitationBloc>().add(
                                          AcceptInvitationEvent(invite),
                                        );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.close, color: Colors.red),
                                  onPressed: () {
                                    context.read<InvitationBloc>().add(
                                          DeclineInvitationEvent(invite),
                                        );
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
