import 'package:app/export_file.dart';

class PokerGameScreen extends StatefulWidget {
  PokerGameScreen({super.key, required this.data});

  Map<String, dynamic> data;

  @override
  State<PokerGameScreen> createState() => _PokerGameScreenState();
}

class _PokerGameScreenState extends State<PokerGameScreen> {
  List<List<AnimationController>> controllers = [];
  List<List<Animation<Offset>>> animations = [];
  late final PokerBloc _bloc;
  bool _initialEventDispatched = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_initialEventDispatched) {
        _bloc = context.read<PokerBloc>();
        _initialEventDispatched = true;
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bloc.add(PokerTableDimensionsEvent(context));
      _bloc.add(UpdatePokerTableHolePositionsEvent(context));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PokerBloc, PokerStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final double holeRadius = state.tableHeight * 0.038;
        final isBusted = state.playersBusted.length != 0
            ? state.playersBusted.contains(state.allPlayersUid[state.turnId])
            : false;
        return Scaffold(
          body: Container(
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
                      borderRadius: BorderRadius.circular(radius_100),
                      border: Border.all(color: Colors.white70, width: width_4),
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
                            borderRadius:
                                BorderRadius.circular(radius_100 * 0.9),
                            border: Border.all(
                                color: Colors.greenAccent.shade100, width: 3),
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildPlayerView(holeRadius, index, state),
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
                                            BorderRadius.circular(radius_4)),
                                    child: TextView(
                                        textAlign: TextAlign.center,
                                        text: state.playersListing[index]
                                                    .nickname ==
                                                currentUserModel.nickname
                                            ? " You  "
                                            : state.playersListing[index]
                                                    .nickname ??
                                                "",
                                        textStyle: textStyleBodySmall(context)
                                            .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white)),
                                  ),
                                  index == 0 ||
                                          state.leftUsers.contains(
                                              state.playersListing[index].uid)
                                      ? SizedBox()
                                      : Container(
                                          padding: EdgeInsets.all(margin_4),
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
                                                  textStyle: textStyleBodySmall(
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
                          BoxShadow(blurRadius: radius_2, color: Colors.white)
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
                              final offset =
                                  animations[index].length > cardIndex
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
                                      : /*_buildCardWidget(
                                        cardLabel: state.dealtCards[index]
                                            [cardIndex]),*/
                                      SizedBox());
                            },
                          );
                        }),
                      );
                    }),
                  state.currentTurn != currentUserModel.uid &&
                          (/*!isBusted ||*/
                              state.roundFinished ||
                                  state.standPlayers
                                      .contains(state.currentTurn) ||
                                  state.playersBusted
                                      .contains(state.currentTurn) ||
                                  state.leftUsers.contains(state.currentTurn))
                      ? SizedBox()
                      : Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: margin_20, vertical: margin_25),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.greenAccent,
                                border: Border.all(
                                    color: kBackground, width: width_2),
                                borderRadius: BorderRadius.circular(radius_10),
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
                                  /*  _buildActionButton(Icons.add, 'Hit', state),
                                  _buildActionButton(
                                      Icons.stop, 'Stand', state),
                                  _buildActionButton(
                                      Icons.flag, 'Surrender', state),*/
                                ],
                              ),
                            ),
                          ),
                        ),
                  Align(alignment: Alignment.topRight, child: SizedBox()),

                  ///drawer integration here
                  state.allPlayersPlacedBet &&
                          state.dealtCards.isEmpty &&
                          widget.data['players'][0]['uid'] ==
                              currentUserModel.uid
                      ? Positioned(
                          bottom: 200.h,
                          child: MaterialButtonWidget(
                            buttonRadius: radius_10,
                            minWidth: MediaQuery.sizeOf(context).width * .5,
                            borderColor: Colors.white,
                            onPressed: () async {
                              /* isTurnStreamInitialised = true;
                              final roomRef = FirebaseFirestore.instance
                                  .collection(roomCollectionPath)
                                  .doc(widget.data['roomCode']);
                              await roomRef.update({
                                'status': 'active',
                                'currentTurn': state.allPlayersUid[1],
                                'turnStartTime':
                                    DateTime.now().millisecondsSinceEpoch,
                                'turnId': 1,
                              });
                              Future.delayed(Duration(milliseconds: 800))
                                  .then((onValue) {
                                context.read<MultiPlayerBlackjackBloc>().add(
                                    SaveDealingCardToFireStoreEvent(
                                        state.allPlayersUid, context));
                              });*/
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
    );
  }

  Widget _buildPlayerView(double radius, int index, PokerStates state) {
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
}
