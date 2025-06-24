import '../../../export_file.dart';

class GameTypeDropdown extends StatefulWidget {
  final Function(String) onChanged;
  final String? initialValue;

  const GameTypeDropdown({
    Key? key,
    required this.onChanged,
    this.initialValue,
  }) : super(key: key);

  @override
  _GameTypeDropdownState createState() => _GameTypeDropdownState();
}

class _GameTypeDropdownState extends State<GameTypeDropdown> {
  final List<String> _gameTypes = [
    TYPE_BLACKJACK,
    // TYPE_SLOT_MACHINE,
    // TYPE_POKER,
  ];

  late String _selectedGame;

  @override
  void initState() {
    super.initState();
    _selectedGame = widget.initialValue ?? TYPE_BLACKJACK;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: _selectedGame,
      onChanged: (value) {
        if (value != null) {
          setState(() => _selectedGame = value);
          widget.onChanged(value);
        }
      },
      decoration: InputDecoration(
        labelText: 'Select Game Type',
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white10,
      ),
      dropdownColor: kBackground,
      iconEnabledColor: Colors.white,
      style: TextStyle(color: Colors.black),
      items: _gameTypes.map((type) {
        return DropdownMenuItem<String>(
          value: type,
          child: Text(
            type,
            style: TextStyle(color: Colors.white),
          ),
        );
      }).toList(),
    );
  }
}
