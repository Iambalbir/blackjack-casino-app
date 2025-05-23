import 'package:app/core/utils/dialogs/select_betamount_dialog.dart';

import '../../../../export_file.dart';

class SlotMachineGameScreen extends StatelessWidget {
  Map<String, dynamic> data = Map();

  SlotMachineGameScreen({required this.data});

  final List<String> symbols = ['🍒', '🍋', '🔔', '🍉', '⭐', '💎'];

  Widget _buildReel(int index, FixedExtentScrollController controller) {
    return Container(
      width: 80,
      height: 210,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          ListWheelScrollView.useDelegate(
            controller: controller,
            itemExtent: 70,
            perspective: 0.010,
            physics: FixedExtentScrollPhysics(),
            childDelegate: ListWheelChildLoopingListDelegate(
              children: symbols
                  .map((s) => Center(
                        child: Text(
                          s,
                          style: TextStyle(fontSize: 36),
                        ),
                      ))
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SlotMachineBloc(data),
      child: BlocConsumer<SlotMachineBloc, SlotMachineState>(
        listener: (context, state) {
          ///handle data result here
        },
        builder: (context, state) {
          final bloc = context.read<SlotMachineBloc>();
          return Scaffold(
            body: Center(
              child: Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextView(
                        text: "SLOT MACHINE",
                        textStyle: textStyleBodyMedium(context).copyWith(
                            fontSize: font_20,
                            color: Colors.amberAccent,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: height_30),
                    Container(
                      padding: EdgeInsets.all(margin_8),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: radius_1,
                                spreadRadius: radius_1)
                          ],
                          color: Colors.greenAccent,
                          borderRadius: BorderRadius.circular(radius_10)),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(radius_10),
                            border:
                                Border.all(color: kBackground, width: width_2)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            3,
                            (index) =>
                                _buildReel(index, bloc.controllers[index]),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    TextView(
                        text: "Chips: ${state.playerChips}",
                        textStyle: textStyleBodyMedium(context).copyWith(
                            color: Colors.greenAccent.shade100, fontSize: 18)),
                    SizedBox(height: 10),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: state.isSpinning
                          ? null
                          : () {
                              bloc.add(SpinReelsEvent(state.selectedBet));
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent,
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(
                            horizontal: 32.0, vertical: 16.0),
                        textStyle: textStyleBodyMedium(context).copyWith(
                            fontWeight: FontWeight.bold, fontSize: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: TextView(
                        text: state.isSpinning ? "Spinning..." : "SPIN",
                        textStyle: textStyleBodyMedium(context),
                      ),
                    ),
                    SizedBox(height: height_20),
                    InkWell(
                      onTap: () {
                        if (state.resultMessage == "Try again!") {
                          showBetDialog(context, 0, (amount) {
                            Navigator.pushReplacementNamed(
                                context, RouteName.playSlotMachineScreenRoute,
                                arguments: {"amount": amount});
                          });
                        }
                      },
                      child: TextView(
                        text: state.resultMessage,
                        textStyle: textStyleBodyMedium(context)
                            .copyWith(fontSize: font_16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
