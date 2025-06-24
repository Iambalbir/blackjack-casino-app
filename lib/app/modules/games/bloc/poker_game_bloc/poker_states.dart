import '../../../../../export_file.dart';

class PokerStates {
  List<UserDataModel> playersListing;
  double tableWidth;
  double tableHeight;
  List<Offset> holePositions;
  final Offset cardSource;
  List<dynamic> leftUsers;
  List<dynamic> dealtCards;
  List<dynamic> allPlayersUid;
  List<dynamic> standPlayers;
  List<dynamic> playersBusted;
  List<dynamic> activeUsers;
  dynamic currentTurn;
  dynamic turnStartTime;
  dynamic turnId;
  bool roundFinished;
  bool allPlayersPlacedBet;
  bool isTimerCompleted;
  bool isNewMessageStreamed;
  double remainingTimeInSeconds;
  dynamic popUpMessageData;
  dynamic playerResults;

  PokerStates(
      {required this.playersListing,
      required this.tableWidth,
      required this.popUpMessageData,
      required this.playerResults,
      required this.remainingTimeInSeconds,
      required this.activeUsers,
      required this.isTimerCompleted,
      required this.allPlayersPlacedBet,
      required this.playersBusted,
      required this.standPlayers,
      required this.turnStartTime,
      required this.turnId,
      required this.roundFinished,
      required this.dealtCards,
      required this.currentTurn,
      required this.allPlayersUid,
      required this.cardSource,
      required this.isNewMessageStreamed,
      required this.leftUsers,
      required this.holePositions,
      required this.tableHeight});

  factory PokerStates.initialState() {
    return PokerStates(
        playersListing: [],
        roundFinished: false,
        isTimerCompleted: false,
        allPlayersPlacedBet: false,
        isNewMessageStreamed: false,
        allPlayersUid: [],
        standPlayers: [],
        playersBusted: [],
        leftUsers: [],
        activeUsers: [],
        dealtCards: [],
        popUpMessageData: {},
        playerResults: {},
        tableWidth: 0.0,
        remainingTimeInSeconds: 15.0,
        currentTurn: '',
        turnStartTime: '',
        turnId: '',
        cardSource: Offset(20.w, 20.h),
        tableHeight: 0.0,
        holePositions: []);
  }

  PokerStates copyWith(
      {playersListing,
      tableWidth,
      tableHeight,
      remainingTimeInSeconds,
      isTimerCompleted,
      activeUsers,
      popUpMessageData,
      allPlayersUid,
      holePositions,
      playersBusted,
      playerResults,
      roundFinished,
      currentTurn,
      turnStartTime,
      isNewMessageStreamed,
      standPlayers,
      allPlayersPlacedBet,
      turnId,
      dealtCards,
      cardSource,
      leftUsers}) {
    return PokerStates(
        playersListing: playersListing ?? this.playersListing,
        remainingTimeInSeconds:
            remainingTimeInSeconds ?? this.remainingTimeInSeconds,
        allPlayersPlacedBet: allPlayersPlacedBet ?? this.allPlayersPlacedBet,
        cardSource: cardSource ?? this.cardSource,
        playerResults: playerResults ?? this.playerResults,
        activeUsers: activeUsers ?? this.activeUsers,
        popUpMessageData: popUpMessageData ?? this.popUpMessageData,
        isTimerCompleted: isTimerCompleted ?? this.isTimerCompleted,
        roundFinished: roundFinished ?? this.roundFinished,
        standPlayers: standPlayers ?? this.standPlayers,
        playersBusted: playersBusted ?? this.playersBusted,
        isNewMessageStreamed: isNewMessageStreamed ?? this.isNewMessageStreamed,
        turnId: turnId ?? this.turnId,
        currentTurn: currentTurn ?? this.currentTurn,
        turnStartTime: turnStartTime ?? this.turnStartTime,
        dealtCards: dealtCards ?? this.dealtCards,
        allPlayersUid: allPlayersUid ?? this.allPlayersUid,
        leftUsers: leftUsers ?? this.leftUsers,
        tableHeight: tableHeight ?? this.tableHeight,
        holePositions: holePositions ?? this.holePositions,
        tableWidth: tableWidth ?? this.tableWidth);
  }
}
