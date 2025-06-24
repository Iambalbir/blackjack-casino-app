import 'package:app/app/modules/games/screens/play_blackjack_screen.dart';
import 'package:app/core/utils/values/textStyles.dart';
import 'package:app/core/utils/widgets/dimens.dart';
import 'package:app/core/utils/widgets/text_view.dart';
import 'package:flutter/material.dart';
import 'package:app/constants.dart';
import 'package:app/customWidgets.dart';

class RulesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(radius_5)),
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          TextView(
              text: "Game Rules", textStyle: textStyleHeadingMedium(context)),
          SizedBox(height: 12),
          Text(
            'The goal of blackjack is to beat the dealer.',
            style: TextStyle(
              fontSize: width * 0.04,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Value of cards',
            style: TextStyle(
              fontSize: width * 0.06,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 12),
          Text(
            '• Two to ten have their face point value (e.g., the value of three of clubs will be 3).',
            style: TextStyle(
              fontSize: width * 0.04,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10),
          Text(
            '• King, Queen, and Jack are valued at 10.',
            style: TextStyle(
              fontSize: width * 0.04,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10),
          Text(
            '• Ace is valued at 1 or 11 depending on the hand (whichever value takes you closer to 21 without going over).',
            style: TextStyle(
              fontSize: width * 0.04,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10),

          // Card images example section kept intact
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: width * 0.231 - 10,
                height: width * 0.5 - 35,
                child: Stack(
                  children: [
                    Positioned(
                      top: width * 0.057 - 5,
                      child: cardBuilder(width / 1.0, height / 2.0,
                          "Ace of Hearts", kFaceUpCard),
                    ),
                    Positioned(
                      left: width * 0.077 - 10,
                      child: cardBuilder(width / 1.0, height / 2.0,
                          "Nine of Spades", kFaceUpCard),
                    ),
                    Positioned(
                      left: width * 0.06 - 15,
                      bottom: 0,
                      child: Container(
                        width: width / 1.3 * 0.15,
                        height: width / 1.3 * 0.09,
                        child: Center(
                          child: Text(
                            '20',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: width * 0.04,
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(radius_5),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: width * 0.308 - 20,
                height: width * 0.5 - 35,
                child: Stack(
                  children: [
                    Positioned(
                      top: width * 0.114 - 10,
                      child: cardBuilder(width / 1.0, height / 2.0,
                          "Ace of Hearts", kFaceUpCard),
                    ),
                    Positioned(
                      top: width * 0.057 - 5,
                      left: width * 0.077 - 10,
                      child: cardBuilder(width / 1.0, height / 2.0,
                          "Nine of Spades", kFaceUpCard),
                    ),
                    Positioned(
                      left: width * 0.154 - 20,
                      child: cardBuilder(width / 1.0, height / 2.0,
                          "Four of Diamonds", kFaceUpCard),
                    ),
                    Positioned(
                      left: width * 0.077 - 10,
                      bottom: 0,
                      child: Container(
                        width: width / 1.3 * 0.15,
                        height: width / 1.3 * 0.09,
                        child: Center(
                          child: Text(
                            '14',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: width * 0.04,
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(radius_5),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 12),
          Text(
            'Game Modes',
            style:
                TextStyle(fontSize: width * 0.06, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 12),
          Text(
            '1. Single Player Mode: Play against the dealer only. Aim for a hand value closer to 21 than the dealer.',
            style:
                TextStyle(fontSize: width * 0.04, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 10),
          Text(
            '2. Multiplayer Mode: Play against multiple players and the dealer. The goal is to have a higher hand value than the dealer and other players.',
            style:
                TextStyle(fontSize: width * 0.04, fontWeight: FontWeight.w500),
          ),

          SizedBox(height: 12),
          Text(
            'Start of the game',
            style:
                TextStyle(fontSize: width * 0.06, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 12),
          Text(
            'The player places a bet. Two face-up cards are dealt to each player. The dealer gets one face-up and one face-down card.',
            style:
                TextStyle(fontSize: width * 0.04, fontWeight: FontWeight.w500),
          ),

          SizedBox(height: 12),
          Text(
            'How to play',
            style:
                TextStyle(fontSize: width * 0.06, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 12),
          Text(
            'You have three options:',
            style:
                TextStyle(fontSize: width * 0.04, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 10),

          Row(
            children: [
              playerButton(width / 2, Icon(Icons.add, size: width * 0.05),
                  kHitButtonYellow),
              SizedBox(width: 7),
              Text(
                'Hit - Get one more card.',
                style: TextStyle(
                    fontSize: width * 0.04, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          SizedBox(height: 10),

          Row(
            children: [
              playerButton(width / 2, Icon(Icons.stop, size: width * 0.05),
                  kStayButtonGreen),
              SizedBox(width: width_5),
              Text(
                'Stay - Keep your current hand.',
                style: TextStyle(
                    fontSize: width * 0.04, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          SizedBox(height: 10),

          Row(
            children: [
              playerButton(width / 2, Icon(Icons.flag, size: width * 0.05),
                  Colors.white),
              SizedBox(width: width_5),
              Text(
                'Surrender - Forfeit half your bet\nand end the round.',
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: width * 0.04, fontWeight: FontWeight.w500),
              ),
            ],
          ),

          SizedBox(height: 10),
          Text(
            'Try to get as close to 21 without going over.',
            style:
                TextStyle(fontSize: width * 0.04, fontWeight: FontWeight.w500),
          ),

          SizedBox(height: 12),
          Text(
            'How do you win?',
            style:
                TextStyle(fontSize: width * 0.06, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 12),
          Text(
            '• Your hand value is higher than the dealer\'s.',
            style:
                TextStyle(fontSize: width * 0.04, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 10),
          Text(
            '• Dealer\'s hand value goes over 21.',
            style:
                TextStyle(fontSize: width * 0.04, fontWeight: FontWeight.w500),
          ),

          SizedBox(height: 12),
          Text(
            'How do you lose?',
            style:
                TextStyle(fontSize: width * 0.06, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 12),
          Text(
            '• Dealer\'s hand value is higher than yours.',
            style:
                TextStyle(fontSize: width * 0.04, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 10),
          Text(
            '• Your hand value goes over 21.',
            style:
                TextStyle(fontSize: width * 0.04, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
