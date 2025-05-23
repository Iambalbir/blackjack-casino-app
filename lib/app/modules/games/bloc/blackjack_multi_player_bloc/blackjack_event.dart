abstract class BlackjackEvent {}

class StartGame extends BlackjackEvent {}

class DealCards extends BlackjackEvent {}

class PlayerAction extends BlackjackEvent {
  final String action;
  PlayerAction(this.action);
}
