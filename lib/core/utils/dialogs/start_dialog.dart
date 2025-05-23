import 'package:app/app/modules/games/bloc/gameController.dart';
import 'package:app/app/modules/games/bloc/gameEvents.dart';
import 'package:app/app/modules/games/screens/about_screen.dart';
import 'package:app/app/modules/games/screens/rules_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StartDialog extends StatelessWidget {
  dynamic width;
  dynamic height;
  GameControllerBloc dataBloc;

  StartDialog({Key? key, this.width, this.height, required this.dataBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.8,
      height: width * 0.8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MaterialButton(
            child: Container(
              width: width * 0.4,
              height: width * 0.13,
              child: Center(
                child: Text(
                  'Play',
                  style: TextStyle(
                      fontSize: width * 0.045, fontWeight: FontWeight.bold),
                ),
              ),
              decoration: BoxDecoration(
                  color: Colors.lightGreen[500],
                  borderRadius: BorderRadius.circular(100)),
            ),
            onPressed: () {
              GameEvents _event = PlayEvent();
              dataBloc.add(_event);
            },
          ),
          MaterialButton(
            child: Container(
              width: width * 0.4,
              height: width * 0.13,
              child: Center(
                child: Text(
                  'Rules',
                  style: TextStyle(
                      fontSize: width * 0.045, fontWeight: FontWeight.bold),
                ),
              ),
              decoration: BoxDecoration(
                  color: Colors.amber[600],
                  borderRadius: BorderRadius.circular(100)),
            ),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => RulesScreen()));
            },
          ),
          MaterialButton(
            child: Container(
              width: width * 0.4,
              height: width * 0.13,
              child: Center(
                child: Text(
                  'About',
                  style: TextStyle(
                      fontSize: width * 0.045, fontWeight: FontWeight.bold),
                ),
              ),
              decoration: BoxDecoration(
                  color: Colors.blue[300],
                  borderRadius: BorderRadius.circular(100)),
            ),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => AboutScreen()));
            },
          ),
        ],
      ),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(30)),
    );
  }
}
