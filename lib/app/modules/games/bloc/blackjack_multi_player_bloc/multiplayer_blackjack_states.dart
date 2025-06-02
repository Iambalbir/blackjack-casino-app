import '../../../../../export_file.dart';

class MultiplayerBlackjackState {
  List<List<dynamic>> dealtCards;
  List<dynamic> playersBusted;
  List<dynamic> standPlayers;
  List<dynamic> allPlayersUid;
  double tableWidth;
  double borderRadius;
  bool isGameActive;
  double tableHeight;

  List<UserDataModel> playersListing;

  Stream<DocumentSnapshot>? gameStream;

  final Offset cardSource;

  List<Offset> holePositions;

  dynamic currentTurn;
  dynamic turnStartTime;
  dynamic turnId;
  dynamic roomCode;
  dynamic remainingTimeInSeconds;

  List<List<AnimationController>> controllers;
  List<List<Animation<Offset>>> animations;

  final Map<String, String> playerResults; // win/lose/push
  final bool roundFinished;

  MultiplayerBlackjackState(
      {required this.dealtCards,
      required this.gameStream,
      required this.currentTurn,
      required this.standPlayers,
      required this.roundFinished,
      required this.roomCode,
      required this.playerResults,
      required this.turnId,
      required this.remainingTimeInSeconds,
      required this.turnStartTime,
      required this.allPlayersUid,
      required this.playersListing,
      required this.tableWidth,
      required this.borderRadius,
      required this.tableHeight,
      required this.playersBusted,
      required this.isGameActive,
      required this.cardSource,
      required this.holePositions,
      required this.controllers,
      required this.animations});

  factory MultiplayerBlackjackState.initialState() {
    return MultiplayerBlackjackState(
      animations: [],
      cardSource: Offset(20.w, 20.h),
      controllers: [],
      allPlayersUid: [],
      standPlayers: [],
      dealtCards: [],
      playersListing: [],
      playerResults: {},
      gameStream: null,
      isGameActive: false,
      roundFinished: false,
      remainingTimeInSeconds: 15,
      tableHeight: 0.0,
      turnStartTime: DateTime.now().millisecondsSinceEpoch,
      turnId: 1,
      currentTurn: '',
      roomCode: '',
      borderRadius: 100.r,
      tableWidth: 0.0,
      holePositions: [],
      playersBusted: [],
    );
  }

  MultiplayerBlackjackState copyWith({
    animations,
    cardSource,
    isGameActive,
    controllers,
    playerResults,
    dealtCards,
    turnStartTime,
    currentTurn,
    roundFinished,
    allPlayersUid,
    roomCode,
    remainingTimeInSeconds,
    standPlayers,
    tableHeight,
    playersBusted,
    turnId,
    tableWidth,
    borderRadius,
    playersListing,
    gameStream,
    holePositions,
  }) {
    return MultiplayerBlackjackState(
        dealtCards: dealtCards ?? this.dealtCards,
        tableHeight: tableHeight ?? this.tableHeight,
        playerResults: playerResults ?? this.playerResults,
        roundFinished: roundFinished ?? this.roundFinished,
        turnStartTime: turnStartTime ?? this.turnStartTime,
        currentTurn: currentTurn ?? this.currentTurn,
        turnId: turnId ?? this.turnId,
        standPlayers: standPlayers ?? this.standPlayers,
        roomCode: roomCode ?? this.roomCode,
        remainingTimeInSeconds:
            remainingTimeInSeconds ?? this.remainingTimeInSeconds,
        tableWidth: tableWidth ?? this.tableWidth,
        borderRadius: borderRadius ?? this.borderRadius,
        isGameActive: isGameActive ?? this.isGameActive,
        gameStream: gameStream ?? this.gameStream,
        allPlayersUid: allPlayersUid ?? this.allPlayersUid,
        playersListing: playersListing ?? this.playersListing,
        cardSource: cardSource ?? this.cardSource,
        holePositions: holePositions ?? this.holePositions,
        controllers: controllers ?? this.controllers,
        playersBusted: playersBusted ?? this.playersBusted,
        animations: animations ?? this.animations);
  }
}
