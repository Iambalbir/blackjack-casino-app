import 'package:app/app/modules/main/main_bloc/main_events.dart';
import 'package:app/app/modules/main/main_bloc/main_state.dart';
import 'package:app/export_file.dart';

class MainScreenBloc extends Bloc<MainScreenEvents, MainScreenStates> {
  MainScreenBloc() : super(MainScreenStates.initialState()) {
    on<CreateSinglePlayerRoomEvent>(_createSinglePlayerRoomEvent);
  }

  _createSinglePlayerRoomEvent(
      CreateSinglePlayerRoomEvent event, Emitter<MainScreenStates> emit) async {
    emit(state.copyWith(isLoading: true));
    customLoader.show(event.context);
    try {
      var requestModel = {
        'roomCode': '',
        'host': {
          'uid': currentUserModel.uid,
          'nickname': currentUserModel.nickname,
          'email': currentUserModel.email,
        },
        'game': 'Blackjack',
        'roomType':TYPE_SINGLE_PLAYER,
        'type': 'private',
        'groupName': "Solo Player BlackJack",
        playersListing: [],
        'createdAt': DateTime.now().millisecondsSinceEpoch,
        'status': 'accepted', // could be waiting / active / finished
      };
      await firebaseRepository
          .createPrivateRoomTrigger(requestModel)
          .then((value) {
        if (value != null) {
          customLoader.hide();
          emit(state.copyWith(
              roomCode: value,
              isRoomCreated: true,
              isLoading: false,
              host: requestModel['host']));
        }
      });
    } catch (e) {
      customLoader.hide();
    }
  }
}
