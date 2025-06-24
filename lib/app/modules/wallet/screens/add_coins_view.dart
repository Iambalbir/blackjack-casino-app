import '../../../../export_file.dart';

class AddCoinsScreen extends StatefulWidget {
  @override
  _AddCoinsScreenState createState() => _AddCoinsScreenState();
}

class _AddCoinsScreenState extends State<AddCoinsScreen> {
  int _selectedCoins = 0;
  double _totalCost = 0.0;
  late final AddCoinBloc _bloc;

  void _updateTotalCost(int coins) {
    setState(() {
      _selectedCoins = coins;
      _totalCost = coins * 0.01; // 100 coins = $1.00
    });
  }

  void _payWithStripe() {
    if (_totalCost != 0.0) {
      _bloc.add(MakePaymentEvent(_totalCost));
    }
  }

  final List<int> coinOptions = [100, 500, 1000, 2000, 5000, 10000];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bloc = context.read<AddCoinBloc>();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddCoinBloc, AddCoinState>(
      listener: (context, state) {
        // Handle state changes if needed
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
              title: TextView(
            text: 'Add Coins',
            textStyle: textStyleHeadingMedium(context).copyWith(),
          )),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    children: coinOptions.map((coins) {
                      final isSelected = _selectedCoins == coins;
                      return GestureDetector(
                        onTap: () => _updateTotalCost(coins),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected ? kBackground : Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: radius_2,
                                spreadRadius: radius_1,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AssetImageWidget(
                                imageUrl: iconCoins,
                                imageHeight: height_50,
                              ),
                              Text(
                                '$coins Coins',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.grey[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                if (_selectedCoins > 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: _payWithStripe,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 14,
                        ),
                      ),
                      child: Text(
                        'Buy for \$${_totalCost.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
