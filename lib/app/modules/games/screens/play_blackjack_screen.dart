import 'package:app/app/modules/games/bloc/adState.dart';
import 'package:app/app/modules/games/bloc/cardProcessor.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../../core/utils/widgets/sliding_flipping_widget.dart';
import '../../../../export_file.dart';

class PlayBlackJackScreen extends StatefulWidget {
  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayBlackJackScreen> {
  List deck = [];
  List playerCards = [];
  int playerValue = 0;
  List dealerCards = [];
  int dealerValue = 0;
  int bank = 1000;
  int bet = 0;
  String dialog = kStartMenuDialog;
  String result = '';
  int playerReturn = 0;
  String? gameState;
  String? _firstPlayerCard;

  bool animationComplete = true;
  double hidingCardLeft = 0.0;

  GameControllerBloc? _dataBloc;

  CardProcessor _cardProcessor = CardProcessor();

  double width = 40;
  double height = 40;

  AdState? adState;

  @override
  void initState() {
    super.initState();
    final initFuture = MobileAds.instance.initialize();
    adState = AdState(initFuture);
    _cardProcessor.initializeDeck();
  }

  void animationReset() {
    animationComplete = false;
  }

  void animationHandler(String card) {
    if (gameState == 'Player Turn' ||
        gameState == 'Player Busted' ||
        gameState == 'Round Finished') {
      if (card == playerCards.last) {
        setState(() {
          animationComplete = true;
        });
      } else if (card == dealerCards.last) {
        setState(() {
          animationComplete = true;
        });
      }
    } else if (gameState == 'Next Round') {
      if (card == _firstPlayerCard) {
        hidingCardLeft = 0.0;
        deck = _cardProcessor.displayDeck();
        setState(() {
          animationComplete = true;
        });
      }
    }
  }

  void processData(Map data) {
    gameState = data['GameState'];

    if (gameState == 'Player Betting') {
      dialog = kBetDialog;
      _cardProcessor.inputDeck = data['Deck'];
      deck = _cardProcessor.displayDeck();
    } else if (gameState == 'Player Turn') {
      hidingCardLeft = width;
      dialog = kPlayerTurnDialog;
      playerCards = _cardProcessor.playerCards = data['Player Cards'];
      playerValue = data['Player Value'];
      dealerCards = _cardProcessor.dealerCards = data['Dealer Cards'];
      dealerValue = data['Dealer Value'];
      bank = data['Bank'];
      bet = data['Bet'];
      _firstPlayerCard = playerCards[0];
      deck = _cardProcessor.dealCards();
    } else if (gameState == 'Player Busted') {
      dialog = kResultDialog;
      result = kPlayerBust;
      playerCards = _cardProcessor.playerCards = data['Player Cards'];
      playerValue = data['Player Value'];
      dealerValue = data['Dealer Value'];
      playerReturn = data['PlayerReturn'];
      deck = _cardProcessor.dealCards();
      deck = _cardProcessor.revealFaceDownCard();
    } else if (gameState == 'Round Finished') {
      dialog = kResultDialog;
      result = data['Result'];
      dealerCards = _cardProcessor.dealerCards = data['Dealer Cards'];
      dealerValue = data['Dealer Value'];
      playerReturn = data['PlayerReturn'];
      if (dealerCards.length == 2) {
        animationComplete = true;
      } else {
        deck = _cardProcessor.dealCards();
      }
      deck = _cardProcessor.revealFaceDownCard();
    } else if (gameState == 'Next Round') {
      playerValue = 0;
      dealerValue = 0;
      deck = _cardProcessor.disposeUsedCards();
      bank = data['Bank'];
      bet = data['Bet'];
      _cardProcessor.inputDeck = data['Deck'];
      dialog = kBetDialog;
    }
  }

  @override
  Widget build(BuildContext context) {
    width = _cardProcessor.width = MediaQuery.of(context).size.width;
    height = _cardProcessor.height = MediaQuery.of(context).size.height;
    _dataBloc = BlocProvider.of<GameControllerBloc>(context);
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: StreamBuilder(
            initialData: {},
            stream: _dataBloc!.stream,
            builder: (context, snapshot) {
              Map data = snapshot.data!;
              if (data.isNotEmpty) {
                processData(data);
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    if (deck.isNotEmpty)
                      for (int i = 0; i < deck.length; i++)
                        /* AnimatedPositioned(
                          left: deck[i][1],
                          top: deck[i][2],
                          duration: Duration(milliseconds: 600),
                          curve: Curves.decelerate,
                          child: Container(
                            child: cardBuilder(
                                width, height, deck[i][0], deck[i][3]),
                          ),
                          onEnd: () {
                            animationHandler(deck[i][0]);
                          },
                        ),*/
                        SlidingFlippingCard(
                          left: deck[i][1],
                          top: deck[i][2],
                          isFlipped: gameState == 'Round Finished',
                          slideDuration: Duration(milliseconds: 800),
                          card: deck[i][0],
                          face: deck[i][3],
                          width: width,
                          height: height,
                          onAnimationEnd: () {
                            animationHandler(deck[i][0]);
                          },
                        ),
                    AnimatedPositioned(
                      top: 0.0,
                      left: hidingCardLeft,
                      child: Container(
                          padding: EdgeInsets.all(5.0),
                          width: width * 0.2 - 20,
                          height: width * 0.3 - 20,
                          decoration: BoxDecoration(
                              color: kBackground,
                              borderRadius: BorderRadius.circular(12))),
                      duration: Duration(milliseconds: 600),
                      curve: Curves.decelerate,
                    ),
                    Positioned(
                      left: 0,
                      top: 0,
                      child: FaceDownCard(width: width, height: height),
                    ),
                    Positioned(
                      left: (width - width * 0.15 - 16) / 2,
                      top: 0,
                      child: Container(
                        width: width * 0.15,
                        height: width * 0.09,
                        child: Center(
                            child: Text(
                          '$dealerValue',
                          style: textStyleBodySmall(context).copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: width * 0.05),
                        )),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.white),
                      ),
                    ),
                    _displayDialog(),
                    Positioned(
                      left: (width - width * 0.15 - 16) / 2,
                      bottom: 0,
                      child: Container(
                        width: width * 0.15,
                        height: width * 0.09,
                        child: Center(
                            child: Text(
                          '$playerValue',
                          style: textStyleBodySmall(context).copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: width * 0.05),
                        )),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.white),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      bottom: 0,
                      child: Text(
                        'Bank : \$ $bank',
                        style: textStyleBodySmall(context).copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.05),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: chip(width, bet, context),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }

  _displayDialog() {
    return Positioned(
      top: (height - width * 0.8 - 16) / 2,
      left: (width - width * 0.8 - 16) / 2,
      child: displayDialog(dialog, width, height, bank, _dataBloc!,
          animationComplete, animationReset, result, playerReturn, adState!),
    );
  }

  Widget displayDialog(
      String dialog,
      double width,
      double height,
      int bank,
      GameControllerBloc dataBloc,
      bool animationComplete,
      VoidCallback animationReset,
      String result,
      int playerReturn,
      AdState adState) {
    if (dialog == kStartMenuDialog) {
      return StartDialog(
        width: width,
        height: height,
        dataBloc: dataBloc,
      );
    } else if (dialog == kBetDialog) {
      if (animationComplete == true) {
        // animationReset();
        return BetDialog(
          width: width,
          height: height,
          bank: bank,
          dataBloc: dataBloc,
        );
      } else {
        return Container();
      }
    } else if (dialog == kPlayerTurnDialog) {
      if (animationComplete == true) {
        // animationReset();
        return PlayerTurnDialog(
          width: width,
          height: height,
          dataBloc: dataBloc,
        );
      } else {
        return Container();
      }
    } else if (dialog == kResultDialog) {
      if (animationComplete == true) {
        // animationReset();
        return ResultDialog(
          width: width,
          height: height,
          onAddComplete: () {
            // animationReset();

            /*  setState(() {
              gameState == 'Player Betting';
            });*/
          },
          result: result,
          playerReturn: playerReturn,
          dataBloc: dataBloc,
          adState: adState,
        );
      } else {
        return Container();
      }
    } else {
      return Container();
    }
  }
}

Widget cardBuilder(double width, double height, String card, String face) {
  String rank = card.split(' ')[0];
  String suit = card.split(' ')[2];
  if (face == kFaceUpCard) {
    return FaceUpCard(
      width: width,
      height: height,
      rank: rank,
      suit: suit,
    );
  } else if (face == kFaceDownCard) {
    return FaceDownCard(
      width: width,
      height: height,
    );
  } else {
    return Container();
  }
}
