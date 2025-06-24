import '../../../../../export_file.dart';

class MultiplayerBlackjackState /*extends Equatable*/ {
  List<dynamic> dealtCards;
  List<dynamic> playersBusted;
  List<dynamic> standPlayers;
  List<dynamic> activeUsers;
  List<dynamic> leftUsers;
  List<dynamic> chatListing;
  List<dynamic> allPlayersUid;
  double tableWidth;
  double borderRadius;
  bool isGameActive;
  double tableHeight;
  dynamic hostUid;
  bool isNewMessageStreamed;
  bool allPlayersPlacedBet;
  dynamic popUpMessageData;
  List<UserDataModel> playersListing;
  Stream<DocumentSnapshot>? gameStream;
  final bool isTimerCompleted;
  final Offset cardSource;

  List<Offset> holePositions;

  dynamic currentTurn;
  dynamic turnStartTime;
  dynamic turnId;
  dynamic roomCode;
  dynamic remainingTimeInSeconds;

  List<List<AnimationController>> controllers;
  List<List<Animation<Offset>>> animations;

  final Map<String, dynamic> playerResults;

  final Map<String, dynamic> playerPayouts; // win/lose/push
  final bool roundFinished;

  MultiplayerBlackjackState(
      {required this.dealtCards,
      required this.gameStream,
      required this.currentTurn,
      required this.chatListing,
      required this.isNewMessageStreamed,
      required this.standPlayers,
      required this.roundFinished,
      required this.roomCode,
      required this.playerResults,
      required this.isTimerCompleted,
      required this.turnId,
      required this.leftUsers,
      required this.remainingTimeInSeconds,
      required this.allPlayersPlacedBet,
      required this.turnStartTime,
      required this.popUpMessageData,
      required this.activeUsers,
      required this.allPlayersUid,
      required this.playersListing,
      required this.hostUid,
      required this.tableWidth,
      required this.borderRadius,
      required this.playerPayouts,
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
      activeUsers: [],
      standPlayers: [],
      dealtCards: [],
      playersListing: [],
      chatListing: [],
      leftUsers: [],
      playerResults: {},
      popUpMessageData: {},
      playerPayouts: {},
      gameStream: null,
      isGameActive: false,
      isNewMessageStreamed: false,
      isTimerCompleted: false,
      allPlayersPlacedBet: false,
      roundFinished: false,
      remainingTimeInSeconds: 15,
      tableHeight: 0.0,
      turnStartTime: DateTime.now().millisecondsSinceEpoch,
      turnId: 1,
      currentTurn: '',
      hostUid: '',
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
    isNewMessageStreamed,
    popUpMessageData,
    playerResults,
    activeUsers,
    dealtCards,
    turnStartTime,
    currentTurn,
    isTimerCompleted,
    leftUsers,
    playerPayouts,
    roundFinished,
    chatListing,
    allPlayersUid,
    roomCode,
    remainingTimeInSeconds,
    standPlayers,
    tableHeight,
    playersBusted,
    hostUid,
    allPlayersPlacedBet,
    turnId,
    tableWidth,
    borderRadius,
    playersListing,
    gameStream,
    holePositions,
  }) {
    return MultiplayerBlackjackState(
        dealtCards: dealtCards ?? this.dealtCards,
        isTimerCompleted: isTimerCompleted ?? this.isTimerCompleted,
        activeUsers: activeUsers ?? this.activeUsers,
        tableHeight: tableHeight ?? this.tableHeight,
        leftUsers: leftUsers ?? this.leftUsers,
        playerResults: playerResults ?? this.playerResults,
        hostUid: hostUid ?? this.hostUid,
        isNewMessageStreamed: isNewMessageStreamed ?? this.isNewMessageStreamed,
        roundFinished: roundFinished ?? this.roundFinished,
        turnStartTime: turnStartTime ?? this.turnStartTime,
        popUpMessageData: popUpMessageData ?? this.popUpMessageData,
        allPlayersPlacedBet: allPlayersPlacedBet ?? this.allPlayersPlacedBet,
        currentTurn: currentTurn ?? this.currentTurn,
        turnId: turnId ?? this.turnId,
        standPlayers: standPlayers ?? this.standPlayers,
        playerPayouts: playerPayouts ?? this.playerPayouts,
        roomCode: roomCode ?? this.roomCode,
        remainingTimeInSeconds:
            remainingTimeInSeconds ?? this.remainingTimeInSeconds,
        tableWidth: tableWidth ?? this.tableWidth,
        chatListing: chatListing ?? this.chatListing,
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
