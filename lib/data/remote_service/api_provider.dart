import '../../export_file.dart';

class APIRepository {
  static var deviceName, deviceType, deviceID, deviceVersion;

  APIRepository() {
    getDeviceData();
  }

  getDeviceData() async {
    DeviceInfoPlugin info = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo = await info.androidInfo;
      deviceName = androidDeviceInfo.model;
      deviceID = androidDeviceInfo.id;
      deviceVersion = androidDeviceInfo.version.release;
      deviceType = "1";
    } else if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await info.iosInfo;
      deviceName = iosDeviceInfo.model;
      deviceID = iosDeviceInfo.identifierForVendor;
      deviceVersion = iosDeviceInfo.systemVersion;
      deviceType = "2";
    }
  }

  Future<void> checkCurrentUser() async {
    var documentReference =
        FirebaseFirestore.instance.collection("users").doc(currentUser?.uid);
    var dataSnapShot = await documentReference.get();
    if (dataSnapShot.exists) {
      var data = dataSnapShot.data();
      currentUserModel = UserDataModel.fromJson(data!);
      bankAmount.value = currentUserModel.coins ?? 0;
    }
  }

  Future registerNewUser(Map<String, dynamic> userData) async {
    try {
      final UserCredential userCredential =
          await auth.createUserWithEmailAndPassword(
        email: userData['email'],
        password: userData['password'],
      );
      currentUser = userCredential.user;
      currentUser?.updateDisplayName(
          "${userData['firstName'] + " " + userData['lastName']}");
      currentUser?.reload();
      currentUser = FirebaseAuth.instance.currentUser;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser?.uid)
          .set({
        'firstName': userData['firstName'],
        'uid': currentUser?.uid,
        'lastName': userData['lastName'],
        'email': userData['email'],
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }

  /*===================================================================== login API Call  ==========================================================*/
  Future loginApiCall(Map<String, dynamic> dataBody) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: dataBody['email'], password: dataBody['password']);
      currentUser?.reload();
      currentUser = userCredential.user;
    } catch (e) {
      rethrow;
    }
  }

  Future resetPassword({email}) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      showToast("Password reset email sent!");
    } catch (e) {
      rethrow;
    }
  }

  Future googleSignInCall() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: [
          'email',
        ],
      );
      await googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await auth.signInWithCredential(credential);
      currentUser?.reload();
      currentUser = userCredential.user;
      String nickname = await generateUniqueNickname();
      var requestModel = {
        'firstName': userCredential.user?.displayName?.split(" ")[0] ?? "",
        'lastName': userCredential.user!.displayName!.split(" ").length > 1
            ? userCredential.user?.displayName?.split(" ")[1]
            : '',
        'email': userCredential.user?.email ?? "",
        'uid': userCredential.user?.uid,
        'photoURL': userCredential.user?.photoURL ?? "",
        'authProvider': 'google',
        'createdAt': FieldValue.serverTimestamp(),
        'nickname': nickname,
        'isGuest': false,

        // Game Currency and Aggregate Stats
        'coins': 1000,
        'totalWins': 0,
        'totalLosses': 0,
        'totalGames': 0,
        'leaderboardScore': 0,

        // Game-specific stats (can grow if you add more games)
        'gamesPlayed': {
          'blackjack': {
            'wins': 0,
            'losses': 0,
            'played': 0,
            'coinsEarned': 0,
            'coinsSpent': 0,
          },
          'slots': {
            'wins': 0,
            'losses': 0,
            'played': 0,
            'coinsEarned': 0,
            'coinsSpent': 0,
          },
          'poker': {
            'wins': 0,
            'losses': 0,
            'played': 0,
            'coinsEarned': 0,
            'coinsSpent': 0,
          },
        },

        // Metadata
        'lastLogin': FieldValue.serverTimestamp(),
        'deviceName': deviceName,
        'deviceID': deviceID,
        'deviceVersion': deviceVersion,
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser?.uid)
          .set(requestModel);
    } on FirebaseAuthException catch (e, st) {
      showToast(
        e.toString(),
      );
    } catch (e, st) {
      showToast(
        e.toString(),
      );
    }
  }

  Future<void> updateUserNickname(String newNickname) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception("User is not logged in");
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'nickname': newNickname});

      showToast("Nickname updated successfully");
    } catch (e) {
      showToast("Failed to update nickname: $e");
    }
  }

  Future<void> saveGameSession({
    required String userId,
    required String nickname,
    required String gameType,
    required bool isWin,
    required int coinsChange,
    bool isMultiplayer = false,
    List<String>? playerIds,
  }) async {
    final firestore = FirebaseFirestore.instance;

    // 1. Save the session
    await firestore.collection('gameSessions').add({
      'userId': userId,
      'userNickname': nickname,
      'gameType': gameType,
      'result': isWin ? 'win' : 'loss',
      'coinsChange': coinsChange,
      'isMultiplayer': isMultiplayer,
      'players': playerIds ?? [userId],
      'createdAt': FieldValue.serverTimestamp(),
    });

    // 2. Update user stats
    final userDocRef = firestore.collection('users').doc(userId);
    final userSnapshot = await userDocRef.get();

    if (!userSnapshot.exists) return;

    final userData = userSnapshot.data()!;
    final gameStats = Map<String, dynamic>.from(userData['gamesPlayed'] ?? {});
    final currentGame = Map<String, dynamic>.from(gameStats[gameType] ??
        {
          'wins': 0,
          'losses': 0,
          'played': 0,
          'coinsEarned': 0,
          'coinsSpent': 0,
        });

    // Update current game's stats
    currentGame['played'] += 1;
    if (isWin) {
      currentGame['wins'] += 1;
      currentGame['coinsEarned'] += coinsChange;
    } else {
      currentGame['losses'] += 1;
      currentGame['coinsSpent'] += coinsChange.abs();
    }
    gameStats[gameType] = currentGame;

    // Update aggregate stats
    final updatedData = {
      'coins': (userData['coins'] ?? 0) + coinsChange,
      'totalWins': (userData['totalWins'] ?? 0) + (isWin ? 1 : 0),
      'totalLosses': (userData['totalLosses'] ?? 0) + (!isWin ? 1 : 0),
      'totalGames': (userData['totalGames'] ?? 0) + 1,
      'gamesPlayed': gameStats,
      'leaderboardScore':
          ((userData['leaderboardScore'] ?? 0) + (isWin ? 10 : 0)),
      // optional
      'lastLogin': FieldValue.serverTimestamp(),
    };

    await userDocRef.update(updatedData);
  }

  Future createPrivateRoomTrigger(Map<String, dynamic> roomData) async {
    final roomCode = _generateRoomCode();
    roomData['roomCode'] = roomCode;

    await FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomCode)
        .set(roomData);
    return roomCode;
  }



  Future saveDealingCardsToFireStore(
      String roomCode, List<dynamic> playerUid) async {
    final Map<String, List<String>> cardsMap = {};
    final usedCards = <String>{};

    String generateUniqueCard() {
      String card;
      do {
        card = generateRandomCard();
      } while (usedCards.contains(card));
      usedCards.add(card);
      return card;
    }

    for (final uid in playerUid) {
      cardsMap[uid] = [generateUniqueCard(), generateUniqueCard()];
    }

    cardsMap['dealer'] = [generateUniqueCard(), generateUniqueCard()];
    final docRef = FirebaseFirestore.instance.collection('games').doc(roomCode);
    final docSnap = await docRef.get();

    if (!docSnap.exists) {
      await docRef.set({
        'dealtCards': cardsMap,
        'gameState': 'dealing',
        'game':'BlackJack',
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    }

    await docRef.update({
      'dealtCards': cardsMap,
      'gameState': 'dealing',
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  Future addInvitationData(Map<String, dynamic> invitationData) async {
    await FirebaseFirestore.instance
        .collection('invitations')
        .add(invitationData);
  }

  String _generateRoomCode() {
    const chars = ALPHA_NUM_CHARS;
    final rand = Random();
    return List.generate(6, (index) => chars[rand.nextInt(chars.length)])
        .join();
  }
}
