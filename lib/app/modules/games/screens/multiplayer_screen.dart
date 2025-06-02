import 'package:app/core/utils/dialogs/show_leader_board_dialog.dart';

import '../../../../export_file.dart';

class MultiPlayerBlackjackGameScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  MultiPlayerBlackjackGameScreen({required this.data});

  @override
  _MultiPlayerBlackjackGameScreenState createState() =>
      _MultiPlayerBlackjackGameScreenState();
}

class _MultiPlayerBlackjackGameScreenState
    extends State<MultiPlayerBlackjackGameScreen>
    with TickerProviderStateMixin {
  List<List<AnimationController>> controllers = [];
  List<List<Animation<Offset>>> animations = [];
  late MultiPlayerBlackjackBloc bloc;

  dynamic blocState;
  Set<String> usedCards = {};

  @override
  void initState() {
    super.initState();
    controllers.clear();
    animations.clear();
    usedCards.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc.add(MultiPlayerBlackjackInitialEvent(widget.data));
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = context.read<MultiPlayerBlackjackBloc>();
    bloc.add(UpdateTableDimensions(context));
    bloc.add(UpdateHolePositionsEvent());
  }

  Future<void> _initializeOrExtendAnimations(
      List<List<dynamic>> dealtCardsState) async {
    if (controllers.isEmpty || animations.isEmpty) {
      controllers.clear();
      animations.clear();

      for (int i = 0; i < dealtCardsState.length; i++) {
        List<AnimationController> playerControllers = [];
        List<Animation<Offset>> playerAnimations = [];

        for (int j = 0; j < dealtCardsState[i].length; j++) {
          final controller = AnimationController(
            vsync: this,
            duration: Duration(milliseconds: 800),
          );
          final animation = Tween<Offset>(
            begin: blocState.cardSource,
            end: blocState.holePositions[i] + Offset(j * 22.0, -60),
          ).animate(
            CurvedAnimation(parent: controller, curve: Curves.easeInOut),
          );

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
              end: blocState.holePositions[i] + Offset(j * 22.0, -60),
            ).animate(
                CurvedAnimation(parent: controller, curve: Curves.easeInOut));

            controllers[i].add(controller);
            animations[i].add(animation);
          }
        }
      }
    }
  }

  Future<void> _animateNewCards(List<List<dynamic>> dealtCardsState,
      MultiplayerBlackjackState state) async {
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

  Future<void> _animateCardsToOpposite() async {
    final Offset oppositeOffset = Offset(
      blocState.cardSource.dx + 1000,
      blocState.cardSource.dy - 500,
    );
    for (int i = 0; i < blocState.players.length; i++) {
      for (int j = 0; j < controllers[i].length; j++) {
        controllers[i][j].dispose();

        final controller = AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 1200),
        );

        final animation = Tween<Offset>(
          begin: blocState.holePositions[i] + Offset(j * 22.0, -60),
          end: oppositeOffset,
        ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));

        controllers[i][j] = controller;
        animations[i][j] = animation;

        controller.addListener(() => setState(() {}));
      }
    }

    for (int i = 0; i < blocState.players.length; i++) {
      for (int j = 0; j < controllers[i].length; j++) {
        controllers[i][j].forward();
      }
    }
  }

  @override
  void dispose() {
    for (final playerControllers in controllers) {
      for (final controller in playerControllers) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  Widget _buildPlayerView(
      double radius, int index, MultiplayerBlackjackState state) {
    final bool isDealer = index == 0;
    final bool isCurrentTurn = state.allPlayersUid[index] == state.currentTurn;
    final String uid = state.allPlayersUid[index];

    final turnStartTimeMillis = state.turnStartTime.runtimeType == Timestamp
        ? state.turnStartTime.seconds
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

    final isBusted = state.playersBusted.contains(uid);
    final result = state.playerResults[uid];
    final bool roundFinished = state.roundFinished;

    final key = ValueKey('turn_${state.turnId}_${state.currentTurn}_$uid');

    // Trigger timer update **once** at timer end
    if (remainingTimeInSeconds <= 0.1 && state.remainingTimeInSeconds != 0) {
      bloc.add(UpdateRemainingTimeInSeconds(0));
    } else if (remainingTimeInSeconds >= 14.9 &&
        state.remainingTimeInSeconds != 15) {
      bloc.add(UpdateRemainingTimeInSeconds(15));
    }

    return TweenAnimationBuilder<double>(
      key: key,
      tween: Tween(begin: 1.0, end: 0.0),
      duration: Duration(seconds: remainingTimeInSeconds.toInt()),
      builder: (context, value, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            if (isCurrentTurn && !isBusted && !roundFinished)
              SizedBox(
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
            Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: radius * 2,
                      height: radius * 2,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDealer ? Colors.red[900] : Colors.black,
                        border: Border.all(color: Colors.grey, width: 3),
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
                        child: Text(
                          state.dealtCards.length > index &&
                                  state.dealtCards[index].isNotEmpty
                              ? '${calculateHandValue(state.dealtCards[index])}'
                              : "",
                          style: TextStyle(
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
                          color: result == 'win'
                              ? Colors.green
                              : result == 'lose'
                                  ? Colors.red
                                  : Colors.grey,
                          borderRadius: BorderRadius.circular(8),
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
                    left: 0,
                    bottom: radius * 0.5,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
          ],
        );
      },
    );
  }

  Widget _buildCardWidget({required String cardLabel}) {
    return Container(
      width: width_30,
      height: height_45,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(blurRadius: 4, color: Colors.black26)],
      ),
      child: Center(
        child: Text(
          cardLabel,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  bool _hasShownResultDialog = false;

  @override
  Widget build(BuildContext context) {
    bloc = context.read<MultiPlayerBlackjackBloc>();

    return BlocConsumer<MultiPlayerBlackjackBloc, MultiplayerBlackjackState>(
      listener: (context, state) async {
        if (state.dealtCards.isNotEmpty && state.dealtCards[0].isNotEmpty) {
          blocState = state;

          await _initializeOrExtendAnimations(state.dealtCards);
          await _animateNewCards(state.dealtCards, state);
          for (int playerIndex = 0;
              playerIndex < state.playersListing.length;
              playerIndex++) {
            final cardsCount = state.dealtCards[playerIndex].length;

            for (int cardIndex = 0; cardIndex < cardsCount; cardIndex++) {
              await Future.delayed(Duration(milliseconds: 300));
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
        }

        if (state.roundFinished && result != null && !_hasShownResultDialog) {
          _hasShownResultDialog = true;
          final playerNames = {
            for (var player in state.playersListing) player.uid: player.nickname
          };
          showDialog(
            context: context,
            builder: (_) => LeaderboardDialog(
              playerResults: state.playerResults,
              playerNames: playerNames,
            ),
          ).then((_) {
            // Optional: reset the flag when dialog closes if needed
            // _hasShownResultDialog = false;
          });
        }

        // Reset the flag if a new round starts, for example:
        if (!state.roundFinished) {
          _hasShownResultDialog = false;
        }
      },
      builder: (context, state) {
        final double holeRadius = state.tableHeight * 0.038;
        final isBusted = state.playersBusted.length != 0
            ? state.playersBusted.contains(state.allPlayersUid[state.turnId])
            : false;
        return Scaffold(
          body: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: state.tableWidth,
                  height: state.tableHeight,
                  decoration: BoxDecoration(
                    color: Colors.brown[700],
                    borderRadius: BorderRadius.circular(state.borderRadius),
                    border: Border.all(color: Colors.white70, width: width_4),
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.green[900],
                          borderRadius:
                              BorderRadius.circular(state.borderRadius * 0.9),
                          border: Border.all(
                              color: Colors.greenAccent.shade100, width: 3),
                        ),
                      ),
                      if (state.playersListing.isNotEmpty)
                        ...List.generate(state.playersListing.length, (index) {
                          final pos = state.holePositions[index];
                          return Positioned(
                            left: pos.dx,
                            top: pos.dy,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildPlayerView(holeRadius, index, state),
                                Container(
                                  margin:
                                      EdgeInsets.symmetric(vertical: margin_4),
                                  padding: EdgeInsets.all(margin_4),
                                  decoration: BoxDecoration(
                                      color: kBackground,
                                      borderRadius:
                                          BorderRadius.circular(radius_4)),
                                  child: TextView(
                                      textAlign: TextAlign.center,
                                      text: state.playersListing[index]
                                                  .nickname ==
                                              currentUserModel.nickname
                                          ? "  You   "
                                          : state.playersListing[index]
                                                  .nickname ??
                                              "",
                                      textStyle: textStyleBodySmall(context)
                                          .copyWith(color: Colors.white)),
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
                    width: 50,
                    height: 68,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.pink, Colors.blue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(blurRadius: 4, color: Colors.black26)
                      ],
                    ),
                  ),
                ),
                if (animations.isNotEmpty)
                  ...List.generate(state.playersListing.length, (index) {
                    double width = MediaQuery.of(context).size.width * .74;
                    double height = MediaQuery.of(context).size.height * .31;

                    return Stack(
                      children: List.generate(state.dealtCards[index].length,
                          (cardIndex) {
                        return AnimatedBuilder(
                          animation: animations[index].length > cardIndex
                              ? animations[index][cardIndex]
                              : AlwaysStoppedAnimation(Offset.zero),
                          builder: (context, child) {
                            final offset = animations[index].length > cardIndex
                                ? animations[index][cardIndex].value
                                : Offset.zero;
                            return Positioned(
                              left: offset.dx + 32.w,
                              top: offset.dy + 110.h,
                              child: cardIndex == 1 &&
                                      state.allPlayersUid[index] == 'dealer' &&
                                      state.turnId != 0
                                  ? FaceDownCard(
                                      width: width,
                                      height: height,
                                    )
                                  : _buildCardWidget(
                                      cardLabel: state.dealtCards[index]
                                          [cardIndex]),
                            );
                          },
                        );
                      }),
                    );
                  }),
                state.currentTurn != currentUserModel.uid && !isBusted
                    ? SizedBox()
                    : Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: margin_20, vertical: margin_10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.greenAccent,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      Colors.deepPurpleAccent.withOpacity(0.6),
                                  blurRadius: 8,
                                  offset: Offset(0, 3),
                                )
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildActionButton(Icons.add, 'Hit'),
                                _buildActionButton(Icons.stop, 'Stand'),
                                _buildActionButton(Icons.flag, 'Surrender'),
                              ],
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(margin_3),
        child: ElevatedButton.icon(
          onPressed: () => _onActionPressed(label),
          icon: Icon(icon, size: font_15),
          label: Text(label),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 12),
            textStyle: TextStyle(fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
          ),
        ),
      ),
    );
  }

  void _onActionPressed(String action) {
    if (action == "Surrender") {
      _animateCardsToOpposite();
    } else if (action == "Hit") {
      bloc.add(MultiPlayerHitEvent(widget.data['roomCode']));
    } else if (action == "Stand") {
      bloc.add(StandTurnEvent());
    }
  }
}
