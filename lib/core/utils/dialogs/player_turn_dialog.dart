import 'package:app/customWidgets.dart';

import '../../../export_file.dart';

class PlayerTurnDialog extends StatelessWidget {
  final width;
  final height;
  final dataBloc;

  PlayerTurnDialog({Key? key, this.width, this.height, this.dataBloc})
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
          Text(
            'Your turn',
            style:
                TextStyle(fontWeight: FontWeight.bold, fontSize: width * 0.08),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(width: width * 0.025),
              Column(
                children: [
                  InkWell(
                    child: playerButton(width,
                        Icon(Icons.add, size: width * 0.1), kHitButtonYellow),
                    onTap: () {
                      GameEvents _event = HitEvent();
                      dataBloc.add(_event);
                    },
                  ),
                  SizedBox(height: width * 0.05),
                  Text(
                    'Hit',
                    style: textStyleBodySmall(context).copyWith(
                        fontSize: width * 0.06, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(width: width * 0.02),
              Column(
                children: [
                  InkWell(
                    child: playerButton(width,
                        Icon(Icons.stop, size: width * 0.1), kStayButtonGreen),
                    onTap: () {
                      GameEvents _event = StayEvent();
                      dataBloc.add(_event);
                    },
                  ),
                  SizedBox(height: width * 0.05),
                  Text(
                    'Stay',
                    style: textStyleBodySmall(context).copyWith(
                        fontSize: width * 0.06, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                children: [
                  InkWell(
                    child: playerButton(width,
                        Icon(Icons.flag, size: width * 0.1), Colors.blue[100]!),
                    onTap: () {
                      GameEvents _event = SurrenderEvent();
                      dataBloc.add(_event);
                    },
                  ),
                  SizedBox(height: width * 0.05),
                  Text(
                    'Surrender',
                    style: textStyleBodySmall(context).copyWith(
                        fontSize: width * 0.06, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      decoration: BoxDecoration(
          color: Colors.blue[100], borderRadius: BorderRadius.circular(30)),
    );
  }
}
