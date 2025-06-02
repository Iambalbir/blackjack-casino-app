import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataModel {
  dynamic uid;
  dynamic firstName;
  dynamic lastName;
  dynamic email;
  dynamic photoURL;
  dynamic authProvider;
  dynamic nickname;
  dynamic isGuest;
  dynamic coins;
  dynamic totalWins;
  dynamic totalLosses;
  dynamic totalGames;
  dynamic leaderboardScore;
  Map<String, GamePlayedStats>? gamesPlayed;
 dynamic createdAt;
 dynamic lastLogin;
 dynamic deviceName;
 dynamic deviceID;
 dynamic deviceVersion;

  UserDataModel({
    this.uid,
    this.firstName,
    this.lastName,
    this.email,
    this.photoURL,
    this.authProvider,
    this.nickname,
    this.isGuest,
    this.coins,
    this.totalWins,
    this.totalLosses,
    this.totalGames,
    this.leaderboardScore,
    this.gamesPlayed,
    this.createdAt,
    this.lastLogin,
    this.deviceName,
    this.deviceID,
    this.deviceVersion,
  });

  UserDataModel.fromJson(Map<String, dynamic> data) {
    uid = data['uid'];
    firstName = data['firstName'] ?? '';
    lastName = data['lastName'] ?? '';
    email = data['email'] ?? '';
    photoURL = data['photoURL'] ?? '';
    authProvider = data['authProvider'] ?? 'unknown';
    nickname = data['nickname'] ?? '';
    isGuest = data['isGuest'] ?? false;
    coins = data['coins'] ?? 0;
    totalWins = data['totalWins'] ?? 0;
    totalLosses = data['totalLosses'] ?? 0;
    totalGames = data['totalGames'] ?? 0;
    leaderboardScore = data['leaderboardScore'] ?? 0;

    final rawGames = data['gamesPlayed'] as Map<String, dynamic>? ?? {};
    gamesPlayed = {};
    rawGames.forEach((key, value) {
      gamesPlayed![key] = GamePlayedStats.fromJson(Map<String, dynamic>.from(value));
    });

    createdAt = data['createdAt'];
    lastLogin = data['lastLogin'];
    deviceName = data['deviceName'] ?? '';
    deviceID = data['deviceID'] ?? '';
    deviceVersion = data['deviceVersion'];
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'photoURL': photoURL,
      'authProvider': authProvider,
      'nickname': nickname,
      'isGuest': isGuest,
      'coins': coins,
      'totalWins': totalWins,
      'totalLosses': totalLosses,
      'totalGames': totalGames,
      'leaderboardScore': leaderboardScore,
      'gamesPlayed': gamesPlayed?.map((key, value) => MapEntry(key, value.toJson())),
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'lastLogin': lastLogin ?? FieldValue.serverTimestamp(),
      'deviceName': deviceName,
      'deviceID': deviceID,
      'deviceVersion': deviceVersion,
    };
  }
}


class GamePlayedStats {
  int wins;
  int losses;
  int played;
  int coinsEarned;
  int coinsSpent;

  GamePlayedStats({
    this.wins = 0,
    this.losses = 0,
    this.played = 0,
    this.coinsEarned = 0,
    this.coinsSpent = 0,
  });

  factory GamePlayedStats.fromJson(Map<String, dynamic> json) {
    return GamePlayedStats(
      wins: json['wins'] ?? 0,
      losses: json['losses'] ?? 0,
      played: json['played'] ?? 0,
      coinsEarned: json['coinsEarned'] ?? 0,
      coinsSpent: json['coinsSpent'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'wins': wins,
      'losses': losses,
      'played': played,
      'coinsEarned': coinsEarned,
      'coinsSpent': coinsSpent,
    };
  }
}
