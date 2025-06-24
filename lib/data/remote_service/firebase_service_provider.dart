import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../export_file.dart';

class FirebaseRepository {
  static var deviceName, deviceType, deviceID, deviceVersion;

  FirebaseRepository() {
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
      bankAmount.value =
          int.parse(currentUserModel.coins.toString().split(".")[0]) ?? 0;
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

      currentUser?.reload();
      currentUser = auth.currentUser;

      String nickname = userData['nickname'];
      var requestModel = {
        'firstName': userCredential.user?.displayName?.split(" ")[0] ?? "",
        'lastName': userData['nickname'] != null
            ? ''
            : userCredential.user!.displayName!.split(" ").length > 1
                ? userCredential.user?.displayName?.split(" ")[1]
                : '',
        'email': userCredential.user?.email ?? "",
        'uid': userCredential.user?.uid,
        'photoURL': userCredential.user?.photoURL ?? "",
        'authProvider': 'email/password',
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
      await saveUserSession(currentUser?.email);
    } on FirebaseAuthException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  /*===================================================================== login API Call  ==========================================================*/
  Future<void> loginApiCall(Map<String, dynamic> dataBody) async {
    try {
      // Get device data
      await getDeviceData();

      // Reference to the user session document
      DocumentReference userSessionRef = FirebaseFirestore.instance
          .collection('userSessions')
          .doc(dataBody['email']);

      // Check for existing session
      DocumentSnapshot sessionSnapshot = await userSessionRef.get();

      if (sessionSnapshot.exists) {
        await userSessionRef.update({
          'isActive': false,
          'lastLoggedOut': DateTime.now(),
        });
      }

      // Perform login
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: dataBody['email'], password: dataBody['password']);

      // Reload user to get the latest user data
      currentUser?.reload();
      currentUser = userCredential.user;

      // Create or update the session document with device data
      await userSessionRef.set({
        'isActive': true,
        'deviceId': deviceID,
        'deviceName': deviceName,
        'deviceVersion': deviceVersion,
        'deviceType': deviceType,
        'lastLoggedIn': DateTime.now().millisecondsSinceEpoch,
      });

      // Optional: Check if the session is still valid after login
      DocumentSnapshot newSessionSnapshot = await userSessionRef.get();
      if (newSessionSnapshot.exists) {
        var newSessionData = newSessionSnapshot.data() as Map<String, dynamic>;
        if (newSessionData['isActive'] == false) {
          await auth.signOut();
          throw Exception("Session expired. Please log in again.");
        }
      }
    } catch (e) {
      // Handle errors (e.g., show a message to the user)
      print("Login error: $e");
      rethrow; // Rethrow the error for further handling if needed
    }
  }

  Future<void> saveUserSession(String? email) async {
    print('email-=================$email');
    if (email == null) return;

    DocumentReference userSessionRef =
        FirebaseFirestore.instance.collection('userSessions').doc(email);

    // Invalidate existing session if it exists
    DocumentSnapshot sessionSnapshot = await userSessionRef.get();

    if (sessionSnapshot.exists) {
      await userSessionRef.update({
        'deviceId': deviceID,
        'isActive': false,
        'lastLoggedOut': DateTime.now().millisecondsSinceEpoch,
      });
    }

    // Debugging: Log session saving
    print('Saving session for user: $email');

    // Create or update the session document with device data
    await userSessionRef.set({
      'isActive': true,
      'deviceId': deviceID,
      'deviceName': deviceName,
      'deviceVersion': deviceVersion,
      'deviceType': deviceType,
      'lastLoggedIn': DateTime.now().millisecondsSinceEpoch,
    });
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
        scopes: ['email'],
      );

