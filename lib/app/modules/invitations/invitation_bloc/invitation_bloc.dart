import 'package:app/export_file.dart';

class InvitationBloc extends Bloc<InvitationEvents, InvitationState> {
  InvitationBloc() : super(InvitationState()) {
    on<LoadInvitationsEvent>(_loadInvitations);
    on<AcceptInvitationEvent>(_acceptInvitation);
    on<DeclineInvitationEvent>(_declineInvitation);
  }

  Future<void> _loadInvitations(
      LoadInvitationsEvent event, Emitter<InvitationState> emit) async {
    emit(state.copyWith(isLoading: true));

    final snapshot = await FirebaseFirestore.instance
        .collection('invitations')
        .where('to.uid', isEqualTo: currentUserModel.uid)
        .where('status', isEqualTo: 'pending') // only pending invites
        .get();

    final invites = snapshot.docs
        .map((doc) => {
              ...doc.data(),
              'id': doc.id, // track invitation ID
            })
        .toList();

    emit(state.copyWith(invitations: invites, isLoading: false));
  }

  Future<void> _acceptInvitation(
      AcceptInvitationEvent event, Emitter<InvitationState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));

      final docId = event.invite['id'];
      final roomCode = event.invite['roomCode'];

      // Step 1: Mark the invitation as accepted
      await FirebaseFirestore.instance
          .collection('invitations')
          .doc(docId)
          .update({'status': 'accepted'});

      // Step 2: Update the invitedUsers list in the room
      final roomRef =
          FirebaseFirestore.instance.collection('rooms').doc(roomCode);
      final roomSnapshot = await roomRef.get();

      final roomData = roomSnapshot.data();
      if (roomData == null) {
        showToast('Room no longer exists');
        emit(state.copyWith(isLoading: false));
        return;
      }

      final invitedUsers =
          List<Map<String, dynamic>>.from(roomData['invitedUsers'] ?? []);

      final updatedUsers = invitedUsers.map((user) {
        if (user['uid'] == currentUserModel.uid) {
          return {...user, 'status': 'accepted'};
        }
        return user;
      }).toList();

      // Step 3: Write back updated users
      await roomRef.update({'invitedUsers': updatedUsers});
      await Future.delayed(Duration(
          milliseconds: 100)); // small delay to allow listener to react
      // Step 4: Emit navigation state
      emit(state.copyWith(navigateToRoom: {
        ...roomData,
        'invitedUsers': updatedUsers,
        'roomCode': roomCode,
      }, isLoading: false));

      // Optional: Reload invitations
      add(LoadInvitationsEvent());
    } catch (e) {
      showToast("Failed to accept invitation");
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _declineInvitation(
      DeclineInvitationEvent event, Emitter<InvitationState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));

      final docId = event.invite['id'];
      final roomCode = event.invite['roomCode'];
      final userId = currentUserModel.uid;

      // 1. Delete invitation document
      await FirebaseFirestore.instance
          .collection('invitations')
          .doc(docId)
          .delete();

      // 2. Update room invitedUsers list (optional: mark as declined)
      final roomRef =
          FirebaseFirestore.instance.collection('rooms').doc(roomCode);
      final roomSnapshot = await roomRef.get();

      if (roomSnapshot.exists) {
        final data = roomSnapshot.data() as Map<String, dynamic>;
        final List<dynamic> invitedUsers =
            List.from(data['invitedUsers'] ?? []);

        final updatedUsers = invitedUsers.map((user) {
          if (user['uid'] == userId) {
            return {...user, 'status': 'declined'};
          }
          return user;
        }).toList();

        await roomRef.update({'invitedUsers': updatedUsers});
      }
      add(LoadInvitationsEvent());
    } catch (e) {
      showToast("Failed to decline invitation");
      emit(state.copyWith(isLoading: false));
    }
  }
}
