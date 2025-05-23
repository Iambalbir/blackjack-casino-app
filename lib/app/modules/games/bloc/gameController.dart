import 'dart:math';

import 'package:app/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'gameEvents.dart';

Map<String, int> ranks = {
  'Ace': 1,
  'Two': 2,
  'Three': 3,
  'Four': 4,
  'Five': 5,
  'Six': 6,
  'Seven': 7,
  'Eight': 8,
  'Nine': 9,
  'Ten': 10,
  'King': 10,
  'Queen': 10,
  'Jack': 10
};

List suits = ['Clubs', 'Diamonds', 'Hearts', 'Spades'];

List deck = [];
List secondDeck = [];
List playerCards = [];
int playerValue = 0;
List dealerCards = [];
int dealerValue = 0;
int bank = 1000;
int bet = 0;
String result = '';
int playerReturn = 0;

class GameControllerBloc extends Bloc<GameEvents, dynamic> {
  GameControllerBloc() : super(PlayEvent()) {
    on((GameEvents event, emit) {
      mapEventToState(event);
    });
  }

  @override
  mapEventToState(GameEvents event) async {
    if (event is PlayEvent) {
      deck = createDeck();
      Map _data = {
        'GameState': 'Player Betting',
        'Deck': deck,
      };
      emit(_data);
    } else if (event is BetEvent) {
      bet = event.bet;
      bank -= bet;
      playerCards.add(deal());
      dealerCards.add(deal());
      playerCards.add(deal());
      playerValue = value(playerCards);
      dealerValue = value(dealerCards);
      dealerCards.add(deal());
      Map _data = {
        'GameState': 'Player Turn',
        'Deck': deck,
        'Player Cards': playerCards,
        'Player Value': playerValue,
        'Dealer Cards': dealerCards,
        'Dealer Value': dealerValue,
        'Bank': bank,
        'Bet': bet,
      };
      emit(_data);
    } else if (event is HitEvent) {
      String card = deal();
      playerCards.add(card);
      playerValue = value(playerCards);
      if (playerValue > 21) {
        dealerValue = value(dealerCards);
        result = kPlayerBust;
        playerReturn = bet * -1;
        Map _data = {
          'GameState': 'Player Busted',
          'Player Cards': playerCards,
          'Player Value': playerValue,
          'Dealer Value': dealerValue,
          'PlayerReturn': playerReturn,
        };
        emit(_data);
      } else {
        Map _data = {
          'GameState': 'Player Turn',
          'Player Cards': playerCards,
          'Player Value': playerValue,
          'Dealer Cards': dealerCards,
          'Dealer Value': dealerValue,
          'Bank': bank,
          'Bet': bet,
        };
        emit(_data);
      }
    } else if (event is StayEvent) {
      dealerValue = value(dealerCards);
      if (playerValue == 21 && playerCards.length == 2) {
        result = kPlayerWon;
        playerReturn = bet * 3;
        Map _data = {
          'GameState': 'Round Finished',
          'Dealer Cards': dealerCards,
          'Dealer Value': dealerValue,
          'Player Cards': playerCards,
          'Player Value': playerValue,
          'PlayerReturn': playerReturn,
          'Result': result
        };
        emit(_data);
      } else {
        await Future.delayed(
            Duration(milliseconds: 800)); // Initial delay for suspense

        while (dealerValue < 17) {
          await Future.delayed(
              Duration(milliseconds: 500)); // Delay between dealer actions
          String card = deal();
          dealerCards.add(card);
          dealerValue = value(dealerCards);
          Map _dealerProgress = {
            'GameState': 'Dealer Turn',
            'Dealer Cards': List.from(dealerCards),
            'Dealer Value': dealerValue,
            'Player Cards': List.from(playerCards),
            'Player Value': playerValue,
            'Bank': bank,
            'Bet': bet,
          };
          emit(_dealerProgress);
        }

        if (dealerValue > 21) {
          result = kDealerBust;
          playerReturn = bet * 2;
        } else if (playerValue > dealerValue) {
          result = kPlayerWon;
          playerReturn = bet * 2;
        } else if (playerValue == dealerValue) {
          result = kTie;
          playerReturn = 0;
        } else {
          result = kDealerWon;
          playerReturn = bet * -1;
        }

        Map _data = {
          'GameState': 'Round Finished',
          'Dealer Cards': dealerCards,
          'Dealer Value': dealerValue,
          'Player Cards': playerCards,
          'Player Value': playerValue,
          'PlayerReturn': playerReturn,
          'Result': result
        };
        emit(_data);
      }
    } else if (event is SurrenderEvent) {
      result = kSurrender;
      playerReturn = (bet ~/ 2) * -1;
      Map _data = {
        'GameState': 'Round Finished',
        'Player Cards': playerCards,
        'Player Value': playerValue,
        'Dealer Cards': dealerCards,
        'Dealer Value': dealerValue,
        'PlayerReturn': playerReturn,
        'Result': result
      };
      emit(_data);
    } else if (event is ContinueEvent) {
      if (result == kSurrender) {
        bank += bet ~/ 2;
      } else {
        if (playerReturn > 0) {
          bank += playerReturn;
        } else if (playerReturn == 0) {
          bank += bet;
        } else {
          // do nothing
        }
      }
      bet = 0;
      playerValue = 0;
      playerCards.clear();
      dealerValue = 0;
      dealerCards.clear();
      int _usedCards = 52 - deck.length;
      if (deck.length < 52) {
        for (int i = 0; i < _usedCards; i++) {
          if (secondDeck.isEmpty) {
            secondDeck = createDeck();
          }
          deck.add(secondDeck[0]);
          secondDeck.removeAt(0);
        }
      }
      Map _data = {
        'GameState': 'Next Round',
        'Bank': bank,
        'Bet': bet,
        'Deck': deck
      };
      emit(_data);
    } else if (event is AdWatchedEvent) {
      print("reward earned");
      if (result == kSurrender) {
        bank += bet;
      } else {
        if (playerReturn > 0) {
          bank += playerReturn * 2;
        } else if (playerReturn == 0) {
          bank += bet;
        } else {
          bank += bet;
        }
      }
      bet = 0;
      playerValue = 0;
      playerCards.clear();
      dealerValue = 0;
      dealerCards.clear();
      int _usedCards = 52 - deck.length;
      if (deck.length < 52) {
        for (int i = 0; i < _usedCards; i++) {
          if (secondDeck.isEmpty) {
            secondDeck = createDeck();
          }
          deck.add(secondDeck[0]);
          secondDeck.removeAt(0);
        }
      }
      Map _data = {
        'GameState': 'Next Round',
        'Bank': bank,
        'Bet': bet,
        'Deck': deck
      };
      emit(_data);
    }
  }
}

List createDeck() {
  List deck = [];
  suits.forEach((element) {
    ranks.forEach((key, value) {
      deck.add('$key of $element');
    });
  });

  deck.shuffle();
  return deck;
}

String deal() {
  String card = deck[0];
  deck.removeAt(0);
  return card;
}

int value(List cards) {
  int value = 0;
  int aceCount = 0;
  List _cardRanks = [];

  for (int i = 0; i < cards.length; i++) {
    _cardRanks.add(cards[i].split(' ')[0]);
  }

  _cardRanks.forEach((card) {
    if (card != 'Ace') {
      value += ranks[card]!;
    } else {
      aceCount += 1;
    }
  });

  if (aceCount != 0) {
    if (aceCount == 1) {
      if (value < 11) {
        value += 11;
      } else {
        value += 1;
      }
    } else if (aceCount == 2) {
      if (value < 10) {
        value += 12;
      } else {
        value += 2;
      }
    } else if (aceCount == 3) {
      if (value < 9) {
        value += 13;
      } else {
        value += 3;
      }
    } else {
      if (value < 8) {
        value += 14;
      } else {
        value += 4;
      }
    }
  }

  return value;
}