      await googleSignIn.signOut(); // Sign out any existing Google session

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleAuth == null) {
        throw Exception("Google authentication failed");
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await auth.signInWithCredential(credential);
      currentUser?.reload();
      currentUser = userCredential.user;

      // Debugging: Check if user is signed in
      if (currentUser == null) {
        throw Exception("User  is not signed in");
      }
      String nickname = await generateUniqueNickname();
      String stripeCustomerId = await createStripeCustomer(
          userCredential.user?.email ?? "", nickname);
      print('stripe customer id=======++${stripeCustomerId}');

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
        'coins': 1000,
        'totalWins': 0,
        'totalLosses': 0,
        'totalGames': 0,
        'leaderboardScore': 0,
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
        'lastLogin': FieldValue.serverTimestamp(),
        'stripeCustomerId': stripeCustomerId,
        'deviceName': deviceName,
        'deviceID': deviceID,
        'deviceVersion': deviceVersion,
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser?.uid)
          .set(requestModel);

      return userCredential.user?.email;
    } on FirebaseAuthException catch (e) {
      showToast(e.toString());
      return;
    } catch (e) {
      showToast(e.toString());
      return;
    }
  }

  Future<String> createStripeCustomer(String email, String name) async {
    try {
      // Request body

      Map<String, dynamic> body = {
        'email': email,
        'name': name,
      };

      // Make POST request to Stripe

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/customers'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final customerData = json.decode(response.body);
        return customerData['id']; // Return the customer ID
      } else {
        throw Exception('Failed to create Stripe customer: ${response.body}');
      }
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<void> updateUserNickname(String newNickname) async {
    try {
      final user = auth.currentUser;

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

  Future<void> updateUserCoins({userId, amount}) async {
    final batch = FirebaseFirestore.instance.batch();
    var userDoc = FirebaseFirestore.instance.collection("users").doc(userId);
    var userDataSnapShot = await userDoc.get();
    var userData = userDataSnapShot.data();
    final currentCoins = userData?['coins'] as num? ?? 0;
    final newCoins = currentCoins - int.parse(amount.toString());
    bankAmount.value = int.parse(newCoins.toString());
    batch.update(userDoc, {'coins': newCoins});
    await batch.commit();
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
    final fireStore = FirebaseFirestore.instance;

    // 1. Save the session
    await fireStore.collection('gameSessions').add({
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
    final userDocRef = fireStore.collection('users').doc(userId);
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
    final roomCode = generateRoomCode();
    roomData['roomCode'] = roomCode;

    await FirebaseFirestore.instance
        .collection(roomCollectionPath)
        .doc(roomCode)
        .set(roomData);
    return roomCode;
  }

  Future<void> saveDealingCardsToFireStore(
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

    try {
      final docRef =
          FirebaseFirestore.instance.collection('games').doc(roomCode);
      final docSnap = await docRef.get();

      if (docSnap.exists) {
        final data = docSnap.data() ?? {};
        if (data.containsKey('dealtCards') &&
            data['dealtCards'] != null &&
            (data['dealtCards'] as Map).isNotEmpty) {
          print(
              'Dealt cards already exist in Firestore for room: $roomCode. Skipping generation.');
          return; // Exit early if dealtCards exist
        }
      }

      // Generate unique cards for each player
      for (final uid in playerUid) {
        cardsMap[uid] = [generateUniqueCard(), generateUniqueCard()];
      }

      // Generate unique cards for dealer
      cardsMap['dealer'] = [generateUniqueCard(), generateUniqueCard()];

      if (!docSnap.exists) {
        // Create new document
        await docRef.set({
          'dealtCards': cardsMap,
          'gameState': 'dealing',
          'game': 'BlackJack',
          'lastUpdated': DateTime.now().millisecondsSinceEpoch,
        });
        print('Game document created with dealt cards');
      } else {
        await docRef.update({
          'dealtCards': cardsMap,
          'gameState': 'dealing',
          'lastUpdated': DateTime.now().millisecondsSinceEpoch,
        });
        print('Game document updated with dealt cards');
      }
    } catch (e, s) {
      print('Error saving dealing cards: $e');
      print('Stack trace: $s');
    }
  }

  Future addInvitationData(Map<String, dynamic> invitationData) async {
    await FirebaseFirestore.instance
        .collection('invitations')
        .add(invitationData);
  }
}
