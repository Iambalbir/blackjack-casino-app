import 'package:app/export_file.dart';

class WalletScreen extends StatelessWidget {
  final int chipBalance = bankAmount.value;
  final List<Map<String, dynamic>> transactions = [];

  WalletScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: TextView(
        text: 'Wallet',
        textStyle: textStyleHeadingMedium(context),
      )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildChipBalance(context),
            SizedBox(height: 20),
            _buildTransactionHeader(),
            SizedBox(height: 10),
            Expanded(child: _buildTransactionList(context)),
            SizedBox(height: 20),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildChipBalance(context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(currentUserModel.uid)
            .snapshots(),
        builder: (context, snapshot) {
          dynamic data;
          if (snapshot.data != null) {
            data = snapshot.data!.data() as Map<String, dynamic>;
            bankAmount.value = data['coins'];
          }
          return Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [kBackground, Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.greenAccent, width: 2),
            ),
            child: Row(
              children: [
                TextView(
                    text: "🪙", textStyle: textStyleHeadlineLarge(context)),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Coins Balance",
                        style: TextStyle(color: Colors.white70, fontSize: 16)),
                    Text(
                      "${bankAmount.value}",
                      style: textStyleHeadingMedium(context).copyWith(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  Widget _buildTransactionHeader() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        "Recent Transactions",
        style: TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildTransactionList(BuildContext context) {
    if (transactions.isEmpty) {
      return Center(
        child: Text("No transactions yet.",
            style: textStyleBodyMedium(context).copyWith(fontSize: font_16)),
      );
    }

    return ListView.separated(
      itemCount: transactions.length,
      separatorBuilder: (_, __) => Divider(color: Colors.white24),
      itemBuilder: (context, index) {
        final tx = transactions[index];
        final isDeposit = tx['type'] == 'deposit';
        return ListTile(
          leading: Icon(
            isDeposit ? Icons.arrow_downward : Icons.arrow_upward,
            color: isDeposit ? Colors.greenAccent : Colors.redAccent,
          ),
          title: Text(
            tx['description'],
            style: TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            tx['date'],
            style: TextStyle(color: Colors.white54),
          ),
          trailing: Text(
            "${isDeposit ? '+' : '-'}\$${tx['amount']}",
            style: TextStyle(
              color: isDeposit ? Colors.greenAccent : Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _walletButton(
            context, "Add Coins", Icons.add_circle, Colors.greenAccent),
/*        _walletButton(
            context, "Withdraw", Icons.remove_circle, Colors.redAccent),*/
      ],
    );
  }

  Widget _walletButton(
      BuildContext context, String label, IconData icon, Color color) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.pushNamed(context, RouteName.addCoinsScreenRoute);
      },
      icon: Icon(icon, color: Colors.black),
      label: Text(label, style: TextStyle(color: Colors.black)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
