import 'package:app/app/modules/games/screens/play_blackjack_screen.dart';
import 'package:flutter/material.dart';
import 'package:app/constants.dart';
import 'package:app/customWidgets.dart';

class RulesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MaterialButton(
                      padding: EdgeInsets.all(0),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.arrow_back_ios,
                              color: Colors.black,
                              size: width * 0.04,
                            ),
                            Text(
                              'Back  ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: width * 0.04,
                              ),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                          color: kHitButtonYellow,
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => PlayBlackJackScreen(),
                        ));
                      }
                    ),
                    Text(
                      'Rules',
                      style: TextStyle(
                        fontSize: width * 0.08,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_back_ios,
                            color: kBackground,
                            size: width * 0.042,
                          ),
                          Text(
                            'Back  ',
                            style: TextStyle(
                              color: kBackground,
                              fontSize: width * 0.042,
                            ),
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: kBackground,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  'The goal of blackjack is to beat the dealer',
                  style: TextStyle(
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.w500
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Value of cards',
                  style: TextStyle(
                    fontSize: width * 0.06,
                    fontWeight: FontWeight.w500
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  '• Two to ten have their face point value (value of three of clubs will be 3)',
                  style: TextStyle(
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.w500
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '• King, Queen and Jack are valued at 10',
                  style: TextStyle(
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.w500
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '• Ace is valued at 1 or 11 depending on the hand (whichever value takes you closer to 21 without going over 21)',
                  style: TextStyle(
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.w500
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: width * 0.231 - 30,
                      height: width * 0.4 - 35,
                      child: Stack(
                        children: [
                          Positioned(
                            top: width * 0.057 - 5,
                            child: cardBuilder(width/1.3, height/1.3, "Ace of Hearts", kFaceUpCard)
                          ),
                          Positioned(
                            left: width * 0.077 - 10,
                            child: cardBuilder(width/1.3, height/1.3, "Nine of Spades", kFaceUpCard)
                          ),
                          Positioned(
                            left: width * 0.06 - 15,
                            bottom: 0,
                            child: Container(
                              width: width/1.3 * 0.15,
                              height: width/1.3 * 0.09,
                              child: Center(
                                child: Text(
                                  '20',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: width * 0.04
                                  ),
                                )
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.white
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: width * 0.308 - 20,
                      height: width * 0.456 - 40,
                      child: Stack(
                        children: [
                          Positioned(
                            top: width * 0.114 - 10,
                            child: cardBuilder(width/1.3, height/1.3, "Ace of Hearts", kFaceUpCard)
                          ),
                          Positioned(
                            top: width * 0.057 - 5,
                            left: width * 0.077 - 10,
                            child: cardBuilder(width/1.3, height/1.3, "Nine of Spades", kFaceUpCard)
                          ),
                          Positioned(
                            left: width * 0.154 - 20,
                            child: cardBuilder(width/1.3, height/1.3, "Four of Diamonds", kFaceUpCard)
                          ),
                          Positioned(
                            left: width * 0.077 - 10,
                            bottom: 0,
                            child: Container(
                              width: width/1.3 * 0.15,
                              height: width/1.3 * 0.09,
                              child: Center(
                                child: Text(
                                  '14',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: width * 0.04
                                  ),
                                )
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.white
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
                  'Start of the game',
                  style: TextStyle(
                    fontSize: width * 0.06,
                    fontWeight: FontWeight.w500
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'The player begins by placing a bet on the table. Initially the player receives two face-up cards and the dealer receives a face-up card and a face-down card',
                  style: TextStyle(
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.w500
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'How to play',
                  style: TextStyle(
                    fontSize: width * 0.06,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'The player has three options',
                  style: TextStyle(
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    playerButton(width/2, Icon(Icons.add, size: width * 0.05), kHitButtonYellow),
                    SizedBox(width: 7),
                    Text(
                      'Hit - to receive one more cards',
                      style: TextStyle(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    playerButton(width/2, Icon(Icons.stop, size: width * 0.05), kStayButtonGreen),
                    SizedBox(width: 7),
                    Text(
                      'Stay - to stop receiving more cards',
                      style: TextStyle(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    playerButton(width/2, Icon(Icons.flag, size: width * 0.05), Colors.white),
                    SizedBox(width: 7),
                    Text(
                      'Surrender - Start next round in exchange  \nfor half your bet',
                      style: TextStyle(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  'The player must try to get close to 21 without going over 21',
                  style: TextStyle(
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.w500
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'How do you win',
                  style: TextStyle(
                    fontSize: width * 0.06,
                    fontWeight: FontWeight.w500
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "• Your hand value is higher than dealer's hand value",
                  style: TextStyle(
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.w500
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "• Dealer's hand value goes over 21",
                  style: TextStyle(
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.w500
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "How do you lose",
                  style: TextStyle(
                    fontSize: width * 0.06,
                    fontWeight: FontWeight.w500
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "• Dealer's hand value is higher than your hand value",
                  style: TextStyle(
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.w500
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "• Your hand value goes over 21",
                  style: TextStyle(
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.w500
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

