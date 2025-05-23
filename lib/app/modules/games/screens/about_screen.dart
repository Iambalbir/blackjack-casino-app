import 'package:app/app/modules/games/screens/play_blackjack_screen.dart';
import 'package:flutter/material.dart';
import 'package:app/constants.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
                    'About',
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
                'Initial commit by Aaleen Raza.',
                style: TextStyle(
                  fontSize: width * 0.04,
                  fontWeight: FontWeight.w500
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Feel free you use this code as per described in the license',
                style: TextStyle(
                  fontSize: width * 0.04,
                  fontWeight: FontWeight.w500
                ),
              ),
              SizedBox(height: 12),
              Text(
                'The initial version of this app does not comply with google\'s developer policy',
                style: TextStyle(
                  fontSize: width * 0.04,
                  fontWeight: FontWeight.w500
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}