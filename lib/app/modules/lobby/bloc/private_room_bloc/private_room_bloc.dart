import 'package:app/export_file.dart';

class CreateRoomBloc extends Bloc<RoomEvents, RoomState> {
  CreateRoomBloc() : super(RoomState.initialEvent()) {
    on<InitialEvent>(_initialEvent);
    on<FilterUserEvent>(_filterUsers);
    on<CreateRoomEvent>(_createRoomEvent);
    on<ToggleUserEvent>(_toggleUserEvent);
  }

  Future<void> _initialEvent(
      InitialEvent event, Emitter<RoomState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('users').get();

      final users = snapshot.docs
          .map((doc) => {
                'uid': doc.id,
                'nickname': doc['nickname'] ?? '',
                'email': doc['email'] ?? '',
              })
          .where((user) => user['uid'] != currentUserModel.uid)
          .toList();

      state.allUsers = users;
      state.filteredUsers = users;
      emit(state.copyWith(
          allUser: state.allUsers,
          filteredUsers: state.filteredUsers,
          isLoading: false));
    } catch (e) {}
  }

  void _filterUsers(FilterUserEvent event, Emitter<RoomState> emit) {
    state.searchQuery = event.query;
    state.filteredUsers = state.allUsers
        .where((user) =>
            user['nickname'].toLowerCase().contains(event.query?.toLowerCase()))
        .toList();
    emit(state.copyWith(filteredUsers: state.filteredUsers));
  }

  Future<void> _createRoomEvent(
      CreateRoomEvent event, Emitter<RoomState> emit) async {
    if (state.selectedUsers.isEmpty) {
      showToast("Select at least 1 user to create a room.");
      return;
    } else {
      if (state.selectedUsers.length > 4) {
        showToast("You can invite max 4 users.");
        return;
      }
    }

    emit(state.copyWith(isCreatingRoom: true));

    try {
      var requestModel = {
        'roomCode': '',
        'host': {
          'uid': currentUserModel.uid,
          'nickname': currentUserModel.nickname,
          'email': currentUserModel.email,
        },
        'game': 'Blackjack',
        'type': 'private',
        'entryFee': event.entryFee,
        'groupName': event.groupName,
        playersListing: state.selectedUsers,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
        'status': 'waiting', // could be waiting / active / finished
      };

      await firebaseRepository
          .createPrivateRoomTrigger(requestModel)
          .then((value) async {
        if (value != null) {
          for (final user in state.selectedUsers) {
            final invitationData = {
              'from': {
                'uid': currentUserModel.uid,
                'nickname': currentUserModel.nickname,
                'email': currentUserModel.email,
              },
              'to': {
                'uid': user['uid'],
                'nickname': user['nickname'],
                'email': user['email'],
              },
              'roomCode': value,
              'entryFee': event.entryFee,
              'groupName': event.groupName,
              'game': 'Blackjack',
              'type': 'private',
              'roomType': TYPE_MULTI_PLAYER,
              'time': DateTime.now().toIso8601String(),
              'status': 'pending',
              'createdAt': DateTime.now().millisecondsSinceEpoch,
            };
            await firebaseRepository.addInvitationData(invitationData);
            emit(state.copyWith(
              isCreatingRoom: false,
              roomCode: value,
            ));
            showToast("Room created successfully! Code: $value");
          }
        }
      });
    } catch (e) {
      emit(state.copyWith(isCreatingRoom: false, roomCode: ''));
      showToast("Failed to create room.");
    }
  }

  Future<void> _toggleUserEvent(
      ToggleUserEvent event, Emitter<RoomState> emit) async {
    final updatedSelectedUsers =
        List<Map<String, dynamic>>.from(state.selectedUsers);

    final isAlreadySelected =
        updatedSelectedUsers.any((u) => u['uid'] == event.user['uid']);

    if (isAlreadySelected) {
      updatedSelectedUsers.removeWhere((u) {
        return u['uid'] == event.user['uid'];
      });
    } else {
      if (updatedSelectedUsers.length < 4) {
        updatedSelectedUsers.add(event.user);
      } else {
        showToast("You can invite up to 4 players only.");
      }
    }

    emit(state.copyWith(selectedUsers: updatedSelectedUsers));
  }
}
