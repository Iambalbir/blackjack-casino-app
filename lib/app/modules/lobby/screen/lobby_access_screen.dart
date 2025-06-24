import 'package:app/export_file.dart';

class RoomAccessScreen extends StatefulWidget {
  const RoomAccessScreen({Key? key}) : super(key: key);

  @override
  RoomAccessScreenState createState() => RoomAccessScreenState();
}

class RoomAccessScreenState extends State<RoomAccessScreen> {
  String? _selectedOption;

  void _selectOption(String option) {
    setState(() {
      _selectedOption = option;
    });
  }

  void continueAction() {
    if (_selectedOption == 'public') {
      Navigator.pop(context); // Close dialog
      Navigator.pushNamed(context, RouteName.createPublicRoomScreenRoute);
    } else if (_selectedOption == 'private') {
      Navigator.pop(context);
      Navigator.of(context).pushNamed(RouteName.createPrivateRoomScreenRoute);
    } else {
      showToast("Please select a match type to continue");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(margin_16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextView(
            text: "Select A Match Type",
            textStyle:
                textStyleHeadingSmall(context).copyWith(color: Colors.black),
            textAlign: TextAlign.start,
          ),
          SizedBox(height: margin_20),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => _selectOption('public'),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: margin_8, vertical: margin_20),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: radius_2,
                            spreadRadius: radius_1)
                      ],
                      color: _selectedOption == 'public'
                          ? kBackground
                          : Colors.white,
                      borderRadius: BorderRadius.circular(radius_8),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.public,
                          size: height_20,
                          color: _selectedOption != 'public'
                              ? kBackground
                              : Colors.white,
                        ),
                        SizedBox(height: margin_8),
                        TextView(
                          text: "Public Match",
                          textStyle: textStyleBodySmall(context).copyWith(
                              color: _selectedOption != 'public'
                                  ? kBackground
                                  : Colors.white,
                              fontSize: font_12),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: margin_16),
              Expanded(
                child: InkWell(
                  onTap: () => _selectOption('private'),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: margin_8, vertical: margin_20),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: radius_2,
                            spreadRadius: radius_1)
                      ],
                      color: _selectedOption == 'private'
                          ? kBackground
                          : Colors.white,
                      borderRadius: BorderRadius.circular(radius_8),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.lock,
                            size: height_20,
                            color: _selectedOption != 'private'
                                ? kBackground
                                : Colors.white),
                        SizedBox(height: margin_8),
                        TextView(
                          text: "Private Match",
                          textStyle: textStyleBodySmall(context).copyWith(
                              color: _selectedOption != 'private'
                                  ? kBackground
                                  : Colors.white,
                              fontSize: font_12),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: margin_16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: TextView(
                  text: "Cancel",
                  textStyle: textStyleBodySmall(context),
                ),
              ),
              TextButton(
                onPressed: continueAction,
                child: TextView(
                  text: "Continue",
                  textStyle: textStyleBodySmall(context)
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
