import 'package:app/core/utils/dialogs/bet_amout_select_dialog.dart';
import 'package:flutter/foundation.dart';

import '../../../../../export_file.dart';

class MultiPlayerBlackjackBloc
    extends Bloc<MultiPlayerBlackjackEvent, MultiplayerBlackjackState> {
  MultiPlayerBlackjackBloc() : super(MultiplayerBlackjackState.initialState()) {
    on<UserOfflineEvent>(_userOfflineEvent);
    on<CheckPlayerStatus>(_checkPlayerStatus);
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
    on<SendChatMessageEvent>(_onSendChatMessage);
    on<AddNewMessageDataEventTrigger>(_addNewMessageDataEvent);
    on<AddBettingAmountEvent>(_addBettingAmount);
    on<LeaveGameEvent>(_leaveGameEvent);
    on<UpdateTimerCompletionStatus>(_updateTimerStatus);
  }

  _updateTimerStatus(UpdateTimerCompletionStatus event,
      Emitter<MultiplayerBlackjackState> emit) {
    emit(state.copyWith(isTimerCompleted: event.isCompleted));
  }

  _leaveGameEvent(
      LeaveGameEvent event, Emitter<MultiplayerBlackjackState> emit) async {
    var docRef =
        FirebaseFirestore.instance.collection("games").doc(state.roomCode);
    var roomDocRef = FirebaseFirestore.instance
        .collection(roomCollectionPath)
        .doc(state.roomCode);

    var userDoc = FirebaseFirestore.instance
        .collection("users")
        .doc(currentUserModel.uid);
    var userDataSnapShot = await userDoc.get();
    var userData = userDataSnapShot.data();
    final currentCoins = userData?['coins'] as num? ?? 0;

    final newCoins = currentCoins - int.parse(event.betAmount.toString());
    userDoc.update({'coins': newCoins});
    await docRef.update({
      'leftUsers': FieldValue.arrayUnion([currentUserModel.uid]),
      'activeUsers': FieldValue.arrayRemove([currentUserModel.uid])
    });
    await roomDocRef.update({
      'leftUsers': FieldValue.arrayUnion([currentUserModel.uid]),
      'activeUsers': FieldValue.arrayRemove([currentUserModel.uid])
    });
    if (state.currentTurn == currentUserModel.uid) {
      Future.delayed(Duration(milliseconds: 500)).then((onValue) {
        rotateTurn();
      });
    }
  }

  Future<void> _initialEvents(
    MultiPlayerBlackjackInitialEvent event,
    Emitter<MultiplayerBlackjackState> emit,
  ) async {
    customLoader.show(event.context);
    final roomType = event.argumentsData['type'] ?? "public";
    final passedPlayers = event.argumentsData['players'] ?? [];
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

    if (isActiveGame) {
      emit(state.copyWith(
          roomCode: event.argumentsData['roomCode'],
          allPlayersUid: allPlayersUid,
          isGameActive: isActiveGame));
      Future.delayed(Duration(milliseconds: 400)).then((value) {
        customLoader.hide();
        add(StartGameStreamEvent(event.argumentsData['roomCode'],
            context: event.context));
      });
      Future.delayed((Duration(milliseconds: 500))).then((value) {
        if (state.allPlayersPlacedBet && state.dealtCards.isNotEmpty) {
          customLoader.hide();
          add(SaveDealingCardToFireStoreEvent(
              state.allPlayersUid, event.context));
        }
      });
      add(CheckPlayerStatus(
          roomCode: event.argumentsData['roomCode'], isAppResumed: true));
    } else {
      final updatedPlayerList = players.map((player) {
        return {
          'nickname': player.nickname ?? "",
          'email': player.email ?? "",
          'uid': player.uid ?? "dealer",
          'betAmount': player.betAmount ?? 0.0
        };
      }).toList();
      add(CheckPlayerStatus(
          roomCode: event.argumentsData['roomCode'],
          playersListing: updatedPlayerList));

      emit(state.copyWith(
          roomCode: event.argumentsData['roomCode'],
          allPlayersUid: allPlayersUid,
          isGameActive: isActiveGame));
      if (roomType != 'private') {
        print('from this private calledd');
        _checkPlayerPlacedBet(event.context);
      } else {
        add(StartGameStreamEvent(event.argumentsData['roomCode'],
            context: event.context));
      }
    }
    _listenToChatStream();
  }

  _checkPlayerStatus(
      CheckPlayerStatus event, Emitter<MultiplayerBlackjackState> emit) async {
    final docRef = FirebaseFirestore.instance
        .collection("games")
        .doc(event.roomCode ?? state.roomCode);

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final docSnapshot = await transaction.get(docRef);
        if (docSnapshot.exists) {
          final data = docSnapshot.data() as Map<String, dynamic>;
          final currentActiveUsers = List.from(data['activeUsers'] ?? []);
          if (!event.isAppResumed) {
            if (!currentActiveUsers.contains(currentUserModel.uid)) {
              currentActiveUsers.add(currentUserModel.uid);
              transaction.update(docRef, {
                'activeUsers': FieldValue.arrayUnion([currentUserModel.uid]),
                'players': event.playersListing
              });
            }
          } else {
            if (!currentActiveUsers.contains(currentUserModel.uid)) {
              currentActiveUsers.add(currentUserModel.uid);
              transaction.update(docRef, {
                'activeUsers': FieldValue.arrayUnion([currentUserModel.uid]),
              });
            }
          }

          emit(state.copyWith(activeUsers: currentActiveUsers));
        } else {
          await transaction.set(docRef, {
            'activeUsers': [currentUserModel.uid],
            'players': event.playersListing
          });
          emit(state.copyWith(activeUsers: [currentUserModel.uid]));
        }
      });
    } catch (e) {
      customLoader.hide();
      print('Error updating active users: $e');
    }
  }

  _checkPlayerPlacedBet(BuildContext context) async {
    customLoader.hide();
    await _showDialog(context);
  }

  _showDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => BetSelectionDialog(bankAmount: bankAmount.value),
    ).then((selectedBet) {
      if (selectedBet != null) {
        add(AddBettingAmountEvent(
            selectedBet.toString().split(".")[0], state.roomCode, context));
      }
    });
  }

  Future<void> _addBettingAmount(AddBettingAmountEvent event,
      Emitter<MultiplayerBlackjackState> emit) async {
    try {
      customLoader.show(event.context);
      final roomCode = event.roomCode;
      if (roomCode == null || roomCode.isEmpty) {
        customLoader.hide();
        print('Error: roomCode is null or empty when adding betting amount.');
        return;
      }
      final userDocRef = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserModel.uid);
      final docRef =
          FirebaseFirestore.instance.collection('games').doc(roomCode);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);
        final userSnapshot = await transaction.get(userDocRef);
        final userData = userSnapshot.data() as Map<String, dynamic>;
        final currentCoins = userData['coins'] as num? ?? 0;

        final newCoins = currentCoins - int.parse(event.betAmount.toString());
        print('new coins------___>${newCoins}');
        transaction.update(userDocRef, {'coins': newCoins});
        if (!snapshot.exists) {
          throw Exception("Game document does not exist");
        }
        final data = snapshot.data()!;
        List<dynamic> players = List.from(data['players'] ?? []);

        final index =
            players.indexWhere((p) => p['uid'] == currentUserModel.uid);
        if (index == -1) {
          throw Exception("Player not found in players list");
        }

        // Clone player map and update betAmount
        Map<String, dynamic> updatedPlayer =
            Map<String, dynamic>.from(players[index]);
        updatedPlayer['betAmount'] = event.betAmount;

        // Replace player at found index with updated one
        players[index] = updatedPlayer;
        transaction.update(docRef, {'players': players});
      });

      final updatedSnapshot = await docRef.get();

      final updatedData = updatedSnapshot.data() as Map<String, dynamic>;
      List<UserDataModel> players = updatedData['players'] != null
          ? (updatedData['players'] as List<dynamic>)
              .map((e) => UserDataModel(
                    nickname: e['nickname'] ?? "",
                    email: e['email'] ?? "",
                    uid: e['uid'] ?? "",
                    betAmount: e['betAmount'] ?? 0.0,
                  ))
              .toList() // Convert to List<UserDataModel>
          : state.playersListing;

      if (allUsersHavePlacedBets(players, 'dealer')) {
        docRef.update({"allPlayersPlacedBet": true});
        emit(state.copyWith(allPlayersPlacedBet: true));
      } else {
        emit(state.copyWith(allPlayersPlacedBet: false));
      }
      customLoader.hide();
      add(StartGameStreamEvent(state.roomCode));
    } catch (e, s) {
      print('Error updating betting amount: $e');
      print('error------__$s');
    }
  }

  bool allUsersHavePlacedBets(List<UserDataModel> players, String dealerUid) {
    for (int i = 0; i < players.length; i++) {
      if (players[i].uid != 'dealer') {
        if (double.parse(players[i].betAmount.toString()) == 0.0) {
          return false;
        }
      }
    }
    return true;
  }

  _listenToChatStream() {
    Timer? debounce;
    _chatStream = FirebaseFirestore.instance
        .collection('games')
        .doc(state.roomCode)
        .collection('chatMessages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapShot) {
      debounce?.cancel();
      debounce = Timer(const Duration(milliseconds: 500), () {
        final chatDocs = snapShot.docs;

        final chatListing = chatDocs.map((doc) {
          final data = doc.data();
          return {
            'senderUid': data['senderUid'] ?? '',
            'senderName': data['senderName'] ?? '',
            'message': data['message'] ?? '',
            'timestamp': data['timestamp'],
          };
        }).toList();
        emit(state.copyWith(
            chatListing: chatListing,
            isNewMessageStreamed: chatListing.isNotEmpty ? true : false));
        add(AddNewMessageDataEventTrigger());
      });
    });
  }

  _addNewMessageDataEvent(AddNewMessageDataEventTrigger event,
      Emitter<MultiplayerBlackjackState> emit) async {
    if (state.chatListing.length != 0) {
      var data = state.chatListing[0];
      emit(state.copyWith(popUpMessageData: data));
    }
    await Future.delayed(Duration(seconds: 5));
    emit(state.copyWith(popUpMessageData: {}, isNewMessageStreamed: false));
  }

  Future<void> _onSendChatMessage(
    SendChatMessageEvent event,
    Emitter<MultiplayerBlackjackState> emit,
  ) async {
    try {
      final roomCode = state.roomCode; // Assuming roomCode is stored in state

      if (roomCode == null || roomCode.isEmpty) {
        print('Error: roomCode is null or empty when sending chat message.');
        return;
      }

      final messageText = event.messageText.trim();

      if (messageText.isEmpty) return;

      final newMessageDoc = FirebaseFirestore.instance
          .collection('games')
          .doc(roomCode)
          .collection('chatMessages')
          .doc();

      await newMessageDoc.set({
        'senderUid': currentUserModel.uid,
        'senderName': currentUserModel.nickname,
        'message': messageText,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });

      print('Chat message sent successfully: $messageText');
    } catch (e, s) {
      print('Error sending chat message: $e');
      print(s);
    }
  }

  Future<void> _userOfflineEvent(
      UserOfflineEvent event, Emitter<MultiplayerBlackjackState> emit) async {
    try {
      final docRef =
          FirebaseFirestore.instance.collection("games").doc(state.roomCode);

      await docRef.update({
        'activeUsers': FieldValue.arrayRemove([currentUserModel.uid]),
      });

      final updatedActiveUsers = List<String>.from(state.activeUsers)
        ..remove(currentUserModel.uid);

      emit(state.copyWith(activeUsers: updatedActiveUsers));

      print('User ${currentUserModel.uid} removed from activeUsers on leave.');
    } catch (e) {
      print('Error removing user from activeUsers on leave: $e');
    }
  }

  Timer? turnTimer;
  String? previousTurnId;
  bool _sessionAdded = false;

