import 'package:app/core/utils/widgets/games_drop_down.dart';
import '../../../../export_file.dart';

class CreatePublicRoomScreen extends StatelessWidget {
  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  TextEditingController textEditingController = TextEditingController();
  TextEditingController maxLengthTController = TextEditingController();
  TextEditingController entryFeeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PublicRoomBloc, PublicRoomState>(
      listener: (context, state) {},
      builder: (context, state) {
        final bloc = context.read<PublicRoomBloc>();
        return Scaffold(
          backgroundColor: kBackground,
          appBar: AppBar(
            backgroundColor: kBackground,
            title: TextView(
              text: "Create Public Room",
              textStyle: textStyleHeadingMedium(context),
            ),
          ),
          body: Center(
            child: state.isLoading
                ? const CircularProgressIndicator()
                : Form(
                    key: globalKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.public,
                            size: height_80, color: Colors.white),
                        TextView(
                          text: "Create a Public Blackjack Room",
                          textStyle: textStyleBodyMedium(context)
                              .copyWith(color: Colors.white),
                        ),
                        Padding(
                          padding: EdgeInsets.all(margin_10),
                          child: TextFieldWidget(
                            textController: textEditingController,
                            radius: radius_5,
                            validate: (value) => FieldChecker.fieldChecker(
                                value, "Public Group Name"),
                            readOnly: false,
                            hint: "Group Name",
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(margin_10),
                          child: TextFieldWidget(
                            textController: maxLengthTController,
                            radius: radius_5,
                            maxLength: 1,
                            inputType: TextInputType.numberWithOptions(
                                decimal: false, signed: false),
                            inputFormatter: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            validate: (value) =>
                                FieldChecker.validateMaxLengthChecker(
                                    value, "Max Players"),
                            readOnly: false,
                            hint: "Max Players",
                          ),
                        ),
                        // New TextField for Entry Fee
                        /*      Padding(
                          padding: EdgeInsets.all(margin_10),
                          child: TextFieldWidget(
                            textController: entryFeeController,
                            // Add this controller in your state
                            radius: radius_5,
                            inputType: TextInputType.numberWithOptions(
                                decimal: true, signed: false),
                            inputFormatter: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            validate: (value) =>
                                FieldChecker.entryFeeValidator(value),
                            // Add appropriate validation
                            readOnly: false,
                            hint: "Entry Fee",
                          ),
                        ),*/
                        Padding(
                          padding: EdgeInsets.all(margin_10),
                          child: GameTypeDropdown(
                            onChanged: (selectedGame) {
                              bloc.add(UpdateGameType(selectedGame));
                            },
                          ),
                        ),
                        SizedBox(height: height_20),
                        TextView(
                          text:
                              "Up to 5 players can join this room automatically.",
                          textStyle: textStyleBodyMedium(context)
                              .copyWith(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.greenAccent,
                            foregroundColor: Colors.black,
                            padding: EdgeInsets.symmetric(
                                horizontal: margin_25, vertical: margin_10),
                          ),
                          onPressed: () {
                            if (globalKey.currentState!.validate()) {
                              bloc.add(CreatePublicRoomEvent(
                                  buildContext: context,
                                  groupName: textEditingController.text,
                                  entryFee: entryFeeController.text,
                                  maxPlayers: maxLengthTController.text));
                            }
                          },
                          child: TextView(
                            text: "Create Room",
                            textStyle: textStyleBodyMedium(context)
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}
