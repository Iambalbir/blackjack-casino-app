import 'package:app/export_file.dart';

class CreatePrivateRoomView extends StatefulWidget {
  @override
  _CreateRoomWithUserSelectionScreenState createState() =>
      _CreateRoomWithUserSelectionScreenState();
}

class _CreateRoomWithUserSelectionScreenState
    extends State<CreatePrivateRoomView> {
  @override
  void initState() {
    context.read<CreateRoomBloc>().add(InitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final roomBloc = context.read<CreateRoomBloc>();
    return BlocConsumer<CreateRoomBloc, RoomState>(
      listener: (context, state) {
        if (state.roomCode != '' && !state.isCreatingRoom) {
          Navigator.pushNamed(context, RouteName.waitingRoomScreenRoute,
              arguments: {"roomCode": state.roomCode});
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
              title: TextView(
            text: 'Create Private Room',
            textStyle: textStyleHeadingMedium(context),
          )),
          body: state.allUsers.isEmpty && state.isLoading == true
              ? Center(child: CircularProgressIndicator())
              : state.allUsers.length == 0
                  ? Center(
                      child: TextView(
                          text: "No Users found",
                          textStyle: textStyleBodyMedium(context)),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          TextView(
                            text: 'Select players to invite (max 5)',
                            textStyle: textStyleBodyMedium(context)
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 10),
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'Search nicknames...',
                              prefixIcon: Icon(Icons.search),
                              filled: true,
                              fillColor: Colors.grey[100],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onChanged: (value) =>
                                roomBloc.add(FilterUserEvent(value)),
                          ),
                          SizedBox(height: 10),
                          Expanded(
                            child: ListView.builder(
                              itemCount: state.filteredUsers.length,
                              itemBuilder: (context, index) {
                                final user = state.filteredUsers[index];
                                final isSelected = state.selectedUsers
                                    .any((u) => u['uid'] == user['uid']);
                                return ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: isSelected
                                          ? Colors.green
                                          : Colors.grey.shade300,
                                      child: Icon(Icons.person,
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                    title: Text(user['nickname']),
                                    subtitle: Text(user['email']),
                                    trailing: Checkbox(
                                      activeColor: kBackground,
                                      value: isSelected,
                                      onChanged: (_) =>
                                          roomBloc.add(ToggleUserEvent(user)),
                                    ),
                                    onTap: () => roomBloc.add(
                                          ToggleUserEvent(user),
                                        ));
                              },
                            ),
                          ),
                          SizedBox(height: 12),
                          ElevatedButton.icon(
                            onPressed: () {
                              if (state.selectedUsers.isNotEmpty) {
                                roomBloc.add(CreateRoomEvent());
                              }
                            },
                            icon: Icon(Icons.meeting_room),
                            label: Text('Create Room'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50),
                              backgroundColor: state.selectedUsers.isNotEmpty
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
        );
      },
    );
  }
}