// Updated _calculateResultEvent method with clarified dealer vs. player comparisons and push logic

  _calculateResultEvent(
    CalculateResultsEvent event,
    Emitter<MultiplayerBlackjackState> emit,
  ) async {
    if (state.roundFinished) {
      print('Round already finished. Skipping _calculateResultEvent.');
      return;
    }

    final dealerIndex = state.allPlayersUid.indexOf('dealer');
    if (dealerIndex == -1 || event.dealtCards.length <= dealerIndex) {
      print('Dealer not found or hand missing.');
      return;
    }

    final dealerHand = event.dealtCards[dealerIndex];
    final dealerValue = calculateHandValue(dealerHand);
    final dealerBusted = dealerValue > 21;

    final Map<String, dynamic> playerResults = {};
    final Map<String, dynamic> playerPayouts = {};

    // Calculate hand values for all players (excluding the dealer)
    final Map<String, int> playerHandValues = {};
    for (int i = 0; i < state.allPlayersUid.length; i++) {
      final uid = state.allPlayersUid[i];
      if ((uid == 'dealer') || state.leftUsers.contains(uid)) continue;

      final hand = event.dealtCards[i];
      final handValue = calculateHandValue(hand);
      playerHandValues[uid] = handValue;
    }

    // Determine max player hand value <= 21 among those who did not bust
    int maxPlayerValue = 0;
    playerHandValues.forEach((uid, value) {
      if (value <= 21 && value > maxPlayerValue) {
        maxPlayerValue = value;
      }
    });

    // Players with this max value (and <= 21)
    List<String> playersWithMaxValue = [];
    playerHandValues.forEach((uid, value) {
      if (value == maxPlayerValue && value <= 21) {
        playersWithMaxValue.add(uid);
      }
    });

    // Assign results and payouts according to clarified rules:

    // Handle dealer busted case:
    if (dealerBusted) {
      // Only players with max hand value win, others lose or busted
      for (final uid in playerHandValues.keys) {
        final value = playerHandValues[uid]!;
        final player = state.playersListing.firstWhere((p) => p.uid == uid);
        final betAmount = double.parse(player.betAmount.toString()).round();

        if (value > 21) {
          playerResults[uid] = 'lose';
          playerPayouts[uid] = 0;
        } else if (playersWithMaxValue.contains(uid)) {
          playerResults[uid] = 'win';
          playerPayouts[uid] = 2 * betAmount;
        } else {
          playerResults[uid] = 'lose';
          playerPayouts[uid] = 0;
        }
      }
      // Dealer busts, so dealer loses
      playerResults['dealer'] = 'lose';
      playerPayouts['dealer'] = 0;
    } else {
      // Dealer did NOT bust
      for (final uid in playerHandValues.keys) {
        final value = playerHandValues[uid]!;
        final player = state.playersListing.firstWhere((p) => p.uid == uid);
        final betAmount = double.parse(player.betAmount.toString()).round();

        if (value > 21) {
          // Player busted
          playerResults[uid] = 'lose';
          playerPayouts[uid] = 0;
        } else if (playersWithMaxValue.contains(uid)) {
          // Player has highest value among players

          // Check special case: if player's value equals dealer's value and player's value is 21
          if (value == dealerValue) {
            // Both player and dealer have the same value
            playerResults[uid] = 'win';
            playerPayouts[uid] = 2 * betAmount;
          } else if (value > dealerValue) {
            // Player wins
            playerResults[uid] = 'win';
            playerPayouts[uid] = 2 * betAmount;
          } else {
            // Player lost to dealer
            playerResults[uid] = 'lose';
            playerPayouts[uid] = 0;
          }
        } else {
          // These players have lower values than max players
          playerResults[uid] = 'lose';
          playerPayouts[uid] = 0;
        }
      }

      // Determine dealer result
      bool anyPlayerWins = playerResults.values.any((res) => res == 'win');

      if (anyPlayerWins) {
        // Dealer loses if players win per rules
        playerResults['dealer'] = 'lose';
        playerPayouts['dealer'] = 0;
      } else {
        // Dealer pushes if no player wins
        playerResults['dealer'] = 'push';
        playerPayouts['dealer'] = 0;
      }
    }

    // Firestore update and session saving unchanged
    try {
      final docRef =
          FirebaseFirestore.instance.collection('games').doc(state.roomCode);
      _turnChangeSubscription?.cancel();

      await docRef.update({
        'playerResults': playerResults,
        'playerPayouts': playerPayouts,
        'lastUpdated': DateTime.now().millisecondsSinceEpoch,
        'roundStatus': 'finished',
      });

      final roomsDocRef = FirebaseFirestore.instance
          .collection(roomCollectionPath)
          .doc(state.roomCode);
      await roomsDocRef.update({
        'status': 'finished',
        'lastUpdated': DateTime.now().millisecondsSinceEpoch,
      });

      await _updateUserCoinBalances(playerPayouts);

      for (final uid in playerResults.keys) {
        print('player Results------->${playerResults}');
        final player = state.playersListing.firstWhere((p) => p.uid == uid);
        final isWin =
            playerResults[uid] == 'win' || playerResults[uid] == 'push';
        final coinsChange = playerPayouts[uid] ?? 0;

        await _saveBlackjackSession(
          userId: player.uid,
          nickname: player.nickname,
          isWin: isWin,
          coinsChange: coinsChange,
          isMultiplayer: true,
          playerIds: state.allPlayersUid,
        );
      }
    } catch (e) {
      print('❌ Firestore update failed: $e');
    }

    emit(state.copyWith(
      dealtCards: event.dealtCards,
      playerResults: playerResults,
      playerPayouts: playerPayouts,
      roundFinished: true,
    ));
  }

  Future<void> _saveBlackjackSession({
    required String userId,
    required String nickname,
    required bool isWin,
    required int coinsChange,
    bool isMultiplayer = true,
    List<dynamic>? playerIds,
  }) async {
    final fireStore = FirebaseFirestore.instance;

    try {
      await fireStore.collection('gameSessions').add({
        'userId': userId,
        'userNickname': nickname,
        'gameType': TYPE_BLACKJACK,
        'result': isWin ? 'win' : 'loss',
        'coinsChange': coinsChange,
        'isMultiplayer': isMultiplayer,
        'players': playerIds ?? [userId],
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 2. Update user stats similarly to your slot machine implementation
      final userDocRef = fireStore.collection('users').doc(userId);
      final userSnapshot = await userDocRef.get();

      if (!userSnapshot.exists) return;

      final userData = userSnapshot.data()!;
      final gameStats =
          Map<String, dynamic>.from(userData['gamesPlayed'] ?? {});
      final currentGame = Map<String, dynamic>.from(gameStats['blackjack'] ??
          {
            'wins': 0,
            'losses': 0,
            'played': 0,
            'coinsEarned': 0,
            'coinsSpent': 0,
          });

      currentGame['played'] += 1;
      if (isWin) {
        currentGame['wins'] += 1;
        currentGame['coinsEarned'] += coinsChange;
      } else {
        currentGame['losses'] += 1;
        currentGame['coinsSpent'] += coinsChange;
      }
      gameStats['blackjack'] = currentGame;

      final updatedData = {
        'coins': (userData['coins'] ?? 0) + coinsChange,
        'totalWins': (userData['totalWins'] ?? 0) + (isWin ? 1 : 0),
        'totalLosses': (userData['totalLosses'] ?? 0) + (!isWin ? 1 : 0),
        'totalGames': (userData['totalGames'] ?? 0) + 1,
        'gamesPlayed': gameStats,
        'leaderboardScore':
            ((userData['leaderboardScore'] ?? 0) + (isWin ? 10 : 0)),
        'lastLogin': FieldValue.serverTimestamp(),
      };

      await userDocRef.update(updatedData);
    } catch (e) {
      print('Error saving blackjack session: $e');
    }
  }

  Future<void> _updateUserCoinBalances(
      Map<String, dynamic> playerPayouts) async {
    // Use a batch to perform multiple updates at once
    final batch = FirebaseFirestore.instance.batch();

    for (final uid in playerPayouts.keys) {
      final payout = playerPayouts[uid];
      if (payout > 0) {
        final userDocRef =
            FirebaseFirestore.instance.collection('users').doc(uid);

        final userDocSnapshot = await userDocRef.get();
        final userData = userDocSnapshot.data();
        final currentCoins = userData?['coins'] as num? ?? 0;

        final newCoins = currentCoins + payout;

        batch.update(userDocRef, {'coins': newCoins});
      }
    }
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

    Map<String, List<String>> _buildCardsMap(List<List<String>> dealt) {
      final map = <String, List<String>>{};
      for (int i = 0; i < state.allPlayersUid.length; i++) {
        map[state.allPlayersUid[i]] = List<String>.from(dealt[i]);
      }
      return map;
    }

    if (dealerHandValue >= 17 && dealerHandValue <= 21) {
      await _updateFirestoreDealtCards(_buildCardsMap(updatedDealtCards));
      await Future.delayed(
          const Duration(milliseconds: 500)); // Small delay before next action
      add(DealerStandEvent(updatedDealtCards));
    } else {
      while (dealerHandValue < 17) {
        await Future.delayed(const Duration(milliseconds: 800));

        final newCard = generateRandomCard();
        updatedDealtCards[dealerIndex].add(newCard);

        dealerHandValue = calculateHandValue(updatedDealtCards[dealerIndex]);

        emit(state.copyWith(dealtCards: updatedDealtCards));
        await Future.delayed(const Duration(
            milliseconds: 300)); // Allow UI to animate card appearance

        add(DealerHitEvent(updatedDealtCards));
        await _updateFirestoreDealtCards(_buildCardsMap(updatedDealtCards));

        await Future.delayed(Duration(seconds: 5)).then((value) {
          _startTurnTimer(state.turnId);
        });
      }

      if (dealerHandValue > 21) {
        await Future.delayed(const Duration(
            milliseconds: 500)); // Smooth pause before next event
        await _updateFirestoreDealtCards(_buildCardsMap(updatedDealtCards));
        add(DealerBustedEvent(updatedDealtCards));
        _turnChangeSubscription?.cancel();
      } else {
        await Future.delayed(const Duration(milliseconds: 500));
        await _updateFirestoreDealtCards(_buildCardsMap(updatedDealtCards));
        add(DealerStandEvent(updatedDealtCards));
        _turnChangeSubscription?.cancel();
      }
    }

    await Future.delayed(const Duration(milliseconds: 500));
    await _updateFirestoreDealtCards(_buildCardsMap(updatedDealtCards));
    if (state.allPlayersUid[1] == currentUserModel.uid ||
        !state.activeUsers.contains(state.allPlayersUid[1])) {
      add(CalculateResultsEvent(updatedDealtCards));
    }
  }

  Future<void> _updateFirestoreDealtCards(updatedDealtCards) async {
    final roomId = state.roomCode;
    await FirebaseFirestore.instance.collection('games').doc(roomId).update({
      'dealtCards': updatedDealtCards,
    });
  }

  _dealerHitEvent(
    DealerHitEvent event,
    Emitter<MultiplayerBlackjackState> emit,
  ) async {
    final roomsDocRef = FirebaseFirestore.instance
        .collection(roomCollectionPath)
        .doc(state.roomCode);
    final docRef =
        FirebaseFirestore.instance.collection('games').doc(state.roomCode);
    await docRef.update({
      'dealerAction': 'hit',
      'dealerHand': event.updatedDealtCards[0],
    });
    await roomsDocRef.update({
      'turnStartTime': DateTime.now().millisecondsSinceEpoch,
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
      'playersBusted': updatedPlayersBusted,
      'dealerHand': event.updatedDealtCards[0],
      'lastUpdated': DateTime.now().millisecondsSinceEpoch,
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
      'standPlayers': updatedPlayersStand,
      'dealerHand': event.updatedDealtCards[0],
      'lastUpdated': DateTime.now().millisecondsSinceEpoch,
    });

    emit(state.copyWith(standPlayers: updatedPlayersStand));
  }

  Future<void> _standTurnEvent(
    StandTurnEvent event,
    Emitter<MultiplayerBlackjackState> emit,
  ) async {
    try {
      print('Entered _standTurnEvent');

      final docRef = FirebaseFirestore.instance
          .collection(roomCollectionPath)
          .doc(state.roomCode);

      // Retrieve the current stand players from Firestore

      await docRef.update({
        'standPlayers':
            FieldValue.arrayUnion([state.playersListing[state.turnId].uid]),
        'lastUpdated': DateTime.now().millisecondsSinceEpoch,
      });
      final docSnapshot = await docRef.get();
      final data = docSnapshot.data() as Map<String, dynamic>;
      final standPlayers = data['standPlayers'];
      print('stand players ----------->${standPlayers}');
      emit(state.copyWith(
        standPlayers: standPlayers,
      ));
      Future.delayed(Duration(milliseconds: 800)).then((onValue) {
        print('statev stand players ----------->${state.standPlayers}');
        rotateTurn();
      });
    } catch (e) {
      print('Error in _standTurnEvent: $e');
    }
  }

  _skipTurnAutomaticTurnTrigger(SkipTurnAutomaticTurnTriggerEvent event,
      Emitter<MultiplayerBlackjackState> emit) async {
    if (state.currentTurn != 'dealer') {
      if ((state.currentTurn == currentUserModel.uid ||
              !state.activeUsers.contains(state.currentTurn)) &&
          state.dealtCards.isNotEmpty) {
        final currentHandValue =
            calculateHandValue(state.dealtCards[state.turnId]);
        if (currentHandValue <= 17) {
          print('entered player hit event');

          add(MultiPlayerHitEvent(state.roomCode));
          emit(state.copyWith(
              turnStartTime: DateTime.now().millisecondsSinceEpoch));

          return;
        } else {
          print('entered player stand event');
          Future.delayed(Duration(seconds: 1)).then((value) {
            add(StandTurnEvent());
          });
        }
      }
    } else {
      print('active user========++>${state.activeUsers}');
      String? firstActiveUserUid =
          state.activeUsers.isNotEmpty ? state.activeUsers.first : null;
      if (currentUserModel.uid == state.allPlayersUid[1]) {
        add(DealerTurnEvent());
      } else if (currentUserModel.uid == firstActiveUserUid &&
          !state.activeUsers.contains(state.allPlayersUid[1])) {
        add(DealerTurnEvent());
      }
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
    if (state.standPlayers.contains(state.currentTurn)) {
      return;
    }
    if (state.leftUsers.contains(state.currentTurn)) {
      return;
    }

    if (state.turnId == -1) {
      print('Error: Player ID ${state.currentTurn} not found.');
      return;
    }

    if (state.currentTurn == currentUserModel.uid ||
        !state.activeUsers.contains(state.currentTurn)) {
      final newCard = generateRandomCard();
      final updatedDealtCards = List<List<dynamic>>.from(state.dealtCards);
      updatedDealtCards[state.turnId].add(newCard);

      final cardsMap = <String, List<String>>{};
      for (int i = 0; i < state.allPlayersUid.length; i++) {
        cardsMap[state.allPlayersUid[i]] =
            List<String>.from(updatedDealtCards[i]);
      }
      final int totalValue =
          calculateHandValue(updatedDealtCards[state.turnId]);
      final updatedPlayersBusted =
          List<dynamic>.from(state.playersBusted ?? []);

      bool busted = false;
      bool autoStand = false;
      if (totalValue > 21) {
        if (!updatedPlayersBusted.contains(state.currentTurn)) {
          updatedPlayersBusted.add(state.currentTurn);
        }
        busted = true;
      } else {
        updatedPlayersBusted.remove(state.currentTurn);
      }
      if (totalValue >= 21) {
        autoStand = true; // Trigger stand immediately
      }

      final docRef =
          FirebaseFirestore.instance.collection('games').doc(event.roomCode);

      final roomsDocRef = FirebaseFirestore.instance
          .collection(roomCollectionPath)
          .doc(event.roomCode);

      await roomsDocRef.update({
        'turnStartTime': DateTime.now().millisecondsSinceEpoch,
      });

      await docRef.update({
        'dealtCards': cardsMap,
        'playersBusted': updatedPlayersBusted,
        'lastUpdated': DateTime.now().millisecondsSinceEpoch,
      });

      emit(state.copyWith(
        dealtCards: updatedDealtCards,
        playersBusted: updatedPlayersBusted,
      ));
      print('--------------__>${totalValue}');
      if (busted) {
        print(
            'after hit event rotating........................>>>>>>>>>>>>>>>>.');
        Future.delayed(Duration(milliseconds: 800)).then((onValue) {
          rotateTurn();
        });
      } else if (autoStand || totalValue > 17) {
        print('Player has 21. Auto-standing...');
        Future.delayed((Duration(seconds: 15))).then((onValue) {
          print('STANd TURN TRIGGERED');
          add(StandTurnEvent());
        });
      } else {
        print('entered this section');
        /*    Future.delayed((Duration(seconds: 15))).then((onValue) {
          print('HIT TURN TRIGGERED');
          add(MultiPlayerHitEvent(state.roomCode));
        });*/
      }
    } else {
      print('entered else 4');
    }
  }

  StreamSubscription<QuerySnapshot>? _chatStream;

  var cTurnId;
  StreamSubscription<DocumentSnapshot>? _turnChangeSubscription;

  void _listenToTurnChanges(String roomId) {
    print('turn stream started');
    Timer? debounce;
    try {
      _turnChangeSubscription = FirebaseFirestore.instance
          .collection(roomCollectionPath)
          .doc(roomId)
          .snapshots()
          .listen((snapshot) {
        debounce?.cancel();

        debounce = Timer(const Duration(milliseconds: 500), () {
          final data = snapshot.data();
          if (data != null) {
            cTurnId = data['currentTurn'];
            final newTurnId = data['turnId'];
            final newTurnStartTime = data['turnStartTime'];
            final hostId = data['host'];

            emit(state.copyWith(standPlayers: data['standPlayers']));
            if (data['status'] != "finished") {
              Future.delayed(Duration(milliseconds: 400)).then((onValue) {
                add(UpdateTurnEvent(
                  currentTurn: cTurnId,
                  hostId: hostId['uid'],
                  turnStartTime: newTurnStartTime,
                  turnId: newTurnId,
                ));
              });
            }
          }
        });
      }, onError: (e) {
        print('Stream error: $e');
      });
    } catch (e, st) {}
  }

  bool _isTurnBeingProcessed = false;

  Future<void> _updateCurrentTurnEvent(
    UpdateTurnEvent event,
    Emitter<MultiplayerBlackjackState> emit,
  ) async {
    print('update event triggered');
    if (_isTurnBeingProcessed) {
      print('Turn change already being processed. Ignoring...');
      return;
    }

    _isTurnBeingProcessed = true;

    // Emit new state
    emit(state.copyWith(
      currentTurn: event.currentTurn,
      turnId: event.turnId,
      hostUid: event.hostId,
      turnStartTime: event.turnStartTime,
    ));
    // Start the turn timer

    final isCurrentUserTurn = event.currentTurn == currentUserModel.uid;

    final isDealerTurn = event.currentTurn == 'dealer';

    final isPlayerActive = state.activeUsers.contains(event.currentTurn);

    final hasNotStood = !state.standPlayers.contains(event.currentTurn);
    final hasNotLeftGame = !state.leftUsers.contains(event.currentTurn);

    final hasNotBusted = !state.playersBusted.contains(event.currentTurn);

    if ((isCurrentUserTurn || isDealerTurn || isPlayerActive) &&
        hasNotStood &&
        hasNotBusted &&
        hasNotLeftGame) {
      // For current user, dealer, or active players: start normal turn timer

      _startTurnTimer(event.turnId);
    } else if (!isPlayerActive &&
        hasNotStood &&
        hasNotBusted &&
        hasNotLeftGame) {
      // Player is not active but their turn is current and they have not stood or busted

      // Automatically trigger a hit event for this inactive player after a short delay

      Future.delayed(const Duration(seconds: 1), () {
        _startTurnTimer(event.turnId);
      });
    } else {
      // Player not active or already stood/busted - no action or timer
      // rotateTurn();
      print('No timer or automated action — player inactive or turn complete');
    }

    _isTurnBeingProcessed = false;
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
    customLoader.show(event.context);
    try {
      final activePlayersUid = event.playersUid
          .where((uid) => !state.leftUsers.contains(uid))
          .toList();
      if (state.allPlayersUid[1] == currentUserModel.uid) {
        await firebaseRepository.saveDealingCardsToFireStore(
            state.roomCode, activePlayersUid);
        _listenToTurnChanges(state.roomCode);
        customLoader.hide();
        return;
      }
      customLoader.hide();
      customLoader.hide();
      _listenToTurnChanges(state.roomCode);
    } catch (error) {
      print('Error saving dealing cards: $error');
    }
  }

  Future<void> _startGamingStreamEvent(StartGameStreamEvent event,
      Emitter<MultiplayerBlackjackState> emit) async {
    print('game stream started');
    final stream = FirebaseFirestore.instance
        .collection('games')
        .doc(event.roomCode)
        .snapshots();

    // Start listening to the game stream
    await _listenToGameStream(stream, emit, event.context);
  }

  bool _isDialogShown = false;

  Future<void> _listenToGameStream(Stream<DocumentSnapshot> stream,
      Emitter<MultiplayerBlackjackState> emit, context) async {
    await for (final doc in stream) {
      if (!doc.exists) continue;
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) continue;

      final dealtCardsMap = data['dealtCards'];
      List<UserDataModel> playerStreamingListing = [];
      playerStreamingListing.clear();
      playerStreamingListing = data['players'] != null
          ? (data['players'] as List<dynamic>)
              .map((e) => UserDataModel(
                    nickname: e['nickname'] ?? "",
                    email: e['email'] ?? "",
                    uid: e['uid'] ?? "",
                    betAmount: e['betAmount'] ?? 0.0,
                  ))
              .toList()
          : [];
      if (dealtCardsMap != null &&
          allUsersHavePlacedBets(playerStreamingListing, 'dealer')) {
        final cardsList = state.allPlayersUid.map<List<String>>((uid) {
          final raw = dealtCardsMap[uid];
          return (raw != null && raw is List<dynamic>)
              ? raw.cast<String>()
              : <String>[];
        }).toList();
        if (!listEquals(cardsList, state.dealtCards)) {
          emit(state.copyWith(
              dealtCards: cardsList,
              activeUsers: data['activeUsers'],
              leftUsers: data['leftUsers'],
              playerPayouts: data['playerPayouts'],
              playerResults: data['playerResults'],
              roundFinished: data['roundStatus'] == "finished" ? true : false,
              allPlayersPlacedBet: data['allPlayersPlacedBet'] ?? false,
              playersBusted: data['playersBusted'] ?? [],
              playersListing: playerStreamingListing));
        }
      } else {
        if (allUsersHavePlacedBets(playerStreamingListing, 'dealer')) {
          doc.reference.update({"allPlayersPlacedBet": true});
          emit(state.copyWith(
              allPlayersPlacedBet: true,
              activeUsers: data['activeUsers'],
              leftUsers: data['leftUsers'],
              playerPayouts: data['playerPayouts'],
              playerResults: data['playerResults'],
              roundFinished: data['roundStatus'] == "finished" ? true : false,
              playersBusted: data['playersBusted'] ?? [],
              playersListing: playerStreamingListing));
          customLoader.hide();
        } else {
          var currentIndex = playerStreamingListing
              .indexWhere((e) => e.uid == currentUserModel.uid);
          var isCurrentBetAdded = int.parse(playerStreamingListing[currentIndex]
                  .betAmount
                  .toString()
                  .split(".")[0]) >
              0.0;

          if (!isCurrentBetAdded) if (!_isDialogShown) {
            _isDialogShown = true;
            customLoader.hide();
            _checkPlayerPlacedBet(context);
          } else {
            customLoader.hide();
            emit(state.copyWith(
                allPlayersPlacedBet: data['allPlayersPlacedBet'] ?? false,
                leftUsers: data['leftUsers'],
                playerPayouts: data['playerPayouts'],
                playerResults: data['playerResults'],
                roundFinished: data['roundStatus'] == "finished" ? true : false,
                playersListing: playerStreamingListing));
          }
          customLoader.hide();
        }
      }
    }
  }

  bool _isDealingInProgress = false;

  Future<void> _startDealing(
      StartDealingEvent event, Emitter<MultiplayerBlackjackState> emit) async {
    if (_isDealingInProgress) return;
    _isDealingInProgress = true;

    try {
      if (state.isGameActive) {
        print('Game is already in progress. Cannot deal cards again.');
        emit(state.copyWith(dealtCards: state.dealtCards));
        return;
      }

      if (state.dealtCards.isEmpty || state.dealtCards[0].isEmpty) {
        print('Warning: dealtCards is empty, cannot start dealing.');
        return;
      }
    } finally {
      _isDealingInProgress = false;
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

  dynamic addingSecDuration;

  void _startTurnTimer(int turnId) {
    turnTimer?.cancel();
    addingSecDuration = 15.0;
    add(UpdateRemainingTimeInSeconds(15.0));
    if (addingSecDuration == 15.0) {
      add(UpdateTimerCompletionStatus(false));
    }

    print('restarting timer----------');
    turnTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final turnStartTimeMillis = state.turnStartTime.runtimeType == Timestamp
          ? state.turnStartTime.seconds * 1000
          : state.turnStartTime;
      final DateTime turnStartTime =
          DateTime.fromMillisecondsSinceEpoch(turnStartTimeMillis);

      final int totalTurnDuration = 15;
      final int elapsedTime = DateTime.now().millisecondsSinceEpoch -
          turnStartTime.millisecondsSinceEpoch;

      final double remainingTimeInMilliseconds =
          (totalTurnDuration * 1000 - elapsedTime)
              .clamp(0, totalTurnDuration * 1000)
              .toDouble();
      final double remainingTimeInSeconds = remainingTimeInMilliseconds / 1000;
      addingSecDuration = 15 - remainingTimeInSeconds;
      add(UpdateRemainingTimeInSeconds(totalTurnDuration - addingSecDuration));
      if (addingSecDuration == 15.0) {
        print('Timer completed');
        add(UpdateTimerCompletionStatus(true)); // Set completion status
        timer.cancel();
      }
      if (addingSecDuration == 15.0) {
        if ((state.currentTurn == currentUserModel.uid ||
                state.currentTurn == 'dealer' ||
                !state.activeUsers.contains(state.currentTurn)) &&
            !state.roundFinished) {
          timer.cancel();
          add(SkipTurnAutomaticTurnTriggerEvent());
        } else {
          timer.cancel();
        }
      }
    });
  }

  void rotateTurn() async {
    print('Rotating turn...');

    final docRef = FirebaseFirestore.instance
        .collection(roomCollectionPath)
        .doc(state.roomCode);
    final doc = await docRef.get();

    if (!doc.exists) return;

    final data = doc.data();
    if (data == null) return;

    final currentTurn = data['currentTurn'];
    final allPlayers = List<String>.from(state.allPlayersUid);
    final playersStood = List<String>.from(state.standPlayers ?? []);
    final playersBusted = List<String>.from(state.playersBusted ?? []);
    final playersLeft = List<String>.from(state.leftUsers ?? []);

    print('All players: $allPlayers');
    print('Players who stood: $playersStood');
    print('Players who busted: $playersBusted');

    // Find the index of the current player
    final currentIndex = allPlayers.indexOf(currentTurn);
    int nextIndex = (currentIndex + 1) % allPlayers.length;

    // Loop to find the next active player
    for (int i = 0; i < allPlayers.length; i++) {
      final nextPlayer = allPlayers[nextIndex];

      // Check if the next player is active
      if (nextPlayer != 'dealer' &&
          !playersBusted.contains(nextPlayer) &&
          !playersStood.contains(nextPlayer) &&
          !playersLeft.contains(nextPlayer)) {
        await docRef.update({
          'currentTurn': nextPlayer,
          'turnStartTime': DateTime.now().millisecondsSinceEpoch,
          'turnId': nextIndex,
        });
        print('Next turn goes to: $nextPlayer');
        return;
      }

      // Move to the next index
      nextIndex = (nextIndex + 1) % allPlayers.length;
    }

    // If no active player is found, assign the turn to the dealer
    print('No eligible player found in rotation. Assigning dealer.');
    await docRef.update({
      'currentTurn': 'dealer',
      'turnStartTime': DateTime.now().millisecondsSinceEpoch,
      'turnId': 0,
    });
  }

  @override
  Future<void> close() {
    _turnChangeSubscription?.cancel();
    turnTimer?.cancel();
    return super.close();
  }
}
