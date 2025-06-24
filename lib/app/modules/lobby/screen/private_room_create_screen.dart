import 'package:app/export_file.dart';

class CreatePrivateRoomView extends StatefulWidget {
  @override
  _CreateRoomWithUserSelectionScreenState createState() =>
      _CreateRoomWithUserSelectionScreenState();
}

class _CreateRoomWithUserSelectionScreenState
    extends State<CreatePrivateRoomView> {
  late final CreateRoomBloc _bloc;
  TextEditingController entryFeeController = TextEditingController();
  TextEditingController groupNameTextController = TextEditingController();
  final GlobalKey<FormState> globalKey = GlobalKey();

  @override
  void didChangeDependencies() {
    _bloc = context.read<CreateRoomBloc>();
    context.read<CreateRoomBloc>().add(InitialEvent());
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final roomBloc = context.read<CreateRoomBloc>();
    return BlocConsumer<CreateRoomBloc, RoomState>(
      listener: (context, state) {
        if (state.roomCode != '' && !state.isCreatingRoom) {
          Navigator.pushReplacementNamed(
              context, RouteName.waitingRoomScreenRoute,
              arguments: {"roomCode": state.roomCode});
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
              title: TextView(
            text: 'Private Room',
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
                            text: 'Select players to invite (max 4)',
                            textStyle: textStyleBodyMedium(context)
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 10),
                          Form(
                            key: globalKey,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: margin_10),
                                  child: TextFieldWidget(
                                    textController: groupNameTextController,
                                    radius: radius_5,
                                    validate: (value) =>
                                        FieldChecker.fieldChecker(
                                            value, "Public Group Name"),
                                    readOnly: false,
                                    hint: "Group Name",
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(vertical: margin_10),
                                  child: TextFieldWidget(
                                    textController: entryFeeController,
                                    // Add this controller in your state
                                    radius: radius_5,
                                    inputType: TextInputType.numberWithOptions(
                                        decimal: true, signed: false),
                                    inputFormatter: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    validate: (value) =>
                                        FieldChecker.entryFeeValidator(value),
                                    // Add appropriate validation
                                    readOnly: false,
                                    hint: "Entry Fee",
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                              if (globalKey.currentState!.validate()) {
                                if (state.selectedUsers.isNotEmpty) {
                                  roomBloc.add(CreateRoomEvent(
                                      groupName: groupNameTextController.text,
                                      entryFee: entryFeeController.text));
                                }
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

  @override
  void dispose() {
    print('private room  bloc disposed');
    _bloc.close();
    super.dispose();
  }
}
