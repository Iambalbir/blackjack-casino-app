import '../../../export_file.dart';

class BetDialog extends StatefulWidget {
  final double width;

  final double height;
  final int bank;
  GameControllerBloc? dataBloc;

  BetDialog(
      {Key? key,
      this.width = 200,
      this.height = 200,
      this.bank = 0,
      this.dataBloc})
      : super(key: key);

  @override
  _BetDialogState createState() => _BetDialogState();
}

class _BetDialogState extends State<BetDialog> {
  int bet = 0;

  void increaseBet(int value) {
    if (bet + value <= widget.bank) {
      setState(() {
        bet += value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width * 0.8,
      height: widget.width * 0.8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Place your bet',
            style: textStyleBodySmall(context).copyWith(
                fontWeight: FontWeight.bold, fontSize: widget.width * 0.06),
          ),
          Container(
            child: chip(widget.width, bet, context),
          ),
          Container(
            width: widget.width * 0.75,
            height: widget.width * 0.25,
            decoration: BoxDecoration(
                color: Colors.black, borderRadius: BorderRadius.circular(30)),
            child: Center(
              child: Container(
                width: widget.width * 0.72,
                height: widget.width * 0.22,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      child: chip(widget.width, 10, context),
                      onTap: () => increaseBet(10),
                    ),
                    InkWell(
                      child: chip(widget.width, 50, context),
                      onTap: () => increaseBet(50),
                    ),
                    InkWell(
                        child: chip(widget.width, 100, context),
                        onTap: () => increaseBet(100)),
                    InkWell(
                      child: chip(widget.width, 500, context),
                      onTap: () => increaseBet(500),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(23)),
              ),
            ),
          ),
          MaterialButton(
            child: Container(
              width: widget.width * 0.2,
              height: widget.width * 0.1,
              child: Center(
                child: Text(
                  'Done',
                  style: textStyleBodySmall(context).copyWith(
                      fontSize: widget.width * 0.045,
                      fontWeight: FontWeight.bold),
                ),
              ),
              decoration: BoxDecoration(
                  color: Colors.blue[300],
                  borderRadius: BorderRadius.circular(100)),
            ),
            onPressed: () {
              if (bet != 0) {
                final BetEvent _event = BetEvent();
                _event.bet = bet;
                widget.dataBloc?.add(_event);
              } else {
                showToast("Please select an amount");
              }
            },
          )
        ],
      ),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(30)),
    );
  }
}
