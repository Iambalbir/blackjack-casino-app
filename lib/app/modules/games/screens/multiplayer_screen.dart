import '../../../../export_file.dart';

class BlackjackGameScreen extends StatefulWidget {
  @override
  _BlackjackGameScreenState createState() => _BlackjackGameScreenState();
}

class _BlackjackGameScreenState extends State<BlackjackGameScreen>
    with TickerProviderStateMixin {
  final double tableWidth = 340;
  final double tableHeight = 650;
  final double borderRadius = 100;

  final List<String> players = [
    'Dealer',
    'Player 1',
    'Player 2',
    'Player 3',
    'Player 4',
    'Player 5',
  ];

  final Offset cardSource = Offset(20, 20);
  List<Offset> holePositions = [];
  List<List<AnimationController>> controllers = [];
  List<List<Animation<Offset>>> animations = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeHolePositions();
      _initializeAnimations();
      _startDealing();
    });
  }

  void _initializeHolePositions() {
    final double holeRadius = tableHeight * 0.038;
    final double holeDiameter = holeRadius * 2;
    final double verticalSpace = tableHeight - holeDiameter * 2;
    final double margin = verticalSpace / 3;
    final double leftHole1Y = margin - 2;
    final double leftHole2Y = margin + holeDiameter + margin;
    final double rightHole1Y = leftHole1Y;
    final double rightHole2Y = leftHole2Y;

    setState(() {
      holePositions = [
        Offset(tableWidth / 2.2 - holeRadius, -20),
        Offset(tableWidth / 2.1 - holeRadius, tableHeight - holeDiameter / 1.3),
        Offset(-22, leftHole1Y),
        Offset(-22, leftHole2Y - 6),
        Offset(tableWidth - holeDiameter + 6, rightHole1Y),
        Offset(tableWidth - holeDiameter + 6, rightHole2Y),
      ];
    });
  }

  void _initializeAnimations() {
    controllers.clear();
    animations.clear();

    for (int i = 0; i < players.length; i++) {
      List<AnimationController> playerControllers = [];
      List<Animation<Offset>> playerAnimations = [];
      for (int j = 0; j < 2; j++) {
        final controller = AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 800),
        );
        final animation = Tween<Offset>(
          begin: cardSource,
          end: holePositions[i] + Offset(j * 22.0, -60),
        ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));

        playerControllers.add(controller);
        playerAnimations.add(animation);
      }
      controllers.add(playerControllers);
      animations.add(playerAnimations);
    }
  }

  Future<void> _startDealing() async {
    for (int cardIndex = 0; cardIndex < 2; cardIndex++) {
      for (int playerIndex = 0; playerIndex < players.length; playerIndex++) {
        await Future.delayed(Duration(milliseconds: 300));
        if (mounted) controllers[playerIndex][cardIndex].forward();
      }
    }
  }

  Future<void> _animateCardsToOpposite() async {
    final Offset oppositeOffset = Offset(
      cardSource.dx + 1000,
      cardSource.dy - 500,
    );

    for (int i = 0; i < players.length; i++) {
      for (int j = 0; j < 2; j++) {
        controllers[i][j].dispose();

        final controller = AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 1200),
        );

        final animation = Tween<Offset>(
          begin: holePositions[i] + Offset(j * 22.0, -60),
          end: oppositeOffset,
        ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));

        controllers[i][j] = controller;
        animations[i][j] = animation;

        controller.addListener(() => setState(() {}));
      }
    }

    // Start all animations at once
    for (int i = 0; i < players.length; i++) {
      for (int j = 0; j < 2; j++) {
        controllers[i][j].forward();
      }
    }
  }

  @override
  void dispose() {
    for (final playerControllers in controllers) {
      for (final controller in playerControllers) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  Widget _buildPlayerView(double radius, int index) {
    final bool isDealer = index == 0;
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDealer ? Colors.red[900] : Colors.black,
        border: Border.all(color: Colors.grey, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black87,
            blurRadius: 2,
            spreadRadius: 2,
            offset: Offset(1, 1),
          ),
        ],
      ),
      child: Center(
        child: Text(
          '${index + 1}',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: radius * 0.8,
          ),
        ),
      ),
    );
  }

  Widget _buildCardWidget() {
    return Container(
      width: 40,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(blurRadius: 4, color: Colors.black26)],
      ),
      child: Center(child: Text('🂠', style: TextStyle(fontSize: 24))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double holeRadius = tableHeight * 0.038;
    const double margin_20 = 20;
    const double margin_10 = 10;
    const double margin_3 = 3;
    const double font_15 = 15;

    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: tableWidth,
              height: tableHeight,
              margin: EdgeInsets.all(35),
              decoration: BoxDecoration(
                color: Colors.brown[700],
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(color: Colors.white70, width: 4),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green[900],
                      borderRadius: BorderRadius.circular(borderRadius * 0.9),
                      border: Border.all(
                          color: Colors.greenAccent.shade100, width: 3),
                    ),
                  ),
                  if (holePositions.isNotEmpty)
                    ...List.generate(players.length, (index) {
                      final pos = holePositions[index];
                      return Positioned(
                        left: pos.dx,
                        top: pos.dy,
                        child: Column(
                          children: [
                            SizedBox(height: 0),
                            _buildPlayerView(holeRadius, index),
                            SizedBox(height: 6),
                            Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                players[index],
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                ],
              ),
            ),

            Positioned(
              left: cardSource.dx,
              top: cardSource.dy + 30,
              child: Container(
                width: 50,
                height: 68,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.pink, Colors.blue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(blurRadius: 4, color: Colors.black26)],
                ),
              ),
            ),

            // Animated cards flying to players
            if (animations.isNotEmpty)
              ...List.generate(players.length, (index) {
                return Stack(
                  children: List.generate(2, (cardIndex) {
                    return AnimatedBuilder(
                      animation: animations[index][cardIndex],
                      builder: (context, child) {
                        final offset = animations[index][cardIndex].value;
                        return Positioned(
                          left: offset.dx + 30,
                          top: offset.dy + 125,
                          child: _buildCardWidget(),
                        );
                      },
                    );
                  }),
                );
              }),

            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: margin_20, vertical: margin_10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurpleAccent.withOpacity(0.6),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(Icons.add, 'Hit'),
                      _buildActionButton(Icons.stop, 'Stand'),
                      _buildActionButton(Icons.exposure_plus_1, 'Double'),
                      _buildActionButton(Icons.flag, 'Surrender'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    const double margin_3 = 3;
    const double font_15 = 15;

    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(margin_3),
        child: ElevatedButton.icon(
          onPressed: () => _onActionPressed(label),
          icon: Icon(icon, size: font_15),
          label: Text(label),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 12),
            textStyle: TextStyle(fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
          ),
        ),
      ),
    );
  }

  void _onActionPressed(String action) {
    if (action == "Surrender") {
      _animateCardsToOpposite();
    }
  }
}
