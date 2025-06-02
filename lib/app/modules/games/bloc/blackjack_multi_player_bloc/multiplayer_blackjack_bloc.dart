import 'package:flutter/foundation.dart';

import '../../../../../export_file.dart';

class MultiPlayerBlackjackBloc
    extends Bloc<MultiPlayerBlackjackEvent, MultiplayerBlackjackState> {
  MultiPlayerBlackjackBloc() : super(MultiplayerBlackjackState.initialState()) {
    on<MultiPlayerBlackjackInitialEvent>(_initialEvents);
    on<SaveDealingCardToFireStoreEvent>(_saveDealingCardsToFireStore);
    on<StartGameStreamEvent>(_startGamingStreamEvent);
    on<StartDealingEvent>(_startDealing);
    on<UpdateHolePositionsEvent>(_initializeHolePositions);
    on<UpdateTableDimensions>(_updateTableDimension);
    on<UpdateTurnEvent>(_updateCurrentTurnEvent);
    on<EndTurnEvent>(_onEndTurnEvent);
    on<MultiPlayerHitEvent>(_onHitEvent);
    on<UpdateRemainingTimeInSeconds>(_updateRemainingTimeInSeconds);
    on<SkipTurnAutomaticTurnTriggerEvent>(_skipTurnAutomaticTurnTrigger);
    on<StandTurnEvent>(_standTurnEvent);
    on<DealerTurnEvent>(_dealerTurnEvent);
    on<CalculateResultsEvent>(_calculateResultEvent);
    on<DealerHitEvent>(_dealerHitEvent);
    on<DealerStandEvent>(_dealerStandEvent);
    on<DealerBustedEvent>(_dealerBustedEvent);
  }

  Timer? turnTimer;
  String? previousTurnId;

  _calculateResultEvent(CalculateResultsEvent event,
      Emitter<MultiplayerBlackjackState> emit) async {
    if (state.roundFinished) {
      print('Round already finished. Skipping _calculateResultEvent.');
      return; // Prevent duplicate processing
    }
    final dealerHand = event.dealtCards[0];
    final dealerValue = calculateHandValue(dealerHand);
    final dealerBusted = dealerValue > 21;

    final Map<String, String> playerResults = {}; // uid -> result

    for (int i = 0; i < state.allPlayersUid.length; i++) {
      final uid = state.allPlayersUid[i];
      if (uid == 'dealer') continue;

      final hand = event.dealtCards[i];
      final handValue = calculateHandValue(hand);
      final isBusted = handValue > 21;

      if (isBusted) {
        playerResults[uid] = "lose";
      } else if (dealerBusted) {
        playerResults[uid] = "win";
      } else if (handValue > dealerValue) {
        playerResults[uid] = "win";
      } else if (handValue < dealerValue) {
        playerResults[uid] = "lose";
      } else {
        playerResults[uid] = "push"; // tie
      }
    }

    final docRef =
        FirebaseFirestore.instance.collection('games').doc(state.roomCode);
    await docRef.update({
      'playerResults': playerResults,
      'lastUpdated': FieldValue.serverTimestamp(),
      'roundStatus': 'finished',
    });

    final roomsDocRef =
        FirebaseFirestore.instance.collection('rooms').doc(state.roomCode);

    await roomsDocRef.update({
      'status': 'finished',
      'lastUpdated': FieldValue.serverTimestamp(),
    });
    emit(state.copyWith(
      dealtCards: event.dealtCards,
      playerResults: playerResults,
      roundFinished: true,
    ));
  }

  _dealerTurnEvent(
      DealerTurnEvent event,
      Emitter<MultiplayerBlackjackState> emit,
      ) async {
    final dealerIndex = state.allPlayersUid.indexOf('dealer');
    if (dealerIndex == -1) return;

    final updatedDealtCards =
    state.dealtCards.map((cards) => List<String>.from(cards)).toList();

    int dealerHandValue = calculateHandValue(updatedDealtCards[dealerIndex]);

    final cardsMap = <String, List<String>>{};
    for (int i = 0; i < state.allPlayersUid.length; i++) {
      cardsMap[state.allPlayersUid[i]] =
      List<String>.from(updatedDealtCards[i]);
    }

    // Stand if already 17–21
    if (dealerHandValue >= 17 && dealerHandValue <= 21) {
      await _updateFirestoreDealtCards(cardsMap); // 🔁 Firestore sync
      add(DealerStandEvent(updatedDealtCards));
    } else {
      while (dealerHandValue < 16) {
        await Future.delayed(const Duration(milliseconds: 800));

        final newCard = generateRandomCard();
        updatedDealtCards[dealerIndex].add(newCard);

        dealerHandValue = calculateHandValue(updatedDealtCards[dealerIndex]);

        emit(state.copyWith(dealtCards: updatedDealtCards));
        add(DealerHitEvent(updatedDealtCards));

        await _updateFirestoreDealtCards(cardsMap); // 🔁 Firestore sync
      }

      // After finishing hits
      if (dealerHandValue > 21) {
        await _updateFirestoreDealtCards(cardsMap);
        add(DealerBustedEvent(updatedDealtCards));
      } else {
        await _updateFirestoreDealtCards(cardsMap);
        add(DealerStandEvent(updatedDealtCards));
      }
    }

    // 🔁 Final Firestore update to ensure all players have the result
    await _updateFirestoreDealtCards(cardsMap);

    add(CalculateResultsEvent(updatedDealtCards));
  }

  Future<void> _updateFirestoreDealtCards( updatedDealtCards) async {
    final roomId = state.roomCode; // Make sure this is stored in state
    await FirebaseFirestore.instance
        .collection('games')
        .doc(roomId)
        .update({
      'dealtCards': updatedDealtCards,
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }



  _dealerHitEvent(
    DealerHitEvent event,
    Emitter<MultiplayerBlackjackState> emit,
  ) async {
    final docRef =
        FirebaseFirestore.instance.collection('games').doc(state.roomCode);
    await docRef.update({
      'dealerAction': 'hit',
      'dealerHand': event.updatedDealtCards[0],
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  _dealerBustedEvent(
    DealerBustedEvent event,
    Emitter<MultiplayerBlackjackState> emit,
  ) async {
    final docRef =
        FirebaseFirestore.instance.collection('games').doc(state.roomCode);

    final updatedPlayersBusted = List<String>.from(state.playersBusted);
    if (!updatedPlayersBusted.contains('dealer')) {
      updatedPlayersBusted.add('dealer');
    }

    await docRef.update({
      'dealerAction': 'busted',
      'playersBusted': updatedPlayersBusted,
      'dealerHand': event.updatedDealtCards[0],
      'lastUpdated': FieldValue.serverTimestamp(),
    });

    emit(state.copyWith(playersBusted: updatedPlayersBusted));
  }

  _dealerStandEvent(
    DealerStandEvent event,
    Emitter<MultiplayerBlackjackState> emit,
  ) async {
    final docRef =
        FirebaseFirestore.instance.collection('games').doc(state.roomCode);

    final updatedPlayersStand = List<String>.from(state.standPlayers);
    if (!updatedPlayersStand.contains('dealer')) {
      updatedPlayersStand.add('dealer');
    }

    await docRef.update({
      'dealerAction': 'stand',
      'playersStand': updatedPlayersStand,
      'dealerHand': event.updatedDealtCards[0],
      'lastUpdated': FieldValue.serverTimestamp(),
    });

    emit(state.copyWith(standPlayers: updatedPlayersStand));
  }

  Future<void> _standTurnEvent(
    StandTurnEvent event,
    Emitter<MultiplayerBlackjackState> emit,
  ) async {
    print('==============>>  STAND EVENT TRIGGERED');

    try {
      final updatedStandPlayers = List<String>.from(state.standPlayers ?? []);

      if (!updatedStandPlayers.contains(state.currentTurn)) {
        updatedStandPlayers.add(state.currentTurn);
      }

      final docRef =
          FirebaseFirestore.instance.collection('rooms').doc(state.roomCode);

      await docRef.update({
        'standPlayers': updatedStandPlayers,
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      emit(state.copyWith(
        standPlayers: updatedStandPlayers,
      ));

      rotateTurn(state.roomCode);
    } catch (e) {
      print('Error in _standTurnEvent: $e');
    }
  }

  _skipTurnAutomaticTurnTrigger(SkipTurnAutomaticTurnTriggerEvent event,
      Emitter<MultiplayerBlackjackState> emit) {
    if (state.currentTurn != 'dealer') {
      final currentHandValue =
          calculateHandValue(state.dealtCards[state.turnId]);

      if (currentHandValue <= 17) {
        add(MultiPlayerHitEvent(state.roomCode));
      } else {
        add(StandTurnEvent());
      }
      _startTurnTimer(state.turnId);
    } else {
      add(DealerTurnEvent());
    }
  }

  _updateRemainingTimeInSeconds(UpdateRemainingTimeInSeconds event,
      Emitter<MultiplayerBlackjackState> emit) {
    emit(state.copyWith(remainingTimeInSeconds: event.remainingTimeInSecs));
  }

  _onHitEvent(MultiPlayerHitEvent event,
      Emitter<MultiplayerBlackjackState> emit) async {
    if (state.playersBusted.contains(state.currentTurn)) {
      print('Player ${state.currentTurn} is already busted. Skipping hit.');
      return;
    }

    if (state.turnId == -1) {
      print('Error: Player ID ${state.currentTurn} not found.');
      return;
    }

    final newCard = generateRandomCard();

    final updatedDealtCards = List<List<dynamic>>.from(state.dealtCards);
    updatedDealtCards[state.turnId].add(newCard);

    final cardsMap = <String, List<String>>{};
    for (int i = 0; i < state.allPlayersUid.length; i++) {
      cardsMap[state.allPlayersUid[i]] =
          List<String>.from(updatedDealtCards[i]);
    }

    final int totalValue = calculateHandValue(updatedDealtCards[state.turnId]);
    final updatedPlayersBusted = List<dynamic>.from(state.playersBusted ?? []);

    bool busted = false;
    bool autoStand = false;
    if (totalValue > 21) {
      if (!updatedPlayersBusted.contains(state.currentTurn)) {
        updatedPlayersBusted.add(state.currentTurn);
      }
      busted = true;
    } else {
      updatedPlayersBusted.remove(state.currentTurn);
      if (totalValue == 21) {
        autoStand = true; // Trigger stand immediately
      }
    }

    final docRef =
        FirebaseFirestore.instance.collection('games').doc(event.roomCode);

    await docRef.update({
      'dealtCards': cardsMap,
      'playersBusted': updatedPlayersBusted,
      'lastUpdated': FieldValue.serverTimestamp(),
    });

    emit(state.copyWith(
      dealtCards: updatedDealtCards,
      playersBusted: updatedPlayersBusted,
    ));

    if (busted) {
      rotateTurn(event.roomCode);
    } else if (autoStand) {
      print('Player has 21. Auto-standing...');
      add(StandTurnEvent());
    }
  }

  Future<void> _initialEvents(
    MultiPlayerBlackjackInitialEvent event,
    Emitter<MultiplayerBlackjackState> emit,
  ) async {
    final passedPlayers = event.argumentsData['players'];
    var isActiveGame = event.argumentsData['isGameActiveStatus'] ?? false;

    final playersListing = passedPlayers
        .map<UserDataModel>(
            (player) => UserDataModel.fromJson(player as Map<String, dynamic>))
        .toList();
    List<UserDataModel> players = [
      UserDataModel(nickname: "Dealer"),
      ...playersListing,
    ];
    final allPlayersUid = [
      'dealer',
      ...playersListing.map((p) {
        return p.uid.toString();
      }),
    ];

    _listenToTurnChanges(event.argumentsData['roomCode']);

    emit(state.copyWith(
        playersListing: players,
        roomCode: event.argumentsData['roomCode'],
        allPlayersUid: allPlayersUid,
        isGameActive: isActiveGame));

    add(SaveDealingCardToFireStoreEvent(allPlayersUid));
  }

  var cTurnId;

  void _listenToTurnChanges(String roomId) {
    StreamSubscription<DocumentSnapshot>? newSub;
    Timer? debounce;

    newSub = FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId)
        .snapshots()
        .listen((snapshot) {
      debounce?.cancel();
      debounce = Timer(const Duration(milliseconds: 300), () {
        final data = snapshot.data();
        if (data != null) {
          cTurnId = data['currentTurn'];
          final newTurnId = data['turnId'];
          final newTurnStartTime = data['turnStartTime'];

          add(UpdateTurnEvent(
            currentTurn: cTurnId,
            turnStartTime: newTurnStartTime,
            turnId: newTurnId,
          ));
        }
      });
    }, onError: (e) {
      print('Stream error: $e');
    });
  }

  Future<void> _updateCurrentTurnEvent(
      UpdateTurnEvent event, Emitter<MultiplayerBlackjackState> emit) async {
    if (state.remainingTimeInSeconds == 0 &&
        state.currentTurn == event.currentTurn) {
      print('Turn timed out. Triggering auto-skip...');
      add(SkipTurnAutomaticTurnTriggerEvent());
      return;
    }

    if (state.currentTurn == event.currentTurn &&
        state.turnId == event.turnId &&
        state.turnStartTime == event.turnStartTime) {
      return;
    }

    emit(state.copyWith(
      currentTurn: event.currentTurn,
      turnId: event.turnId,
      turnStartTime: event.turnStartTime,
    ));

    _startTurnTimer(event.turnId);
  }

  Future<void> _onEndTurnEvent(
      EndTurnEvent event, Emitter<MultiplayerBlackjackState> emit) async {
    var currentTurn = '';
    emit(state.copyWith(currentTurn: currentTurn));
  }

  void _updateTableDimension(
      UpdateTableDimensions event, Emitter<MultiplayerBlackjackState> emit) {
    final width = MediaQuery.sizeOf(event.context).width * 0.8;
    final height = MediaQuery.sizeOf(event.context).height * 0.68;
    emit(state.copyWith(tableHeight: height, tableWidth: width));
  }

  Future<void> _saveDealingCardsToFireStore(
      SaveDealingCardToFireStoreEvent event,
      Emitter<MultiplayerBlackjackState> emit) async {
    try {
      if (!state.isGameActive) {
        await apiRepository.saveDealingCardsToFireStore(
            state.roomCode, event.playersUid);
      }
      add(StartGameStreamEvent(state.roomCode));
    } catch (error) {
      print('Error saving dealing cards: $error');
    }
  }

  Future<void> _startGamingStreamEvent(StartGameStreamEvent event,
      Emitter<MultiplayerBlackjackState> emit) async {
    final stream = FirebaseFirestore.instance
        .collection('games')
        .doc(event.roomCode)
        .snapshots();

    emit(state.copyWith(gameStream: stream));

    await for (final doc in stream) {
      if (!doc.exists) continue;
      final data = doc.data();
      if (data == null) continue;

      final dealtCardsMap = data['dealtCards'] as Map<String, dynamic>?;
      if (dealtCardsMap != null) {
        final cardsList = state.allPlayersUid.map<List<String>>((uid) {
          final raw = dealtCardsMap[uid];
          return (raw != null && raw is List<dynamic>)
              ? raw.cast<String>()
              : <String>[];
        }).toList();

        if (!listEquals(cardsList, state.dealtCards)) {
          if (emit.isDone) return;

          emit(state.copyWith(
              dealtCards: cardsList, playersBusted: data['playersBusted']));

          await Future.delayed(const Duration(milliseconds: 400));

          if (emit.isDone) return;

          add(StartDealingEvent());
        }
      }
    }
  }

  Future<void> _startDealing(
      StartDealingEvent event, Emitter<MultiplayerBlackjackState> emit) async {
    if (state.isGameActive) {
      print('Game is already in progress. Cannot deal cards again.');
      emit(state.copyWith(dealtCards: state.dealtCards));
      return;
    }

    if (state.dealtCards.isEmpty || state.dealtCards[0].isEmpty) {
      print('Warning: dealtCards is empty, cannot start dealing.');
      return;
    }

    final cardsCount = state.dealtCards[0].length;

    for (int cardIndex = 0; cardIndex < cardsCount; cardIndex++) {
      for (int playerIndex = 0;
          playerIndex < state.playersListing.length;
          playerIndex++) {
        await Future.delayed(const Duration(milliseconds: 300));

        if (playerIndex >= state.controllers.length ||
            cardIndex >= state.controllers[playerIndex].length) {
          print(
              'Warning: controller not found for player $playerIndex card $cardIndex');
          continue;
        }
        state.controllers[playerIndex][cardIndex].forward();
      }
    }
  }

  Future<void> _initializeHolePositions(UpdateHolePositionsEvent event,
      Emitter<MultiplayerBlackjackState> emit) async {
    final double holeRadius = state.tableHeight * 0.038;
    final double holeDiameter = holeRadius * 2;
    final double verticalSpace = state.tableHeight - holeDiameter * 2;
    final double margin = verticalSpace / 3;
    final double leftHole1Y = margin - 2;
    final double leftHole2Y = margin + holeDiameter + margin;
    final double rightHole1Y = leftHole1Y;
    final double rightHole2Y = leftHole2Y;

    var holePositions = [
      Offset(state.tableWidth / 1.78.w - holeRadius, -13.h),
      Offset(state.tableWidth / 1.78.w - holeRadius, state.tableHeight - 30.h),
      Offset(-15.w, leftHole1Y + 10.h),
      Offset(-15.w, leftHole2Y + 3.h),
      Offset(state.tableWidth - holeDiameter + 3.w, rightHole1Y),
      Offset(state.tableWidth - holeDiameter + 3.w, rightHole2Y),
    ];
    emit(state.copyWith(holePositions: holePositions));
  }

  void _startTurnTimer(int turnId) {
    turnTimer?.cancel();
    turnTimer = Timer(const Duration(seconds: 15), () {
      if (state.turnId == turnId) {
        add(SkipTurnAutomaticTurnTriggerEvent());
      }
    });
  }

  void rotateTurn(String roomCode) async {
    print('Rotating turn...');

    final docRef = FirebaseFirestore.instance.collection('rooms').doc(roomCode);
    final doc = await docRef.get();

    if (!doc.exists) return;

    final data = doc.data();
    if (data == null) return;

    final currentTurn = data['currentTurn'];
    final allPlayers = List<String>.from(state.allPlayersUid);
    final playersStood = List<String>.from(state.standPlayers ?? []);
    final playersBusted = List<String>.from(state.playersBusted ?? []);

    final activePlayers = allPlayers.where((uid) {
      return uid != 'dealer' &&
          !playersStood.contains(uid) &&
          !playersBusted.contains(uid);
    }).toList();

    if (activePlayers.isEmpty) {
      print('All players have either stood or busted. Dealer turn now.');

      await docRef.update({
        'currentTurn': 'dealer',
        'turnStartTime': DateTime.now().millisecondsSinceEpoch,
        'turnId': 0,
      });
      return;
    }

    final currentIndex = allPlayers.indexOf(currentTurn);
    int nextIndex = (currentIndex + 1) % allPlayers.length;

    for (int i = 0; i < allPlayers.length; i++) {
      final nextPlayer = allPlayers[nextIndex];

      final isActive = nextPlayer != 'dealer' &&
          !playersBusted.contains(nextPlayer) &&
          !playersStood.contains(nextPlayer);

      if (isActive) {
        await docRef.update({
          'currentTurn': nextPlayer,
          'turnStartTime': DateTime.now().millisecondsSinceEpoch,
          'turnId': nextIndex,
        });
        print('Next turn goes to: $nextPlayer');
        return;
      }

      nextIndex = (nextIndex + 1) % allPlayers.length;
    }

    // Fallback: no one found (shouldn't occur if activePlayers is accurate)
    print('No eligible player found in rotation. Assigning dealer.');
    await docRef.update({
      'currentTurn': 'dealer',
      'turnStartTime': DateTime.now().millisecondsSinceEpoch,
      'turnId': 0,
    });
  }

  @override
  Future<void> close() {
    turnTimer?.cancel();
    return super.close();
  }
}
