import 'package:app/app/modules/lobby/bloc/player_lobby_bloc/lobby_event.dart';
import 'package:app/app/modules/lobby/bloc/player_lobby_bloc/lobby_state.dart';
import 'package:app/export_file.dart';

class LobbyBloc extends Bloc<LobbyEvents, LobbyState> {
  LobbyBloc() : super(LobbyState.initial());

}
