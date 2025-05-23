import 'package:app/app/modules/games/bloc/blackjack_multi_player_bloc/blackjack_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blackjack_event.dart';

class BlackjackBloc extends Bloc<BlackjackEvent, BlackjackState> {
  BlackjackBloc() : super(BlackjackInitial()) {
    on<StartGame>((event, emit) => emit(BlackjackInitial()));
    on<DealCards>((event, emit) => emit(BlackjackDealing()));
    on<PlayerAction>((event, emit) {
      if (event.action == "Surrender") {
        emit(BlackjackSurrendered());
      } else {
        emit(BlackjackInProgress());
      }
    });
  }
}
