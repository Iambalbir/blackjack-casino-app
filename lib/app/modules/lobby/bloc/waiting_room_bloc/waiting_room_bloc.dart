import 'package:app/export_file.dart';

class WaitingRoomBloc extends Bloc<WaitingRoomEvents, WaitingRoomState> {
  WaitingRoomBloc() : super(WaitingRoomState.initialState()) {
    on<InitialWaitingRoomEvent>(_initialEvent);
  }

  _initialEvent(
      InitialWaitingRoomEvent event, Emitter<WaitingRoomState> emit) async {}
}
