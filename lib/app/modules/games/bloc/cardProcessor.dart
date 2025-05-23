import 'package:app/constants.dart';

class CardProcessor {
  dynamic _deck = [];
  dynamic inputDeck;
  dynamic playerCards;
  dynamic dealerCards;
  dynamic width;
  dynamic height;

  CardProcessor(
      {this.inputDeck,
      this.playerCards,
      this.dealerCards,
      this.width,
      this.height});

  void initializeDeck() {
    for (int i = 0; i < 52; i++) {
      _deck.add(['No Card', 0.0, 0.0, kNoCard]);
    }
  }

  List displayDeck() {
    for (int i = 0; i < inputDeck.length; i++) {
      _deck[i] = [inputDeck[i], 0.0, 0.0, kFaceUpCard];
    }
    return _deck;
  }

  List dealCards() {
    int playerCardExtra = 0;
    int dealerCardExtra = 0;
    List usedPlayerCards = [];
    List usedDealerCards = [];
    _deck.forEach((card) {
      if (playerCards.contains(card[0])) {
        if (usedPlayerCards.contains(card[0])) {
          // Do nothing
        } else {
          usedPlayerCards.add(card[0]);
          card[1] = double.parse(
              '${(width * 0.8 + 4) / 2 + playerCardExtra * ((width * 0.2 - 20) / 2) - ((width * 0.1 - 10) / 2) * (playerCards.length - 1)}');
          card[2] = double.parse(
              '${height - width * 0.39 - 36 - playerCardExtra * ((width * 0.3 - 20) / 5)}');
          playerCardExtra += 1;
        }
      }

      if (dealerCards.contains(card[0])) {
        if (usedDealerCards.contains(card[0])) {
          // Do nothing
        } else {
          usedDealerCards.add(card[0]);
          card[1] = double.parse(
              '${(width * 0.8 + 4) / 2 + dealerCardExtra * ((width * 0.2 - 20) / 2) - ((width * 0.1 - 10) / 2) * (dealerCards.length - 1)}');
          card[2] = double.parse(
              '${width * 0.09 + 16 + dealerCardExtra * ((width * 0.3 - 20) / 5)}');
          if (dealerCardExtra == 1) {
            card[3] = kFaceDownCard;
          }
          dealerCardExtra += 1;
        }
      }
    });

    return _deck;
  }

  List revealFaceDownCard() {
    _deck.forEach((card) {
      if (card[3] == kFaceDownCard) {
        card[3] = kFaceUpCard;
      }
    });
    return _deck;
  }

  List disposeUsedCards() {
    _deck.forEach((card) {
      if (card[1] != 0.0) {
        card[1] = width;
        card[2] = 0.0;
      }
    });
    return _deck;
  }
}
