import 'package:app/core/utils/dialogs/entry_fee_confirmation_dialog.dart';
import '../../../../export_file.dart';

class InvitationScreen extends StatefulWidget {
  @override
  State<InvitationScreen> createState() => _InvitationScreenState();
}

class _InvitationScreenState extends State<InvitationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<InvitationBloc>();
    bloc.add(LoadInvitationsEvent());

    return BlocConsumer<InvitationBloc, InvitationState>(
      listener: (context, state) async {},
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
            bottom: TabBar(
              controller: _tabController,
              onTap: (index) {
                if (index == 1) {
                  bloc.add(LoadInvitationsEvent(isAcceptedInvites: true));
                } else {
                  bloc.add(LoadInvitationsEvent(isAcceptedInvites: false));
                }
              },
              tabs: [
                Tab(text: 'Pending Invites'),
                Tab(text: 'Accepted Invites'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              // Pending Invites Tab
              invitations.isEmpty
                  ? Center(
                      child: TextView(
                        text: 'No pending invitations at the moment.',
                        textStyle: textStyleBodyMedium(context),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: invitations.length,
                      itemBuilder: (context, index) {
                        final invite = invitations[index];
                        return _buildInviteCard(invite, context);
                      },
                    ),

              // Accepted Invites Tab
              invitations.isEmpty
                  ? Center(
                      child: TextView(
                        text: 'No accepted invitations at the moment.',
                        textStyle: textStyleBodyMedium(context),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: invitations.length,
                      itemBuilder: (context, index) {
                        final invite = invitations[index];
                        return _buildAcceptedInviteCard(invite, context);
                      },
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInviteCard(Map<String, dynamic> invite, BuildContext context) {
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
              child: Icon(Icons.person, color: Colors.deepPurple),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextView(
                    text: '${invite['from']['nickname']} invited you',
                    textStyle: textStyleBodyMedium(context),
                  ),
                  const SizedBox(height: 4),
                  TextView(
                    text: 'Game: ${invite['game']}',
                    textStyle: textStyleBodySmall(context),
                  ),
                  const SizedBox(height: 2),
                  TextView(
                    text: 'Time: ${formatTimestamp(invite['time'])}',
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
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return EntryFeeConfirmationDialog(
                          entryFee: int.parse(invite['entryFee'].toString()),
                          onCancel: () {
                            Navigator.of(context).pop(); // dismiss dialog
                          },
                          onConfirm: () {
                            Navigator.of(context).pop();
                            context.read<InvitationBloc>().add(
                                  AcceptInvitationEvent(invite, context),
                                );
                          },
                        );
                      },
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
  }

  Widget _buildAcceptedInviteCard(
      Map<String, dynamic> invite, BuildContext context) {
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
              child: Icon(Icons.person, color: Colors.deepPurple),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextView(
                    text: '${invite['from']['nickname']} invited you',
                    textStyle: textStyleBodyMedium(context),
                  ),
                  const SizedBox(height: 4),
                  TextView(
                    text: 'Game: ${invite['game']}',
                    textStyle: textStyleBodySmall(context),
                  ),
                  const SizedBox(height: 2),
                  TextView(
                    text: 'Time: ${formatTimestamp(invite['time'])}',
                    textStyle: textStyleBodySmall(context),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
                onTap: () {
                  if (invite['status'] == 'active') {
                    Navigator.pushReplacementNamed(
                        context, RouteName.multiPlayerBlackJackScreenRoute,
                        arguments: {"roomData": invite['status']});
                  } else {
                    Navigator.pushReplacementNamed(
                        context, RouteName.waitingRoomScreenRoute,
                        arguments: {"roomCode": invite['roomCode']});
                  }
                },
                child: Icon(Icons.keyboard_arrow_right))
          ],
        ),
      ),
    );
  }
}
