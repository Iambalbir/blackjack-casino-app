import 'package:app/app/modules/games/screens/rules_screen.dart';
import 'package:app/core/utils/assets/sound_assets.dart';
import 'package:app/core/utils/dialogs/chat_messages_dialog.dart';
import 'package:app/core/utils/dialogs/show_leader_board_dialog.dart';
import 'package:app/core/utils/widgets/custom_gaming_drawer.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import '../../../../export_file.dart';

class MultiPlayerBlackjackGameScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final bloc = BlocProvider(create: (context) => MultiPlayerBlackjackBloc());

  MultiPlayerBlackjackGameScreen({required this.data});

  @override
  _MultiPlayerBlackjackGameScreenState createState() =>
      _MultiPlayerBlackjackGameScreenState();
}

class _MultiPlayerBlackjackGameScreenState
    extends State<MultiPlayerBlackjackGameScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  List<List<AnimationController>> controllers = [];
  List<List<Animation<Offset>>> animations = [];
  dynamic blocState;
  bool _initialEventDispatched = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_initialEventDispatched) {
        _bloc = context.read<MultiPlayerBlackjackBloc>();
        context
            .read<MultiPlayerBlackjackBloc>()
            .add(MultiPlayerBlackjackInitialEvent(widget.data, context));
        _initialEventDispatched = true;
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        print('application paused');
        // Handle app paused
        context.read<MultiPlayerBlackjackBloc>().add(UserOfflineEvent());
        break;

      case AppLifecycleState.resumed:
        // Handle app resumed
        context
            .read<MultiPlayerBlackjackBloc>()
            .add(CheckPlayerStatus(isAppResumed: true));
        break;

      case AppLifecycleState.inactive:
        // Handle app inactive

        break;

      case AppLifecycleState.detached:
        print('application detached');

        context.read<MultiPlayerBlackjackBloc>().add(UserOfflineEvent());

        break;
      case AppLifecycleState.hidden:
      // TODO: Handle this case.
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<MultiPlayerBlackjackBloc>()
          .add(UpdateTableDimensions(context));

      context.read<MultiPlayerBlackjackBloc>().add(UpdateHolePositionsEvent());
    });
  }

  Future<void> _initializeOrExtendAnimations(
      List<dynamic> dealtCardsState) async {
    if (controllers.isEmpty || animations.isEmpty) {
      controllers.clear();
      animations.clear();

      for (int i = 0; i < dealtCardsState.length; i++) {
        List<AnimationController> playerControllers = [];
        List<Animation<Offset>> playerAnimations = [];

        for (int j = 0; j < dealtCardsState[i].length; j++) {
          final controller = AnimationController(
            vsync: this,
            duration: Duration(milliseconds: 900),
          );

          final animation = Tween<Offset>(
            begin: blocState.cardSource,
            end: context
                    .read<MultiPlayerBlackjackBloc>()
                    .state
                    .holePositions[i] +
                Offset(j * 22.0, -60),
          ).animate(
            CurvedAnimation(parent: controller, curve: Curves.easeInOut),
          );
          print('hitted----');
          _playDealCardSound();
          playerControllers.add(controller);
          playerAnimations.add(animation);
        }

        controllers.add(playerControllers);
        animations.add(playerAnimations);
      }
    } else {
      for (int i = 0; i < dealtCardsState.length; i++) {
        int newCardsCount = dealtCardsState[i].length - controllers[i].length;
        if (newCardsCount > 0) {
          for (int j = controllers[i].length;
              j < dealtCardsState[i].length;
              j++) {
            final controller = AnimationController(
              vsync: this,
              duration: Duration(milliseconds: 800),
            );
            final animation = Tween<Offset>(
              begin: blocState.cardSource,
              end: context
                      .read<MultiPlayerBlackjackBloc>()
                      .state
                      .holePositions[i] +
                  Offset(j * 22.0, -60),
            ).animate(
                CurvedAnimation(parent: controller, curve: Curves.easeInOut));
            _playDealCardSound(isPlayLoop: false);
            controllers[i].add(controller);
            animations[i].add(animation);
          }
        }
      }
    }
  }

  Future<void> _animateNewCards(
      List<dynamic> dealtCardsState, MultiplayerBlackjackState state) async {
    for (int playerIndex = 0;
        playerIndex < dealtCardsState.length;
        playerIndex++) {
      for (int cardIndex = 0;
          cardIndex < dealtCardsState[playerIndex].length;
          cardIndex++) {
        if (cardIndex >= controllers[playerIndex].length) continue;

        final controller = controllers[playerIndex][cardIndex];

        if (controller.status == AnimationStatus.dismissed) {
          await Future.delayed(Duration(milliseconds: 300));
          controller.forward();
        }
      }
    }
  }

  final AudioPlayer _audioPlayer = AudioPlayer();

  _playDealCardSound({isPlayLoop = true}) async {
    print('called=====================');
    if (isPlayLoop) {
      _audioPlayer.setReleaseMode(ReleaseMode.loop);
      /*if (_bloc.state.currentTurn != null || _bloc.state.currentTurn != '') {
        _audioPlayer.setReleaseMode(ReleaseMode.stop);
      }*/
    } else {
      _audioPlayer.setReleaseMode(ReleaseMode.stop);
    }

    await _audioPlayer.play(AssetSource(cardDealingSound));
  }

  Future<bool> _animateCardsToOpposite(MultiplayerBlackjackState state) async {
    final Offset oppositeOffset = Offset(
      state.cardSource.dx + 1000,
      state.cardSource.dy - 500,
    );
    for (int i = 0; i < state.playersListing.length; i++) {
      for (int j = 0; j < controllers[i].length; j++) {
        controllers[i][j].dispose();
        await Future.delayed(Duration(milliseconds: 300));
        final controller = AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 1200),
        );

        final animation = Tween<Offset>(
          begin:
              context.read<MultiPlayerBlackjackBloc>().state.holePositions[i] +
                  Offset(j * 22.0, -60),
          end: oppositeOffset,
        ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));

        controllers[i][j] = controller;
        animations[i][j] = animation;

        // controller.addListener(() => setState(() {}));
      }
    }

    for (int i = 0;
        i <
            context
                .read<MultiPlayerBlackjackBloc>()
                .state
                .playersListing
                .length;
        i++) {
      for (int j = 0; j < controllers[i].length; j++) {
        controllers[i][j].forward();
      }
    }
    return true;
  }

  bool _hasShownResultDialog = false;
  bool isInitialised = false;
  bool isTurnStreamInitialised = false;
  late final MultiPlayerBlackjackBloc _bloc;
  List<dynamic> _previousDealtCards = [];
  bool _isDealingCards = false;

  void _showVictory(BuildContext context) {
    confettiOverlay.show(context);

    Future.delayed(Duration(seconds: 6), () {
      confettiOverlay.hide();
      Navigator.pop(context);
    });
  }

  void _showLoose(BuildContext context) {
    looseOverlay.show(context);

    Future.delayed(Duration(seconds: 6), () {
      looseOverlay.hide();
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MultiPlayerBlackjackBloc>();

    return BlocBuilder<MultiPlayerBlackjackBloc, MultiplayerBlackjackState>(
      bloc: context.read<MultiPlayerBlackjackBloc>(),
      builder: (context, state) {
        return Scaffold(
            key: scaffoldKey,
            endDrawer: CustomGamingDrawer(
              onOptionTap: (option) {
                if (option == 'rules') {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: kBackground,
                          content: RulesScreen(),
                        );
                      });
                } else if (option == 'leave') {
                  _exitGameHit(state, title: "Leave");
                }
              },
            ),
            body: BlocConsumer<MultiPlayerBlackjackBloc,
                MultiplayerBlackjackState>(
              listener: (context, state) async {
                bool shouldPlaySound = false;

                // Compare previous and current dealtCards to detect new cards

                final currentDealt = state.dealtCards;

                if (_previousDealtCards == null ||
                    _previousDealtCards!.isEmpty) {
                  shouldPlaySound = currentDealt.isNotEmpty;
                } else {
                  for (int i = 0; i < currentDealt.length; i++) {
                    final prevCount = i < _previousDealtCards!.length
                        ? _previousDealtCards![i].length
                        : 0;

                    final currentCount = currentDealt[i].length;
                    if (currentCount > prevCount) {
                      shouldPlaySound = true;

                      break;
                    }
                  }
                }

                _previousDealtCards = currentDealt
                    .map((playerCards) => List.from(playerCards))
                    .toList();

                if (state.allPlayersPlacedBet &&
                    !isInitialised &&
                    state.allPlayersUid[1] != currentUserModel.uid &&
                    state.dealtCards.isNotEmpty) {
                  isInitialised = true;
                  context.read<MultiPlayerBlackjackBloc>().add(
                      SaveDealingCardToFireStoreEvent(
                          state.allPlayersUid, context));
                }

                if (widget.data['roomType'] == TYPE_SINGLE_PLAYER &&
                    state.allPlayersUid[1] == currentUserModel.uid &&
                    state.isGameActive &&
                    !isTurnStreamInitialised &&
                    state.dealtCards.isNotEmpty) {
                  isTurnStreamInitialised = true;
                  context.read<MultiPlayerBlackjackBloc>().add(
                      SaveDealingCardToFireStoreEvent(
                          state.allPlayersUid, context));
                }

                if (shouldPlaySound && !_isDealingCards) {
                  _isDealingCards =
                      true; // Set the flag to indicate dealing has started
                  // Start playing sound for dealing
                  if (state.dealtCards.isNotEmpty &&
                      state.dealtCards[0].isNotEmpty) {
                    await _initializeOrExtendAnimations(state.dealtCards)
                        .then((value) {});
                    await _animateNewCards(state.dealtCards, state);

                    for (int playerIndex = 0;
                        playerIndex < state.playersListing.length;
                        playerIndex++) {
                      final cardsCount = state.dealtCards[playerIndex].length;
                      for (int cardIndex = 0;
                          cardIndex < cardsCount;
                          cardIndex++) {
                        await Future.delayed(Duration(milliseconds: 500));
                        if (playerIndex < controllers.length &&
                            cardIndex < controllers[playerIndex].length) {
                          await _animateNewCards(state.dealtCards, state);

                          controllers[playerIndex][cardIndex].forward();
                        } else {
                          print(
                              'Controller missing for player $playerIndex card $cardIndex');
                        }
                      }
                    }
                    _audioPlayer.stop();
                  }
                }

                _isDealingCards = false;
                if (state.roundFinished && !_hasShownResultDialog) {
                  if (state.playerResults[currentUserModel.uid] == "win") {
                    _showVictory(context);
                    _audioPlayer.setReleaseMode(ReleaseMode.stop);
                    _audioPlayer.play(AssetSource(victorySound));
                  } else if (state.playerResults[currentUserModel.uid] ==
                      "lose") {
                    _showLoose(context);
                    _audioPlayer.play(AssetSource(loseSound));
                  }

                  Future.delayed(Duration(seconds: 5)).then((onValue) {
                    _audioPlayer.stop();
                  });
                  _hasShownResultDialog = true;
                  /* final playerNames = {
                    for (var player in state.playersListing)
                      player.uid: player.nickname
                  };
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (_) => LeaderboardDialog(
                      playerResults: state.playerResults,
                      playerPayouts: state.playerPayouts,
                      playerNames: playerNames,
                    ),
                  );*/
                }

                // Reset the flag if a new round starts, for example:
                if (!state.roundFinished) {
                  _hasShownResultDialog = false;
                }
              },
              builder: (context, state) {
                blocState = state;
                final double holeRadius = state.tableHeight * 0.038;
                final isBusted = state.playersBusted.length != 0
                    ? state.playersBusted
                        .contains(state.allPlayersUid[state.turnId])
                    : false;

                return WillPopScope(
                  onWillPop: () async {
                    if (state.playersListing.isNotEmpty) {
                      var currentUserIndex = state.playersListing
                          .indexWhere((e) => e.uid == currentUserModel.uid);
                      if ((!state.roundFinished) &&
                          state.playersListing[currentUserIndex].betAmount !=
                              0.0) {
                        final shouldExit = await showDialog<bool>(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            backgroundColor: Colors.white,
                            contentPadding: EdgeInsets.all(20),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.warning_amber_rounded,
                                    color: Colors.orange, size: 60),
                                SizedBox(height: 16),
                                Text(
                                  "Exit Game?",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 12),
                                Text(
                                  "You have already placed bet. Exiting now will cost you half your bet (${(int.parse(state.playersListing[currentUserIndex].betAmount) ?? 0) ~/ 2} chips). Do you want to exit?",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black87),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: Text("Cancel"),
                                    ),
                                    SizedBox(width: 12),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange,
                                        foregroundColor: Colors.white,
                                      ),
                                      onPressed: () {
                                        bankAmount.value -= int.parse(state
                                                .playersListing[
                                                    currentUserIndex]
                                                .betAmount) ~/
                                            2;
                                        _bloc.add(LeaveGameEvent(int.parse(state
                                                .playersListing[
                                                    currentUserIndex]
                                                .betAmount) ~/
                                            2));
                                        Navigator.of(context).pop(true);
                                      },
                                      child: Text("Exit Anyway"),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                        return shouldExit ?? false;
                      }
                    }
                    return true;
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(iconTableBg), fit: BoxFit.cover)),
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: state.tableWidth,
                            height: state.tableHeight,
                            decoration: BoxDecoration(
                              color: Colors.brown[500],
                              boxShadow: [
                                BoxShadow(
                                  color: kBackground,
                                  spreadRadius: radius_2,
                                  blurRadius: radius_2,
                                )
                              ],
                              borderRadius:
                                  BorderRadius.circular(state.borderRadius),
                              border: Border.all(
                                  color: Colors.white70, width: width_4),
                            ),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  margin: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(iconTableBgInner),
                                        fit: BoxFit.cover),
                                    borderRadius: BorderRadius.circular(
                                        state.borderRadius * 0.9),
                                    border: Border.all(
                                        color: Colors.greenAccent.shade100,
                                        width: 3),
                                  ),
                                ),
                                if (state.playersListing.isNotEmpty)
                                  ...List.generate(state.playersListing.length,
                                      (index) {
                                    final pos = state.holePositions[index];

                                    return Positioned(
                                      left: pos.dx,
                                      top: pos.dy,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildPlayerView(
                                              holeRadius, index, state, bloc),
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: margin_4),
                                            padding: EdgeInsets.all(margin_4),
                                            decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.white,
                                                      spreadRadius: radius_1,
                                                      blurRadius: radius_2)
                                                ],
                                                color: kBackground,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        radius_4)),
                                            child: TextView(
                                                textAlign: TextAlign.center,
                                                text:
                                                    state.playersListing[index]
                                                                .nickname ==
                                                            currentUserModel
                                                                .nickname
                                                        ? " You  "
                                                        : state
                                                                .playersListing[
                                                                    index]
                                                                .nickname ??
                                                            "",
                                                textStyle:
                                                    textStyleBodySmall(context)
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white)),
                                          ),
                                          index == 0 ||
                                                  state.leftUsers.contains(state
                                                      .playersListing[index]
                                                      .uid)
                                              ? SizedBox()
                                              : Container(
                                                  padding:
                                                      EdgeInsets.all(margin_4),
                                                  decoration: BoxDecoration(
                                                      color: kBackground,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              radius_4)),
                                                  child: index ==
                                                          0 /*|| state.leftUsers.contains(state.playersListing[index].uid)*/
                                                      ? SizedBox()
                                                      : TextView(
                                                          text:
                                                              "💰 ${state.playersListing[index].betAmount}",
                                                          textStyle:
                                                              textStyleBodySmall(
                                                                  context)),
                                                )
                                        ],
                                      ),
                                    );
                                  }),
                              ],
                            ),
                          ),
                          Positioned(
                            left: state.cardSource.dx,
                            top: state.cardSource.dy + 30.h,
                            child: Container(
                              width: width_42,
                              height: height_55,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.pink, Colors.blue],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: radius_2, color: Colors.white)
                                ],
                              ),
                            ),
                          ),
                          if (animations.isNotEmpty)
                            ...List.generate(state.playersListing.length,
                                (index) {
                              double width =
                                  MediaQuery.of(context).size.width * .74;
                              double height =
                                  MediaQuery.of(context).size.height * .31;

                              return Stack(
                                children: List.generate(
                                    state.dealtCards[index].length,
                                    (cardIndex) {
                                  return AnimatedBuilder(
                                    animation: animations[index].length >
                                            cardIndex
                                        ? animations[index][cardIndex]
                                        : AlwaysStoppedAnimation(Offset.zero),
                                    builder: (context, child) {
                                      final offset = animations[index].length >
                                              cardIndex
                                          ? animations[index][cardIndex].value
                                          : Offset.zero;
                                      return Positioned(
                                        left: offset.dx + 32.w,
                                        top: offset.dy + 110.h,
                                        child: cardIndex == 1 &&
                                                state.allPlayersUid[index] ==
                                                    'dealer' &&
                                                state.turnId != 0
                                            ? FaceDownCard(
                                                width: width,
                                                height: height,
                                              )
                                            : _buildCardWidget(
                                                cardLabel:
                                                    state.dealtCards[index]
                                                        [cardIndex]),
                                      );
                                    },
                                  );
                                }),
                              );
                            }),
                          state.currentTurn != currentUserModel.uid &&
                                  (!isBusted ||
                                      state.roundFinished ||
                                      state.standPlayers
                                          .contains(state.currentTurn) ||
                                      state.playersBusted
                                          .contains(state.currentTurn) ||
                                      state.leftUsers
                                          .contains(state.currentTurn))
                              ? SizedBox()
                              : Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: margin_20,
                                        vertical: margin_25),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.greenAccent,
                                        border: Border.all(
                                            color: kBackground, width: width_2),
                                        borderRadius:
                                            BorderRadius.circular(radius_10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.deepPurpleAccent
                                                .withOpacity(0.6),
                                            blurRadius: 8,
                                            offset: Offset(0, 3),
                                          )
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          _buildActionButton(
                                              Icons.add, 'Hit', state),
                                          _buildActionButton(
                                              Icons.stop, 'Stand', state),
                                          _buildActionButton(
                                              Icons.flag, 'Surrender', state),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                          Align(
                              alignment: Alignment.topRight,
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      scaffoldKey.currentState!.openEndDrawer();
                                    },
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            top: margin_35, right: margin_20),
                                        padding: EdgeInsets.all(margin_10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(radius_8),
                                          color: kBackground,
                                        ),
                                        child: Icon(Icons.menu)),
                                  ),
                                  widget.data['roomType'] == TYPE_SINGLE_PLAYER
                                      ? SizedBox()
                                      : InkWell(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (_) => ChatDialog(
                                                bloc: _bloc,
                                                onSend: (message) {
                                                  bloc.add(SendChatMessageEvent(
                                                      message));
                                                },
                                              ),
                                            );
                                          },
                                          child: Container(
                                              margin: EdgeInsets.only(
                                                  top: margin_5,
                                                  right: margin_20),
                                              padding:
                                                  EdgeInsets.all(margin_10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        radius_8),
                                                color: kBackground,
                                              ),
                                              child: Icon(Icons.messenger)),
                                        ),
                                ],
                              )),
                          state.allPlayersPlacedBet &&
                                  state.dealtCards.isEmpty &&
                                  widget.data['players'][0]['uid'] ==
                                      currentUserModel.uid
                              ? Positioned(
                                  bottom: 200.h,
                                  child: MaterialButtonWidget(
                                    buttonRadius: radius_10,
                                    minWidth:
                                        MediaQuery.sizeOf(context).width * .5,
                                    borderColor: Colors.white,
                                    onPressed: () async {
                                      isTurnStreamInitialised = true;
                                      final roomRef = FirebaseFirestore.instance
                                          .collection(roomCollectionPath)
                                          .doc(widget.data['roomCode']);
                                      await roomRef.update({
                                        'status': 'active',
                                        'currentTurn': state.allPlayersUid[1],
                                        'turnStartTime': DateTime.now()
                                            .millisecondsSinceEpoch,
                                        'turnId': 1,
                                      });
                                      Future.delayed(
                                              Duration(milliseconds: 800))
                                          .then((onValue) {
                                        context
                                            .read<MultiPlayerBlackjackBloc>()
                                            .add(
                                                SaveDealingCardToFireStoreEvent(
                                                    state.allPlayersUid,
                                                    context));
                                      });
                                    },
                                    buttonText: "DEAL CARDS",
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ));
      },
    );
  }

  Widget _buildPlayerView(
      double radius, int index, MultiplayerBlackjackState state, bloc) {
    final bool isDealer = index == 0;
    final bool isCurrentTurn = state.allPlayersUid[index] == state.currentTurn;
    final String uid = state.allPlayersUid[index];

    final isBusted = state.playersBusted.contains(uid);
    final result = state.playerResults[uid];
    final bool roundFinished = state.roundFinished;

    final key =
        ValueKey('---_${state.currentTurn}-----_${state.isTimerCompleted}');

    return TweenAnimationBuilder<double>(
      key: key,
      tween: Tween(begin: 1.0, end: 0.0),
      duration: Duration(seconds: state.remainingTimeInSeconds.toInt()),
      builder: (context, value, child) {
        return state.leftUsers.contains(state.playersListing[index].uid)
            ? Container(
                padding: EdgeInsets.all(margin_5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(radius_5)),
                child: TextView(
                    text: "Player left the game!",
                    textStyle: textStyleBodySmall(context).copyWith(
                        fontSize: font_10, fontWeight: FontWeight.bold)),
              )
            : state.playersListing[index].betAmount != null &&
                    double.parse(
                            state.playersListing[index].betAmount.toString()) ==
                        0.0 &&
                    index != 0
                ? Container(
                    padding: EdgeInsets.all(margin_5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(radius_8)),
                    child: TextView(
                        text: "Waiting for bet!",
                        textStyle: textStyleBodySmall(context).copyWith(
                            fontSize: font_8, fontWeight: FontWeight.bold)),
                  )
                : Stack(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          if (isCurrentTurn && !isBusted && !roundFinished)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: SizedBox(
                                width: radius * 2 + 10,
                                height: radius * 2 + 10,
                                child: CircularProgressIndicator(
                                  value: value,
                                  strokeWidth: width_4,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    isDealer ? Colors.blue : Colors.deepPurple,
                                  ),
                                  backgroundColor: Colors.grey[500],
                                ),
                              ),
                            ),
                          Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: radius * 2,
                                    height: radius * 2,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isDealer
                                          ? Colors.red[900]
                                          : Colors.black,
                                      border: Border.all(
                                          color: Colors.grey, width: 3),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black87,
                                          blurRadius: 2,
                                          spreadRadius: 2,
                                          offset: Offset(1, 1),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: TextView(
                                        text: state.dealtCards.length > index &&
                                                state.dealtCards[index]
                                                    .isNotEmpty
                                            ? '${calculateHandValue(state.dealtCards[index])}'
                                            : "",
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: radius * 0.8,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (roundFinished && result != null)
                                    SizedBox(
                                      width: width_5,
                                    ),
                                  if (roundFinished && result != null)
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 4, horizontal: margin_5),
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.white,
                                              blurRadius: radius_1)
                                        ],
                                        color: result == 'win'
                                            ? Colors.green
                                            : result == 'lose'
                                                ? Colors.red
                                                : Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(radius_5),
                                      ),
                                      child: Text(
                                        result.toUpperCase(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: radius * 0.5,
                                        ),
                                      ),
                                    )
                                ],
                              ),
                              if (isBusted)
                                Positioned(
                                  top: 10,
                                  left: 0,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      "BUST",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: radius * 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          index != 0 &&
                                  !state.activeUsers
                                      .contains(state.playersListing[index].uid)
                              ? Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Container(
                                      padding: EdgeInsets.all(margin_2),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle),
                                      child: Icon(
                                        Icons.wifi_off,
                                        size: font_12,
                                        color: Colors.black54,
                                      )),
                                )
                              : SizedBox(),
                        ],
                      ),
                      state.isNewMessageStreamed &&
                              index ==
                                  state.playersListing.indexWhere((data) =>
                                      state.popUpMessageData['senderUid'] ==
                                      data.uid) &&
                              currentUserModel.uid !=
                                  state.popUpMessageData['senderUid']
                          ? Container(
                              constraints: BoxConstraints(maxWidth: width_110),
                              margin: EdgeInsets.only(
                                  left: margin_50, top: margin_20),
                              padding: EdgeInsets.all(margin_8),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: kBackground, width: width_2),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(radius_1),
                                    bottomLeft: Radius.circular(radius_8),
                                    topRight: Radius.circular(radius_8),
                                    bottomRight: Radius.circular(radius_8),
                                  )),
                              child: TextView(
                                  maxLine: 1,
                                  text: state.popUpMessageData['message'] ?? "",
                                  textStyle: textStyleBodySmall(context)
                                      .copyWith(fontWeight: FontWeight.bold)
                                      .copyWith(fontSize: font_12)),
                            )
                          : SizedBox(),
                    ],
                  );
      },
    );
  }

  Widget _buildCardWidget({required String cardLabel}) {
    return Container(
      width: width_33,
      height: height_48,
      padding: EdgeInsets.all(margin_2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
              blurRadius: radius_2, spreadRadius: radius_1, color: Colors.grey)
        ],
      ),
      child: Center(
        child: Text(
          cardLabel,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildActionButton(
      IconData icon, String label, MultiplayerBlackjackState state) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(margin_3),
        child: ElevatedButton.icon(
          onPressed: () => _onActionPressed(label, state),
          icon: Icon(icon, size: font_15),
          label: Text(label),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 12),
            textStyle: TextStyle(fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius_5),
            ),
            elevation: 4,
          ),
        ),
      ),
    );
  }

  void _onActionPressed(String action, MultiplayerBlackjackState state) async {
    if (action == "Surrender") {
      _exitGameHit(state);
    } else if (action == "Hit") {
      context
          .read<MultiPlayerBlackjackBloc>()
          .add(MultiPlayerHitEvent(widget.data['roomCode']));
    } else if (action == "Stand") {
      context.read<MultiPlayerBlackjackBloc>().add(StandTurnEvent());
    }
  }

  _exitGameHit(MultiplayerBlackjackState state, {title}) async {
    if (state.playersListing.isNotEmpty) {
      var currentUserIndex =
          state.playersListing.indexWhere((e) => e.uid == currentUserModel.uid);
      if ((!state.roundFinished) &&
          state.playersListing[currentUserIndex].betAmount != 0.0) {
        await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            backgroundColor: Colors.white,
            contentPadding: EdgeInsets.all(20),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.warning_amber_rounded,
                    color: Colors.orange, size: 60),
                SizedBox(height: 16),
                Text(
                  "Exit Game?",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "You have already placed bet. ${title ?? "Surrender"} now will cost you half your bet (${(int.parse(state.playersListing[currentUserIndex].betAmount) ?? 0) ~/ 2} chips). Do you want to ${title ?? "surrender"}?",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text("Cancel"),
                    ),
                    SizedBox(width: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        bankAmount.value -= int.parse(state
                                .playersListing[currentUserIndex].betAmount) ~/
                            2;
                        _bloc.add(LeaveGameEvent(int.parse(state
                                .playersListing[currentUserIndex].betAmount) ~/
                            2));
                        _bloc.add(UserOfflineEvent());

                        if (controllers.isNotEmpty) {
                          _animateCardsToOpposite(state).then((onValue) {
                            Navigator.of(context).pop(true);
                            Navigator.of(context).pop(true);
                          });
                        } else {
                          Navigator.of(context).pop(true);
                          Navigator.of(context).pop(true);
                        }
                      },
                      child: Text(title ?? "Surrender"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    for (var playerControllers in controllers) {
      for (var controller in playerControllers) {
        controller.dispose();
      }
    }
    _bloc.close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
