import '../../../../export_file.dart';

class SlotMachineGameScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  SlotMachineGameScreen({required this.data, Key? key}) : super(key: key);

  Widget _buildReel(
      int index, FixedExtentScrollController controller, List<String> symbols) {
    return Container(
      width: 80,
      height: 210,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ListWheelScrollView.useDelegate(
            controller: controller,
            itemExtent: 70,
            perspective: 0.01,
            physics: FixedExtentScrollPhysics(),
            childDelegate: ListWheelChildLoopingListDelegate(
              children: symbols
                  .map((s) =>
                      Center(child: Text(s, style: TextStyle(fontSize: 36))))
                  .toList(),
            ),
          ),
          Positioned(
            top: 70,
            child: Container(
              width: 80,
              height: 70,
              decoration: BoxDecoration(
                border: Border.symmetric(
                  horizontal: BorderSide(color: Colors.amber, width: 3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool resultHandled = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          SlotMachineBloc()..add(InitializeSlotMachine(data["amount"] ?? 1000)),
      child: BlocConsumer<SlotMachineBloc, SlotMachineState>(
        listener: (context, state) {
          if (!state.isSpinning &&
              state.resultMessage.isNotEmpty &&
              !resultHandled) {
            resultHandled = true;

            Future.delayed(Duration(milliseconds: 200), () async {
              if (state.resultMessage == WIN_MESSAGE) {
                final winnings = state.selectedBet;
                bankAmount.value += winnings;

                await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => WinningDialog(reward: winnings),
                );
              } else if (state.resultMessage == "Try again!") {
                bankAmount.value -= state.selectedBet;

                bool rebet = await showLosingDialog(context);
                if (rebet) {
                  await Future.delayed(Duration(milliseconds: 300));
                  showBetDialog(context, 0, (amount) {
                    Navigator.pop(context);
                    context
                        .read<SlotMachineBloc>()
                        .add(UpdateBetAmount(amount));
                  });
                }
              }

              context.read<SlotMachineBloc>().add(ClearResultMessage());

              await Future.delayed(Duration(milliseconds: 500));
              resultHandled = false;
            });
          }
        },
        builder: (context, state) {
          final bloc = context.read<SlotMachineBloc>();
          return WillPopScope(
            onWillPop: () async {
              if ((state.isSpinning || state.resultMessage == '') &&
                  state.selectedBet != 0) {
                final shouldExit = await showDialog<bool>(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    backgroundColor: Colors.white,
                    contentPadding: EdgeInsets.all(20),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.warning_amber_rounded,
                            color: Colors.orange, size: 60),
                        SizedBox(height: 16),
                        Text(
                          "Exit Game?",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          "You are spinning. Exiting now will cost you half your bet (${state.selectedBet ~/ 2} chips). Do you want to exit?",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text("Cancel"),
                            ),
                            SizedBox(width: 12),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () async {
                                await firebaseRepository.updateUserCoins(
                                    amount: "${state.selectedBet ~/ 2}",
                                    userId: currentUserModel.uid);

                                Navigator.of(context).pop(true);
                              },
                              child: Text("Exit Anyway"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
                return shouldExit ?? false;
              }
              return true;
            },
            child: Scaffold(
              backgroundColor: kBackground,
              body: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(iconSlotBg), fit: BoxFit.cover)),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(margin_10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: height_50,
                        ),
                        state.resultMessage == WIN_MESSAGE
                            ? SizedBox()
                            : Container(
                                padding: EdgeInsets.all(margin_5),
                                decoration: BoxDecoration(
                                    color: kBackground,
                                    border: Border.all(color: kBackground),
                                    borderRadius:
                                        BorderRadius.circular(radius_5)),
                                child: TextView(
                                    text: "Bet Amount : \$${state.selectedBet}",
                                    textStyle: textStyleBodyLarge(context)
                                        .copyWith(color: Colors.white)),
                              ),
                        SizedBox(
                          height: height_10,
                        ),
                        TextView(
                            text: "SLOT MACHINE 🎰",
                            textStyle: textStyleHeadingMedium(context).copyWith(
                                color: Colors.amberAccent,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: height_30),
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.greenAccent,
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Colors.grey.shade800, width: 2),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                3,
                                (index) => _buildReel(index,
                                    bloc.controllers[index], bloc.symbols),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: height_10),
                        state.selectedBet == 0
                            ? ElevatedButton(
                                onPressed: () {
                                  {
                                    showBetDialog(context, 0, (amount) {
                                      Navigator.pop(context);
                                      context
                                          .read<SlotMachineBloc>()
                                          .add(UpdateBetAmount(amount));
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kBackground,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: margin_30,
                                      vertical: margin_10),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(radius_5)),
                                ),
                                child: TextView(
                                  text: "REBET",
                                  textStyle: textStyleBodyMedium(context)
                                      .copyWith(color: Colors.white),
                                ),
                              )
                            : SizedBox(),
                        SizedBox(height: height_10),
                        /*   Container(
                          height: height_200,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.amber, width: 1),
                          ),
                          child: Scrollbar(
                            thumbVisibility: true,
                            child: SingleChildScrollView(
                              child: Text(
                                slotRulesDescription,
                                style: textStyleBodySmall(context).copyWith(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        ),*/

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            state.selectedBet == 0
                                ? SizedBox()
                                : ElevatedButton(
                                    onPressed: state.isSpinning
                                        ? null
                                        : () => bloc.add(
                                            SpinReelsEvent(state.selectedBet)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: kBackground,
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: margin_30,
                                          vertical: margin_10),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(radius_5)),
                                    ),
                                    child: TextView(
                                      text: state.isSpinning
                                          ? "Spinning..."
                                          : "SPIN",
                                      textStyle: textStyleBodyMedium(context)
                                          .copyWith(color: Colors.white),
                                    ),
                                  ),
                            SizedBox(
                              width: state.selectedBet == 0 ? width_0 : width_8,
                            ),
                            InkWell(
                              onTap: () {
                                bloc.add(DoubleBetAmount(state.selectedBet));
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: margin_30, vertical: margin_10),
                                decoration: BoxDecoration(
                                    color: kBackground,
                                    borderRadius:
                                        BorderRadius.circular(radius_5)),
                                child: TextView(
                                    text: "Double Bet",
                                    textStyle: textStyleBodyLarge(context)
                                        .copyWith(color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
