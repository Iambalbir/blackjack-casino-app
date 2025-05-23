abstract class GameEvents {}

class PlayEvent extends GameEvents {}

class BetEvent extends GameEvents {
  late int bet;
}

class HitEvent extends GameEvents {}

class StayEvent extends GameEvents {}

class SurrenderEvent extends GameEvents {}

class ContinueEvent extends GameEvents {}

class AdWatchedEvent extends GameEvents {}
