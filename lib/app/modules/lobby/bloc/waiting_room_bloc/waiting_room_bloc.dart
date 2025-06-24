import 'package:app/export_file.dart';

class WaitingRoomBloc extends Bloc<WaitingRoomEvents, WaitingRoomState> {
  WaitingRoomBloc() : super(WaitingRoomState.initialState()) {
    on<InitialWaitingRoomEvent>(_initialEvent);
    on<RemoveUserEvent>(_removeUserEvent);
  }

  _initialEvent(
      InitialWaitingRoomEvent event, Emitter<WaitingRoomState> emit) async {
    emit(state.copyWith(roomCode: event.roomCode));
  }

  FutureOr<void> _removeUserEvent(
      RemoveUserEvent event, Emitter<WaitingRoomState> emit) async {
    try {
      final roomDocRef = FirebaseFirestore.instance
          .collection(roomCollectionPath)
          .doc(state.roomCode); // Use event.roomCode instead of state.roomCode

      final roomSnapshot = await roomDocRef.get();
      if (!roomSnapshot.exists) {
        print('Room does not exist');
        return;
      }

      final roomData = roomSnapshot.data();

      if (roomData == null) {
        print('Room data is null');
        return;
      }

      final List<dynamic> playersListing =
          List.from(roomData['players_listing'] ?? []);

      // Find the player map matching the user to remove (by uid)
      final playerToRemove = playersListing.firstWhere(
        (player) => player['uid'] == event.userId,
        orElse: () => null,
      );

      if (playerToRemove == null) {
        print('Player to remove not found');
        return;
      }

      // Remove the player from the players listing
      playersListing.remove(playerToRemove);

      await roomDocRef.update({
        'players_listing': playersListing,
        'leftUsers': FieldValue.arrayUnion([event.userId]),
      });

      // Remove the user's invitation documents from the 'invitations' collection
      final invitationsRef =
          FirebaseFirestore.instance.collection('invitations');
      final querySnapshot = await invitationsRef
          .where('roomCode', isEqualTo: state.roomCode)
          .where('to.uid', isEqualTo: event.userId)
          .get();

      final batch = FirebaseFirestore.instance.batch();

      for (final doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();

      print('User  ${event.userId} removed from waiting room and invitations.');
    } catch (e) {
      print('Error removing user from waiting room and invitations: $e');
    }
  }
}
